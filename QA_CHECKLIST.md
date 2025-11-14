# T1D Calculator - QA Test Execution Checklist

**Version:** 1.0
**Tester:** ________________
**Date:** ________________
**Device:** ________________
**iOS Version:** ________________

---

## Pre-Flight Checks

- [ ] Xcode project opens without errors
- [ ] All Swift files compile successfully
- [ ] No compiler warnings
- [ ] Project builds (`⌘B`)

---

## Unit Tests (`⌘U`)

### T1DCalculatorTests.swift (Basic)
- [ ] testInsulinCalculatorInitialization
- [ ] testUnitConversion
- [ ] testDoseCalculation
- [ ] testRoundingLogic
- [ ] testUnitToggle
- [ ] testValidation
- [ ] testLowBGWarning

**Result:** _____ / 7 passing

### T1DCalculatorTests_Enhanced.swift (Comprehensive)
- [ ] Initialization tests (1)
- [ ] Basic calculation tests (4)
- [ ] Hospital rounding tests (4)
- [ ] Unit conversion tests (5)
- [ ] Input validation tests (4)
- [ ] Edge case tests (4)
- [ ] Real-world scenario tests (4)
- [ ] Insulin type tests (1)

**Result:** _____ / 27 passing

**Total Unit Tests:** _____ / 34 passing

---

## Manual UI Testing

### Launch & Layout
- [ ] App launches successfully
- [ ] Medical disclaimer visible
- [ ] All UI elements render correctly
- [ ] No layout overlap or truncation

### Input Fields
- [ ] Insulin type picker works
- [ ] Target BG accepts numeric input
- [ ] Current BG accepts numeric input
- [ ] Carbs accepts numeric input
- [ ] Numeric keyboard appears for number fields

### Sliders
- [ ] ICR slider (5-80) adjusts smoothly
- [ ] ICR value updates in real-time
- [ ] ISF slider (20-150 mg/dL) adjusts smoothly
- [ ] ISF value updates in real-time
- [ ] Slider descriptions update correctly

### Unit Toggle
- [ ] Button text: "Switch to mmol/L"
- [ ] Toggle converts all values correctly
- [ ] Button text: "Switch to mg/dL"
- [ ] Toggle back converts correctly
- [ ] Calculation updates after toggle

### Results Display
- [ ] Results hidden when inputs empty
- [ ] Placeholder shows: "Enter current BG..."
- [ ] Results appear when inputs valid
- [ ] 5 calculation steps display
- [ ] Recommended dose displays large
- [ ] Insulin type name shows in results
- [ ] Rounding rules visible
- [ ] Reminder shows: "Check in 2 hours"

### Low BG Warning
- [ ] Warning appears when BG < Target
- [ ] Warning text accurate
- [ ] Suggestion to treat low first

### Sources Section
- [ ] "Show Clinical Sources" button works
- [ ] Section expands/collapses
- [ ] All 4-5 sources listed
- [ ] External links work (open Safari)

---

## Calculation Accuracy

### Scenario 1: Standard Meal
**Input:**
- Target: 120 mg/dL
- ICR: 1:15
- ISF: 1:50
- BG: 150 mg/dL
- Carbs: 45g

**Expected Output:**
- BG diff: 30 mg/dL
- Correction: 0.6 units
- Carb dose: 3.0 units
- Total: 3.6 units
- **Rounded: 3.5 units**

**Actual Output:** _______ units

- [ ] ✅ PASS / ❌ FAIL

---

### Scenario 2: High BG
**Input:**
- Target: 120 mg/dL
- ICR: 1:12
- ISF: 1:40
- BG: 280 mg/dL
- Carbs: 60g

**Expected Output:**
- BG diff: 160 mg/dL
- Correction: 4.0 units
- Carb dose: 5.0 units
- Total: 9.0 units
- **Rounded: 9.0 units**

**Actual Output:** _______ units

- [ ] ✅ PASS / ❌ FAIL

---

### Scenario 3: Low BG (Below Target)
**Input:**
- Target: 120 mg/dL
- ICR: 1:15
- ISF: 1:50
- BG: 85 mg/dL
- Carbs: 30g

**Expected Output:**
- BG diff: -35 mg/dL
- Correction: -0.7 units
- Carb dose: 2.0 units
- Total: 1.3 units
- **Rounded: 1.5 units**
- **Warning: Low BG**

**Actual Output:** _______ units

- [ ] ✅ PASS / ❌ FAIL
- [ ] Warning displayed

---

### Scenario 4: mmol/L Units
**Input:**
- Units: **mmol/L**
- Target: 6.7 mmol/L
- ICR: 1:15
- ISF: 1:2.8 mmol/L
- BG: 10.0 mmol/L
- Carbs: 45g

**Expected Output:**
- BG diff: ~3.3 mmol/L
- Correction: ~1.2 units
- Carb dose: 3.0 units
- Total: ~4.2 units
- **Rounded: 4.0 units**

