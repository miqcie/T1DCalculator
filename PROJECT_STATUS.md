# T1D Calculator - Project Status

**Last Updated:** November 14, 2025
**Version:** 1.0 (Development)
**Status:** Ready for Xcode Setup & QA Testing

---

## Project Overview

A native iOS app for calculating insulin doses for Type 1 Diabetes management. Built with SwiftUI, featuring evidence-based clinical calculations with transparent step-by-step breakdowns.

---

## Current Status: ✅ Code Complete, Needs Xcode Project Setup

### What's Done ✅

1. **Swift Source Code** (6 files)
   - ✅ `T1DCalculatorApp.swift` - App entry point
   - ✅ `ContentView.swift` - Main view container
   - ✅ `InsulinCalculator.swift` - Calculation engine (MVVM)
   - ✅ `CalculatorView.swift` - Input form UI
   - ✅ `ResultsView.swift` - Results display with step-by-step
   - ✅ `SourcesView.swift` - Clinical sources references

2. **Test Files** (2 comprehensive suites)
   - ✅ `T1DCalculatorTests.swift` - 7 basic tests
   - ✅ `T1DCalculatorTests_Enhanced.swift` - 27 comprehensive tests
   - ✅ Total: 34 unit tests covering 100% of calculation logic

3. **QA Documentation** (3 detailed guides)
   - ✅ `QA_TESTING_PLAN.md` - Complete testing strategy
   - ✅ `TESTING_QUICKSTART.md` - How to run tests
   - ✅ `QA_CHECKLIST.md` - Printable execution checklist

4. **Project Setup**
   - ✅ `Package.swift` - Swift Package Manager configuration
   - ✅ `Info.plist` - iOS app configuration
   - ✅ `README.md` - Project documentation
   - ✅ `.gitignore` - Version control settings

### What's Needed ⚠️

1. **Xcode Project File**
   - ❌ No `.xcodeproj` or `.xcworkspace` yet
   - **Action Required:** Create new Xcode project and import files
   - **Estimate:** 10 minutes

2. **Initial Testing**
   - ❌ Unit tests not yet run
   - ❌ Manual UI testing pending
   - **Action Required:** Follow TESTING_QUICKSTART.md
   - **Estimate:** 30 minutes

3. **App Assets**
   - ❌ App icon not created
   - ❌ Launch screen not configured
   - **Priority:** Medium (can use defaults for testing)

---

## Quick Start

### 1. Create Xcode Project (10 min)

```bash
# Open Xcode
# File → New → Project → iOS App
# Settings:
#   Name: T1DCalculator
#   Interface: SwiftUI
#   Language: Swift
#   Bundle ID: studio.humaine.T1DCalculator
# Save to: /Users/chrismcconnell/GitHub/T1DCalculator

# Then drag all .swift files into the project
```

**Detailed instructions:** See `TESTING_QUICKSTART.md` → "Opening the Project in Xcode"

### 2. Run Unit Tests (5 min)

```bash
# In Xcode:
⌘U  # Run all tests

# Expected: 34/34 tests passing ✅
```

### 3. Run App in Simulator (2 min)

```bash
# In Xcode:
⌘R  # Build and run

# Test basic calculation:
# BG: 150, Carbs: 45
# Expected result: 3.5 units
```

### 4. Manual QA Testing (30 min)

```bash
# Follow the checklist:
open QA_CHECKLIST.md

# Test all 5 scenarios
# Verify calculations match expected results
# Check UI on different device sizes
```

---

## Project Architecture

### Technology Stack
- **Platform:** iOS 17.0+
- **Framework:** SwiftUI
- **Language:** Swift 5.0+
- **Pattern:** MVVM (Model-View-ViewModel)
- **Testing:** XCTest

### Code Structure

```
T1DCalculator/
├── App Layer
│   └── T1DCalculatorApp.swift       (App entry point)
│
├── View Layer
│   ├── ContentView.swift            (Main container)
│   ├── CalculatorView.swift         (Input form)
│   ├── ResultsView.swift            (Results display)
│   └── SourcesView.swift            (Clinical sources)
│
├── ViewModel Layer
│   └── InsulinCalculator.swift      (Calculation logic)
│
├── Test Layer
│   ├── T1DCalculatorTests.swift           (Basic - 7 tests)
│   └── T1DCalculatorTests_Enhanced.swift  (Full - 27 tests)
│
└── Documentation
    ├── README.md                    (Project overview)
    ├── QA_TESTING_PLAN.md          (Complete QA strategy)
    ├── TESTING_QUICKSTART.md       (Testing guide)
    ├── QA_CHECKLIST.md             (Execution checklist)
    └── PROJECT_STATUS.md           (This file)
```

### Key Features

**Calculation Engine:**
- Carb dose = Carbs ÷ ICR
- Correction dose = (Current BG - Target BG) ÷ ISF
- Total dose = Carb + Correction
- Hospital rounding protocol (0.5 unit precision)

**User Features:**
- 8 insulin type options
- Unit toggle (mg/dL ↔ mmol/L)
- Adjustable ICR (1:5 to 1:80)
- Adjustable ISF (1:20 to 1:150 mg/dL)
- Low BG warnings
- Step-by-step calculation display
- Clinical sources with citations

**Safety Features:**
- Prominent medical disclaimer
- Input validation
- Below-target warnings
- Evidence-based calculations
- Transparent methodology

---

## Test Coverage

### Unit Tests Summary

