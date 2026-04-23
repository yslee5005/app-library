# Phase 4.1 L10n Review — Japanese (`ja`)

> **Target reviewer**: native Japanese speaker, ideally familiar with
> Christian devotional register for senior readers (50-70).

**Register notes**: Avoid stacking 敬語; warmth over formality

## How to review

For each key:
- Confirm the translation reads naturally to a senior Christian audience
  (warm, reverent, simple — not mechanical or overly formal).
- Check theological nuance: no prosperity framing, no Islamic/Qur'anic
  register leakage (ar), no denominational mismatch.
- Tick the checkbox and leave a brief comment if the line needs
  rewording. Leave comment empty if you approve as-is.

If you need to change a line, propose the new wording in the `suggestion` slot
— a maintainer will apply it to `apps/abba/lib/l10n/app_ja.arb`.

## Source of truth

- English baseline: `apps/abba/lib/l10n/app_en.arb`
- Korean reference: `apps/abba/lib/l10n/app_ko.arb`
- File under review: `apps/abba/lib/l10n/app_ja.arb`

---

## Streaming / Loading states

### `aiStreamingInitial`

- **EN**: Meditating on your prayer...
- **KO**: 당신의 기도를 묵상하고 있어요...
- **JA**: あなたの祈りに想いを巡らせています...

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `aiTierProcessing`

- **EN**: More reflections coming...
- **KO**: 더 많은 이야기가 준비되고 있어요...
- **JA**: さらなる黙想を準備しています...

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `aiScriptureValidating`

- **EN**: Finding the right scripture...
- **KO**: 오늘의 말씀을 찾고 있어요...
- **JA**: ふさわしいみことばを探しています...

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `aiScriptureValidatingFailed`

- **EN**: Preparing this scripture for you...
- **KO**: 이 말씀은 잠시 후 준비됩니다...
- **JA**: このみことばをお届けする準備中です...

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `aiTemplateFallback`

- **EN**: While we prepare your full analysis...
- **KO**: 분석이 완성되는 동안 잠시 묵상해보세요...
- **JA**: 完全な分析を準備している間...

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `aiPendingMore`

- **EN**: Preparing more...
- **KO**: 준비 중...
- **JA**: 準備中...

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `aiTierIncomplete`

- **EN**: Coming soon, check back later
- **KO**: 곧 완성돼요, 잠시 후 다시 확인해주세요
- **JA**: もうすぐ届きます。後ほどご確認ください

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

---

## Tier completion notices

### `tierCompleted`

- **EN**: New reflection added
- **KO**: 새로운 이야기가 도착했어요
- **JA**: 新しい黙想が届きました

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `tierProcessingNotice`

- **EN**: Generating more reflections...
- **KO**: 더 많은 이야기를 만들고 있어요...
- **JA**: さらなる黙想を作成しています...

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

---

## Pro section placeholders

### `proSectionLoading`

- **EN**: Preparing your premium content...
- **KO**: 프리미엄 콘텐츠를 준비 중이에요...
- **JA**: プレミアムコンテンツを準備中です...

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `proSectionWillArrive`

- **EN**: Your deep reflection will appear here
- **KO**: 깊은 묵상이 곧 나타날 거예요
- **JA**: 深い黙想はここに現れます

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

---

## Template categories (⚠️ theological nuance most sensitive)

### `templateCategoryHealth`

- **EN**: For Health Concerns
- **KO**: 건강을 위한 묵상
- **JA**: 健康のための祈り

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `templateCategoryFamily`

- **EN**: For Family
- **KO**: 가족을 위한 묵상
- **JA**: 家族のための祈り

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `templateCategoryWork`

- **EN**: For Work & Studies
- **KO**: 일과 공부를 위한 묵상
- **JA**: 仕事と学びのための祈り

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `templateCategoryGratitude`

- **EN**: A Thankful Heart
- **KO**: 감사의 마음
- **JA**: 感謝の心

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `templateCategoryGrief`

- **EN**: In Grief or Loss
- **KO**: 슬픔과 상실 중에
- **JA**: 悲しみや喪失の中で

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

---

## Section status pills (Calendar / History)

### `sectionStatusCompleted`

- **EN**: Analysis complete
- **KO**: 분석 완료
- **JA**: 分析完了

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `sectionStatusPartial`

- **EN**: Partial analysis (more coming)
- **KO**: 부분 완성 (계속 진행 중)
- **JA**: 部分的な分析(続きが届きます)

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `sectionStatusPending`

- **EN**: Analysis in progress
- **KO**: 분석 진행 중
- **JA**: 分析中

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

---

## Sign-off

- Reviewer name: 
- Review date: 
- Overall verdict: [ ] approved / [ ] needs changes per above
