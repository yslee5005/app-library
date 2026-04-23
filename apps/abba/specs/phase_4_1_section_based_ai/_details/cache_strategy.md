# Cache 전략 — Strategy B (공유 영어 cache, Lazy 생성)

## 결정

**Strategy B 채택 (85% 신뢰도, agent 분석)**
- 단일 영어 rubric cache를 35 locale이 모두 공유
- Lazy 생성 (첫 유저 호출 시 생성, 이후 재사용)
- pg_cron 없음 (단순화)

## 비교 (1K MAU, 22,500 prayers/월)

| 전략 | 월 비용 | 유지보수 | 결정 |
|------|--------|---------|------|
| A (35 per-locale cache) | $300 | 35시간/update | ❌ Solo dev 불가능 |
| **B (공유 영어 cache)** | **$128** | **30분/update** | ✅ **채택** |
| C (hybrid) | $149 | 1시간/update | ⏳ 출시 후 품질 저하 locale만 승격 |

## B 전략 근거

1. **비용 57% 절감** (A 대비 월 $171)
2. **Gemini 2.5 Flash는 35 locale 네이티브 지원** — 영어 prompt + locale output 품질 저하 <5%
3. **업계 선례**: Duolingo Max (40+ locale), Google Translate, Character.AI 모두 universal English system prompt
4. **저자원 locale (Amharic, Burmese) cache miss 문제 자동 해결** — 공유 cache는 모든 locale traffic이 hit
5. **36번째 locale 추가 시 zero-code** — `{{LANG_NAME}}` 변수만 교체

## Lazy 생성 플로우

```dart
class GeminiCacheManager {
  final SupabaseClient _supabase;
  final GenerativeModel _client;
  
  Future<String> getOrCreateCache({required String mode}) async {
    // mode: 'prayer' | 'qt'
    final config = await _fetchSystemConfig();
    final cacheId = config['${mode}_cache_id'];
    final expiresAt = config['${mode}_cache_expires_at'];
    final storedHash = config['${mode}_rubrics_version'];
    final currentHash = await _computeBundleHash(mode);
    
    // 1. Hash mismatch → rubric 변경됨, 강제 재생성
    if (storedHash != currentHash) {
      return await _createAndSave(mode, currentHash);
    }
    
    // 2. 만료 임박 (5분 여유) → 재생성
    if (cacheId == null || expiresAt == null ||
        DateTime.parse(expiresAt).isBefore(
          DateTime.now().add(Duration(minutes: 5)))) {
      return await _createAndSave(mode, currentHash);
    }
    
    // 3. Cache 살아있음 → 재사용
    return cacheId;
  }
  
  Future<String> _createAndSave(String mode, String hash) async {
    // 1. Rubric bundle 읽기 (assets)
    final rubricContent = await _loadRubricBundle(mode);
    
    // 2. Gemini cache 생성
    final cache = await _client.caches.create(
      model: 'gemini-2.5-flash',
      config: CreateCachedContentConfig(
        systemInstruction: Content.system(rubricContent),
        ttl: '86400s',  // 24h
      ),
    );
    
    // 3. system_config UPDATE
    await _supabase.from('system_config').upsert([
      {'key': '${mode}_cache_id', 'value': cache.name},
      {'key': '${mode}_cache_expires_at', 
       'value': cache.expireTime.toIso8601String()},
      {'key': '${mode}_rubrics_version', 'value': hash},
    ]);
    
    return cache.name;
  }
  
  Future<String> _computeBundleHash(String mode) async {
    // assets/prompts/{mode}/*.md 파일 전체 SHA256
    final files = await _listAssetFiles('assets/prompts/$mode/');
    final bytes = <int>[];
    for (final f in files..sort()) {
      bytes.addAll(await rootBundle.load(f).then((b) => b.buffer.asUint8List()));
    }
    return sha256.convert(bytes).toString();
  }
}
```

## Gemini 호출 시 Cache 사용

```dart
Future<Tier1Result> analyzeTier1({
  required String transcript,
  required String locale,
}) async {
  final cacheId = await cacheManager.getOrCreateCache(mode: 'prayer');
  
  final response = await _model.generateContentStream([
    Content('user', [TextPart(_buildUserPrompt(transcript, locale, tier: 't1'))]),
  ], config: GenerateContentConfig(
    cachedContent: cacheId,  // ← cache 참조
    responseSchema: _tier1Schema,
    temperature: 0.9,
  ));
  
  // stream 처리...
}
```

