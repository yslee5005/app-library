# Phase 4.1 L10n Review — Arabic (`ar`)

> **Target reviewer**: native Arabic speaker, ideally familiar with
> Christian devotional register for senior readers (50-70).

**Register notes**: MSA; distinguish from Qur'anic/Islamic register

## How to review

For each key:
- Confirm the translation reads naturally to a senior Christian audience
  (warm, reverent, simple — not mechanical or overly formal).
- Check theological nuance: no prosperity framing, no Islamic/Qur'anic
  register leakage (ar), no denominational mismatch.
- Tick the checkbox and leave a brief comment if the line needs
  rewording. Leave comment empty if you approve as-is.

If you need to change a line, propose the new wording in the `suggestion` slot
— a maintainer will apply it to `apps/abba/lib/l10n/app_ar.arb`.

## Source of truth

- English baseline: `apps/abba/lib/l10n/app_en.arb`
- Korean reference: `apps/abba/lib/l10n/app_ko.arb`
- File under review: `apps/abba/lib/l10n/app_ar.arb`

---

## Streaming / Loading states

### `aiStreamingInitial`

- **EN**: Meditating on your prayer...
- **KO**: 당신의 기도를 묵상하고 있어요...
- **AR**: نتأمل في صلاتك...

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `aiTierProcessing`

- **EN**: More reflections coming...
- **KO**: 더 많은 이야기가 준비되고 있어요...
- **AR**: المزيد من التأملات قادمة...

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `aiScriptureValidating`

- **EN**: Finding the right scripture...
- **KO**: 오늘의 말씀을 찾고 있어요...
- **AR**: نبحث عن الآية المناسبة...

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `aiScriptureValidatingFailed`

- **EN**: Preparing this scripture for you...
- **KO**: 이 말씀은 잠시 후 준비됩니다...
- **AR**: نعدّ هذه الآية من أجلك...

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `aiTemplateFallback`

- **EN**: While we prepare your full analysis...
- **KO**: 분석이 완성되는 동안 잠시 묵상해보세요...
- **AR**: بينما نعدّ تحليلك الكامل...

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `aiPendingMore`

- **EN**: Preparing more...
- **KO**: 준비 중...
- **AR**: نُعدّ المزيد...

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `aiTierIncomplete`

- **EN**: Coming soon, check back later
- **KO**: 곧 완성돼요, 잠시 후 다시 확인해주세요
- **AR**: قريبًا، يرجى التحقق لاحقًا

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

---

## Tier completion notices

### `tierCompleted`

- **EN**: New reflection added
- **KO**: 새로운 이야기가 도착했어요
- **AR**: تمت إضافة تأمل جديد

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `tierProcessingNotice`

- **EN**: Generating more reflections...
- **KO**: 더 많은 이야기를 만들고 있어요...
- **AR**: نُنشئ المزيد من التأملات...

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

---

## Pro section placeholders

### `proSectionLoading`

- **EN**: Preparing your premium content...
- **KO**: 프리미엄 콘텐츠를 준비 중이에요...
- **AR**: نُحضّر محتواك المميز...

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `proSectionWillArrive`

- **EN**: Your deep reflection will appear here
- **KO**: 깊은 묵상이 곧 나타날 거예요
- **AR**: سيظهر تأملك العميق هنا

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

---

## Template categories (⚠️ theological nuance most sensitive)

### `templateCategoryHealth`

- **EN**: For Health Concerns
- **KO**: 건강을 위한 묵상
- **AR**: من أجل المخاوف الصحية

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `templateCategoryFamily`

- **EN**: For Family
- **KO**: 가족을 위한 묵상
- **AR**: من أجل العائلة

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `templateCategoryWork`

- **EN**: For Work & Studies
- **KO**: 일과 공부를 위한 묵상
- **AR**: من أجل العمل والدراسات

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `templateCategoryGratitude`

- **EN**: A Thankful Heart
- **KO**: 감사의 마음
- **AR**: قلب شاكر

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `templateCategoryGrief`

- **EN**: In Grief or Loss
- **KO**: 슬픔과 상실 중에
- **AR**: في الحزن أو الفقدان

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

---

## Section status pills (Calendar / History)

### `sectionStatusCompleted`

- **EN**: Analysis complete
- **KO**: 분석 완료
- **AR**: اكتمل التحليل

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `sectionStatusPartial`

- **EN**: Partial analysis (more coming)
- **KO**: 부분 완성 (계속 진행 중)
- **AR**: تحليل جزئي (المزيد قادم)

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

### `sectionStatusPending`

- **EN**: Analysis in progress
- **KO**: 분석 진행 중
- **AR**: التحليل قيد التقدم

- [ ] Approved as-is
- Comment: 
- Suggested rewording (if needed): 

---

## Sign-off

- Reviewer name: 
- Review date: 
- Overall verdict: [ ] approved / [ ] needs changes per above
