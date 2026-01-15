# T1D Calculator - QA Testing Plan

## Overview
Comprehensive quality assurance plan for the T1D Insulin Calculator iOS app. This document covers automated testing, manual testing, and validation procedures.

---

## 1. Automated Unit Testing

### Test Coverage Requirements
- **Calculation Logic**: 100% coverage
- **Unit Conversions**: 100% coverage
- **Input Validation**: 100% coverage
- **Rounding Logic**: 100% coverage

### Unit Test Cases

#### Calculation Tests
```swift
// Test file: T1DCalculatorTests.swift (expand existing tests)

1. testBasicCarbDose()
   - Input: 60g carbs, ICR 1:15
   - Expected: 4.0 units

2. testCorrectionDosePositive()
   - Input: BG 180, Target 120, ISF 1:50
   - Expected: 1.2 units correction

3. testCorrectionDoseNegative()
   - Input: BG 90, Target 120, ISF 1:50
   - Expected: -0.6 units (below target warning)

4. testTotalDoseCalculation()
   - Input: 60g carbs, BG 180, Target 120, ICR 1:15, ISF 1:50
   - Expected: 5.2 units total (4.0 + 1.2)

5. testHospitalRounding()
   - 2.2 units → 2.0 units (round down)
   - 2.5 units → 2.5 units (keep half)
   - 2.8 units → 3.0 units (round up)
   - 2.35 units → 2.5 units (round to half)
   - 2.64 units → 2.5 units (round to half)
```

#### Unit Conversion Tests
```swift
6. testMgdlToMmolConversion()
   - 180 mg/dL → 10.0 mmol/L
   - 90 mg/dL → 5.0 mmol/L

7. testMmolToMgdlConversion()
   - 10.0 mmol/L → 180 mg/dL
   - 5.0 mmol/L → 90 mg/dL

8. testISFConversionOnUnitToggle()
   - ISF 50 mg/dL → 2.8 mmol/L
   - ISF 2.8 mmol/L → 50 mg/dL
```

#### Input Validation Tests
```swift
9. testBGValidationMgdl()
   - Valid: 20-600 mg/dL
   - Invalid: <20 or >600

10. testBGValidationMmol()
    - Valid: 1.1-33.3 mmol/L
    - Invalid: <1.1 or >33.3

11. testCarbsValidation()
    - Valid: 0-200g
    - Invalid: <0 or >200

12. testEmptyInputHandling()
    - Empty BG → No calculation
    - Empty carbs → No calculation
```

#### Edge Cases
```swift
13. testZeroCarbs()
    - 0g carbs, BG 180 → Only correction dose

14. testPerfectBG()
    - BG = Target → Only carb dose

15. testVeryHighBG()
    - BG 400, Target 120, ISF 50 → 5.6 units correction

16. testVeryLowBG()
    - BG 50, Target 120, ISF 50 → -1.4 units (warning)
```

---

## 2. Manual Testing Checklist

### UI/UX Testing

#### Visual Design
- [ ] All text is readable (minimum 12pt font)
- [ ] Color contrast meets WCAG AA standards
- [ ] Buttons have clear tap targets (44x44pt minimum)
- [ ] Sliders are easy to adjust
- [ ] Layout works on iPhone SE (small screen)
- [ ] Layout works on iPhone 15 Pro Max (large screen)
- [ ] Layout works on iPad (if supported)
- [ ] Dark mode displays correctly
- [ ] Light mode displays correctly

#### Input Fields
- [ ] Numeric keyboard appears for BG input
- [ ] Numeric keyboard appears for carbs input
- [ ] Keyboard dismisses after input
- [ ] Input fields accept decimal values
- [ ] Input validation prevents invalid characters
- [ ] Placeholder text is helpful

#### Sliders
- [ ] ICR slider range: 5-80 (1:5 to 1:80)
- [ ] ISF slider range: 20-150 mg/dL or 1.1-8.3 mmol/L
- [ ] Slider values update immediately
- [ ] Slider labels show current value
- [ ] Description text updates with slider