**Actual Output:** _______ units

- [ ] ✅ PASS / ❌ FAIL

---

### Scenario 5: Zero Carbs (Correction Only)
**Input:**
- Target: 120 mg/dL
- ISF: 1:50
- BG: 200 mg/dL
- Carbs: **0g**

**Expected Output:**
- BG diff: 80 mg/dL
- Correction: 1.6 units
- Carb dose: 0.0 units
- Total: 1.6 units
- **Rounded: 1.5 units**

**Actual Output:** _______ units

- [ ] ✅ PASS / ❌ FAIL

---

## Device Testing

### iPhone SE (Small Screen)
- [ ] All text readable
- [ ] No layout overflow
- [ ] Buttons reachable
- [ ] Sliders usable

### iPhone 15 (Standard)
- [ ] Layout optimal
- [ ] Spacing appropriate
- [ ] All elements accessible

### iPhone 15 Pro Max (Large)
- [ ] Layout scales well
- [ ] No excessive whitespace
- [ ] Content centered

### iPad (if supported)
- [ ] Landscape orientation works
- [ ] Portrait orientation works
- [ ] Layout appropriate for tablet

---

## Appearance

### Light Mode
- [ ] All text legible
- [ ] Good contrast
- [ ] Colors appropriate
- [ ] No visual glitches

### Dark Mode
- [ ] Switches automatically
- [ ] All text legible
- [ ] Good contrast
- [ ] Colors appropriate

---

## Accessibility

### VoiceOver
- [ ] Enable: Settings → Accessibility → VoiceOver
- [ ] Navigate through app
- [ ] All elements have labels
- [ ] Slider values announced
- [ ] Buttons readable
- [ ] Results readable

### Dynamic Type
- [ ] Settings → Accessibility → Display → Larger Text
- [ ] Set to largest size
- [ ] Reopen app
- [ ] All text scales
- [ ] Layout doesn't break
- [ ] Still readable

---

## Performance

### App Launch
- [ ] Cold launch <2 seconds
- [ ] Warm launch <1 second
- [ ] No visible lag

### Calculations
- [ ] Results instant (<100ms)
- [ ] Slider drag smooth (60fps)
- [ ] Unit toggle instant
- [ ] No stuttering

### Memory
- [ ] Initial usage <50MB
- [ ] After 10 calcs <60MB
- [ ] No crashes
- [ ] No memory warnings

---

## Safety & Compliance

### Medical Disclaimer
- [ ] Disclaimer visible on launch
- [ ] Warning icon present
- [ ] Text clear and prominent
- [ ] "Educational purposes only" stated
- [ ] "Consult endocrinologist" stated

### Clinical Sources
- [ ] All sources listed
- [ ] Links to studies work
- [ ] ISPAD guidelines mentioned
- [ ] ADA Standards referenced
- [ ] Walsh formulas cited

### Privacy
- [ ] No data transmitted
- [ ] Works in Airplane Mode
- [ ] No analytics
- [ ] No tracking
- [ ] No login required

---

## Edge Cases

### Boundary Values
- [ ] BG = 20 mg/dL (minimum)
- [ ] BG = 600 mg/dL (maximum)
- [ ] Carbs = 0g
- [ ] Carbs = 200g (maximum)
- [ ] ICR = 1:5 (minimum slider)
- [ ] ICR = 1:80 (maximum slider)

### Invalid Inputs
- [ ] Non-numeric BG → prevented
- [ ] BG <20 → invalid
- [ ] BG >600 → invalid
- [ ] Negative carbs → invalid
- [ ] Carbs >200 → invalid

### Error Handling
- [ ] Empty BG → no calculation
- [ ] Empty carbs → no calculation
- [ ] Background/Foreground → state preserved
- [ ] Force quit → relaunches cleanly

---

## Regression Tests

Run after any code changes:

- [ ] App launches
- [ ] Standard meal scenario passes
- [ ] Unit toggle works
- [ ] All unit tests pass
- [ ] No new warnings
- [ ] No new crashes

---

## Final Sign-Off

### Test Summary

**Total Tests:** 150+
**Passed:** _______
**Failed:** _______
**Pass Rate:** _______%

### Critical Issues

1. _________________________________
2. _________________________________
3. _________________________________

### Non-Critical Issues

1. _________________________________
2. _________________________________
3. _________________________________

### Recommendations

_________________________________
_________________________________
_________________________________

---

### Approval

- [ ] **APPROVED FOR RELEASE**
- [ ] **NEEDS FIXES** (see issues above)
- [ ] **NOT READY** (major issues)

**Tester Signature:** ________________
**Date:** ________________

**Technical Reviewer:** ________________
**Date:** ________________

**Medical Reviewer (if applicable):** ________________
**Date:** ________________

---

## Notes

_________________________________
_________________________________
_________________________________
_________________________________
_________________________________