**참고**: `cachedContent` 파라미터 전달 시 Gemini는 시스템 instruction을 cache에서 읽고, 유저 prompt만 새로 받음 → 83% input cost 절감.

## Cache TTL 전략

- **TTL: 24시간** (Gemini 최대 허용)
- **만료 5분 전**: 재생성 트리거 (유저 대기 없이 미리)
- **만료 후**: 다음 호출이 재생성 (500ms 추가, T1 호출에 묻힘)

## Cache 비용 (1K MAU)

```
- Cache storage: 7K tokens × $1/M × 24h = $0.168/일 × 30 = $5.04/월
- Cached input per call: 7K × $0.05/M × 22,500 calls = $7.88/월
- 일반 input (transcript, T1/T2/T3 directive): 500 × $0.30/M × 22,500 = $3.38/월
────────────────────────────────
Input layer 총합: ~$16.30/월
```

Cache 없이 전체 input 정가로 호출 시:
```
7,500 × $0.30/M × 22,500 = $50.63/월
```

→ **$34.33/월 절감 (68%)**. 트래픽 10배면 절감액도 10배.

## Cache Miss 대응 (Graceful Degradation)

```dart
try {
  final cacheId = await cacheManager.getOrCreateCache(mode: 'prayer');
  return await _callWithCache(cacheId, ...);
} catch (e) {
  apiLog.warning('[Cache] miss or create failed, falling back', error: e);
  return await _callWithoutCache(...);  // 정가로 호출
}
```

**결과**: 
- Cache 시스템 장애 시에도 앱 정상 동작
- 비용만 일시적 상승 (모니터링 알림)

## Rubric 변경 워크플로우

개발자가 `apps/abba/assets/prompts/prayer/scripture_rubric.md` 수정 후 앱 재배포:

1. 앱 빌드 → bundle에 새 rubric 포함
2. 유저 앱 업데이트 후 첫 기도
3. `getOrCreateCache` 호출 → bundle hash 재계산
4. Stored hash ≠ current hash → **자동 cache 재생성**
5. 이후 유저 모두 새 rubric 기반 응답 수신

**장점**: 서버 재시작, 수동 cache invalidation 불필요. Client-driven cache versioning.

## 초기 설정 (1회)

Supabase Studio에서 초기값 확인 (migration에 seed 포함):
```
system_config:
  prayer_cache_id: null
  prayer_cache_expires_at: null
  prayer_rubrics_version: ""
  qt_cache_id: null
  qt_cache_expires_at: null
  qt_rubrics_version: ""
```

첫 유저 기도 시:
1. prayer_rubrics_version `""` ≠ 현재 hash → cache 생성
2. cache_id, expires_at, version 저장
3. 이후 유저는 cache 재사용

## 저자원 locale 모니터링 (Phase 2 판단 지표)

출시 후 2-4주 측정:
- 아랍어/히브리어/암하라어/버마어 유저 human eval
- 기도문 "번역된 느낌" 감지율 > 30% 시 → 해당 locale만 C 하이브리드 전환 (locale appendix cache 추가)

## Edge Function에서 cache 사용

`process_pending_prayer` Edge Function도 동일 cache 공유:

```typescript
async function getCacheId(supabase, mode: 'prayer' | 'qt'): Promise<string | null> {
  const { data } = await supabase
    .from('system_config')
    .select('value')
    .eq('key', `${mode}_cache_id`)
    .maybeSingle();
  return data?.value ?? null;
}
```

**주의**: Edge Function은 rubric bundle에 접근 못 함 (Supabase Storage에 rubric md 올리거나 Edge Function에 embed 가능). 
→ **결정**: Edge Function은 cache miss 시 정가로 호출 (fallback). Cache 관리는 client 전담.

## 롤백 시나리오

Cache 전략이 실패할 경우 (예: Gemini caching API 장애):
```dart
// Feature flag로 cache 전체 bypass
if (AppConfig.enableGeminiCache) {
  return await _callWithCache(...);
}
return await _callWithoutCache(...);
```

`ENABLE_GEMINI_CACHE=false`로 설정하면 모든 호출이 정가. 비용만 상승, 기능 동일.