#### Unit Toggle
- [ ] Button text changes: "Switch to mmol/L" ↔ "Switch to mg/dL"
- [ ] All BG values convert correctly
- [ ] ISF converts correctly
- [ ] Target BG converts correctly
- [ ] Existing input values convert (if filled)
- [ ] Calculation results update after toggle

#### Insulin Type Selector
- [ ] All 8 insulin types appear in picker
- [ ] Selected type displays in results
- [ ] Selection persists during session

### Calculation Accuracy

#### Test Scenarios

**Scenario 1: Standard Meal**
```
Input:
- Insulin: Humalog
- Target: 120 mg/dL
- ICR: 1:15
- ISF: 1:50
- Current BG: 150 mg/dL
- Carbs: 45g

Expected Result:
- BG difference: 30 mg/dL
- Correction: 0.6 units
- Carb dose: 3.0 units
- Total: 3.6 units
- Rounded: 3.5 units

✅ Pass / ❌ Fail
```

**Scenario 2: High BG**
```
Input:
- Target: 120 mg/dL
- ICR: 1:12
- ISF: 1:40
- Current BG: 280 mg/dL
- Carbs: 60g

Expected Result:
- BG difference: 160 mg/dL
- Correction: 4.0 units
- Carb dose: 5.0 units
- Total: 9.0 units
- Rounded: 9.0 units

✅ Pass / ❌ Fail
```

**Scenario 3: Low BG (Below Target)**
```
Input:
- Target: 120 mg/dL
- ICR: 1:15
- ISF: 1:50
- Current BG: 85 mg/dL
- Carbs: 30g

Expected Result:
- BG difference: -35 mg/dL
- Correction: -0.7 units
- Carb dose: 2.0 units
- Total: 1.3 units
- Rounded: 1.5 units
- Warning: "BG below target" displayed

✅ Pass / ❌ Fail
```

**Scenario 4: mmol/L Units**
```
Input:
- Units: mmol/L
- Target: 6.7 mmol/L (120 mg/dL)
- ICR: 1:15
- ISF: 1:2.8 mmol/L (1:50 mg/dL)
- Current BG: 10.0 mmol/L (180 mg/dL)
- Carbs: 45g

Expected Result:
- BG difference: 3.3 mmol/L
- Correction: ~1.2 units
- Carb dose: 3.0 units
- Total: ~4.2 units
- Rounded: 4.0 units

✅ Pass / ❌ Fail
```

**Scenario 5: Zero Carbs (Correction Only)**
```
Input:
- Target: 120 mg/dL
- ISF: 1:50
- Current BG: 200 mg/dL
- Carbs: 0g

Expected Result:
- BG difference: 80 mg/dL
- Correction: 1.6 units
- Carb dose: 0.0 units
- Total: 1.6 units
- Rounded: 1.5 units

✅ Pass / ❌ Fail
```

### Safety Features

- [ ] Medical disclaimer is prominently displayed
- [ ] Low BG warning appears when BG < Target
- [ ] Warning suggests treating low before dosing
- [ ] Reminder to check BG in 2 hours displays
- [ ] No dose shown until valid inputs entered
- [ ] Calculation steps are transparent and visible

### Clinical Sources

- [ ] Sources section is collapsible
- [ ] All 4-5 sources are listed
- [ ] Links to studies open in Safari
- [ ] Content matches web version
- [ ] ISPAD guidelines note about pediatrics included

---

## 3. Regression Testing

Run these tests after any code changes:

### Quick Regression Suite (5 minutes)
1. [ ] App launches without crash
2. [ ] Basic calculation (Scenario 1 above)
3. [ ] Unit toggle works
4. [ ] Results display correctly
5. [ ] No console errors/warnings

### Full Regression Suite (15 minutes)
1. [ ] All 5 calculation scenarios
2. [ ] All unit tests pass
3. [ ] UI works on 3 different device sizes
4. [ ] Dark/Light mode both work
5. [ ] All insulin types selectable
6. [ ] Sources section expandable
7. [ ] Low BG warning triggers correctly

---

## 4. Performance Testing