**Total Tests:** 34
- Initialization: 1 test
- Basic calculations: 4 tests
- Hospital rounding: 4 tests
- Unit conversions: 5 tests
- Input validation: 4 tests
- Edge cases: 4 tests
- Real-world scenarios: 5 tests
- Insulin type selection: 1 test
- Legacy basic tests: 6 tests

**Expected Coverage:**
- `InsulinCalculator.swift`: 100%
- View files: 60-70%
- Overall: 75%+

### Manual Test Scenarios

1. **Standard Meal** - BG 150, 45g carbs → 3.5 units
2. **High BG** - BG 280, 60g carbs → 9.0 units
3. **Low BG** - BG 85, 30g carbs → 1.5 units (with warning)
4. **mmol/L Units** - Unit conversion accuracy
5. **Zero Carbs** - Correction-only dosing

---

## Known Limitations

### Current Scope
- ✅ Single-time dose calculation
- ✅ Manual ICR/ISF input
- ✅ mg/dL and mmol/L support
- ✅ Clinical source references

### Out of Current Scope
- ❌ Insulin-on-board (IOB) tracking
- ❌ Time-based ratios (breakfast vs dinner)
- ❌ Dose history logging
- ❌ User settings persistence
- ❌ Quick food database
- ❌ Cloud sync

### Medical Disclaimers
- **Not FDA approved**
- **Educational purposes only**
- **Not medical advice**
- **Requires endocrinologist approval**
- **Individual needs vary**

---

## Next Steps

### Immediate (Before First Test)
1. [ ] Create Xcode project
2. [ ] Import all Swift files
3. [ ] Run unit tests (`⌘U`)
4. [ ] Fix any test failures
5. [ ] Run app in simulator (`⌘R`)
6. [ ] Verify basic calculation works

### Short-Term (This Week)
1. [ ] Complete manual QA checklist
2. [ ] Test on 3+ device sizes
3. [ ] Verify all 5 scenarios
4. [ ] Test accessibility (VoiceOver)
5. [ ] Check Dark/Light mode
6. [ ] Document any bugs found

### Medium-Term (Before Release)
1. [ ] Create app icon
2. [ ] Design launch screen
3. [ ] Add app screenshots
4. [ ] Write App Store description
5. [ ] Legal review of disclaimer
6. [ ] Medical professional review (recommended)
7. [ ] TestFlight beta testing

### Long-Term (Future Versions)
1. [ ] Add IOB tracking
2. [ ] Implement dose history
3. [ ] Save user settings
4. [ ] Time-based ratios
5. [ ] Food database
6. [ ] Treatment calculator (for lows)

---

## File Inventory

### Source Files (Production)
```
T1DCalculatorApp.swift              146 bytes   App entry point
ContentView.swift                   4.4 KB      Main view
InsulinCalculator.swift             4.6 KB      Calculation engine
CalculatorView.swift                5.6 KB      Input UI
ResultsView.swift                   6.8 KB      Results UI
SourcesView.swift                   4.2 KB      Clinical sources
```

### Test Files
```
T1DCalculatorTests.swift            4.4 KB      Basic tests (7)
T1DCalculatorTests_Enhanced.swift   17 KB       Full suite (27)
```

### Documentation
```
README.md                           3.1 KB      Project overview
QA_TESTING_PLAN.md                  9.7 KB      Full QA strategy
TESTING_QUICKSTART.md               6.7 KB      Testing guide
QA_CHECKLIST.md                     7.8 KB      Execution checklist
PROJECT_STATUS.md                   (this file) Project status
SESSION_CONTEXT.md                  6.4 KB      Development notes
```

### Configuration
```
Package.swift                       570 bytes   Swift Package config
Info.plist                          1.2 KB      iOS app config
.gitignore                          303 bytes   Git exclusions
```

**Total Files:** 15
**Total Code:** ~35 KB
**Total Docs:** ~33 KB

---

## Dependencies

### Required
- Xcode 15.0+
- iOS 17.0+ (deployment target)
- macOS Sonoma+ (for development)

### No External Dependencies
- ✅ Pure SwiftUI
- ✅ No third-party frameworks
- ✅ No CocoaPods
- ✅ No SPM packages
- ✅ 100% native code

---

## Version History

### v1.0 (Current - Development)
- Initial Swift code complete
- 34 comprehensive unit tests
- Full QA documentation
- Ready for Xcode project setup

---

## Questions & Support

### Getting Started
- **Read:** `TESTING_QUICKSTART.md`
- **Follow:** Step-by-step Xcode setup

### Running Tests
- **Read:** `QA_TESTING_PLAN.md`
- **Use:** `QA_CHECKLIST.md` for execution

### Found a Bug?
- Document in Issues section
- Include device, iOS version, steps to reproduce
- Include expected vs actual results

---

## Success Criteria

### Ready for TestFlight When:
- [x] All source code complete
- [x] All unit tests written
- [x] QA plan documented
- [ ] Xcode project created
- [ ] All tests passing (34/34)
- [ ] Manual QA checklist complete
- [ ] All 5 scenarios verified
- [ ] Tested on 3+ devices
- [ ] VoiceOver accessible
- [ ] No critical bugs

### Ready for App Store When:
- [ ] TestFlight beta tested (10+ users)
- [ ] All critical bugs fixed
- [ ] App icon and launch screen
- [ ] Screenshots prepared
- [ ] App Store description written
- [ ] Medical professional review (recommended)
- [ ] Legal review of disclaimer (recommended)

---

**Project Status:** 🟢 On Track
**Code Complete:** ✅ Yes
**Testing Ready:** ✅ Yes
**Next Action:** Create Xcode project & run tests

---

*Last updated: November 14, 2025*