### App Launch
- [ ] Cold launch: <2 seconds
- [ ] Warm launch: <1 second
- [ ] No visible lag or stutter

### Calculations
- [ ] Results appear instantly (<100ms)
- [ ] Slider adjustments are smooth (60fps)
- [ ] Unit toggle is instant
- [ ] No memory leaks during extended use

### Memory Usage
- [ ] Initial memory: <50MB
- [ ] After 10 calculations: <60MB
- [ ] No crashes during memory pressure

---

## 5. Accessibility Testing

### VoiceOver
- [ ] All buttons are labeled
- [ ] Slider values are announced
- [ ] Input fields have labels
- [ ] Results are readable by VoiceOver
- [ ] Navigation is logical
- [ ] Warnings are announced

### Dynamic Type
- [ ] Text scales with system font size
- [ ] Layout doesn't break at largest size
- [ ] All text remains readable

### Accessibility Inspector
- [ ] No contrast warnings
- [ ] All elements have accessibility labels
- [ ] Hit targets meet minimum size (44x44pt)

---

## 6. Device Testing Matrix

### iPhone Models
- [ ] iPhone SE (2022) - iOS 17 - Small screen
- [ ] iPhone 14 - iOS 17 - Standard size
- [ ] iPhone 15 Pro Max - iOS 17 - Large screen

### iPad Models (if supported)
- [ ] iPad Pro 12.9" - iOS 17 - Tablet layout
- [ ] iPad Mini - iOS 17 - Small tablet

### iOS Versions
- [ ] iOS 17.0 (minimum supported)
- [ ] iOS 17.5 (latest stable)
- [ ] iOS 18.0 Beta (if available)

---

## 7. User Acceptance Testing

### Real-World Scenarios

**Test with actual T1D users (if possible):**

1. **First-Time User**
   - Can they understand the interface?
   - Is the disclaimer clear?
   - Do they trust the calculation?

2. **Experienced User**
   - Can they input values quickly?
   - Are the defaults reasonable?
   - Would they use this daily?

3. **Pediatric Caregiver**
   - Can parents input child's ratios?
   - Is the low BG warning helpful?
   - Are sources reassuring?

---

## 8. Security & Privacy Testing

- [ ] No data is transmitted off-device
- [ ] No analytics or tracking
- [ ] No internet connection required
- [ ] No personal health data stored
- [ ] App works in Airplane Mode

---

## 9. Error Handling

### Expected Errors
- [ ] Non-numeric input in BG field → Validation prevents
- [ ] Non-numeric input in carbs field → Validation prevents
- [ ] BG out of range → Warning or prevention
- [ ] Carbs >200g → Warning or prevention
- [ ] Empty required fields → No calculation shown

### Unexpected Errors
- [ ] Memory warnings → App continues
- [ ] Background/Foreground → State preserved
- [ ] Force quit → App relaunches cleanly

---

## 10. Release Checklist

### Before TestFlight
- [ ] All unit tests passing
- [ ] All manual tests passing
- [ ] No compiler warnings
- [ ] No SwiftLint warnings (if using)
- [ ] App icon added
- [ ] Launch screen configured
- [ ] Privacy policy included (if App Store)
- [ ] Medical disclaimer prominent

### Before App Store
- [ ] TestFlight beta tested by 10+ users
- [ ] All critical bugs fixed
- [ ] All P0/P1 bugs addressed
- [ ] Medical professional reviewed calculations
- [ ] Legal review of disclaimer (recommended)
- [ ] Screenshots prepared
- [ ] App description written

---

## QA Sign-Off

**Version:** 1.0
**Test Date:** ___________
**Tester:** ___________
**Device:** ___________
**iOS Version:** ___________

**Results:**
- Unit Tests: ✅ Pass / ❌ Fail
- Manual Tests: ✅ Pass / ❌ Fail
- Regression: ✅ Pass / ❌ Fail
- Performance: ✅ Pass / ❌ Fail

**Approved for Release:** ✅ Yes / ❌ No

**Notes:**
_____________________________
_____________________________
_____________________________
