# T1D Calculator - Testing Quick Start Guide

## Opening the Project in Xcode

### Option 1: Create New Xcode Project (Recommended)

1. **Open Xcode**
2. **File → New → Project**
3. **Select "iOS App"**
4. **Configure:**
   - Product Name: `T1DCalculator`
   - Team: (Your Apple ID)
   - Organization Identifier: `studio.humaine`
   - Bundle Identifier: `studio.humaine.T1DCalculator`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: None
   - Include Tests: **Yes**

5. **Save to:** `/Users/chrismcconnell/GitHub/T1DCalculator`
6. **Replace default files:**
   - Delete the auto-generated `ContentView.swift` and `T1DCalculatorApp.swift`
   - Add existing files via **File → Add Files to "T1DCalculator"...**
   - Select all `.swift` files in the directory

### Option 2: Use Swift Package Manager

```bash
cd /Users/chrismcconnell/GitHub/T1DCalculator
open Package.swift
```

Xcode will open the package. However, note that Swift Packages can't run iOS apps directly - they're better for libraries.

---

## Running Unit Tests

### Using Xcode GUI

1. **Open the Test Navigator:**
   - Press `⌘6` or click the diamond icon in the left sidebar

2. **See all test files:**
   - `T1DCalculatorTests.swift` (original basic tests)
   - `T1DCalculatorTests_Enhanced.swift` (comprehensive test suite)

3. **Run ALL tests:**
   - Press `⌘U`
   - OR: Product → Test

4. **Run a single test file:**
   - Hover over the test file name
   - Click the ▶︎ button

5. **Run a single test:**
   - Hover over the test function
   - Click the ◆ icon in the gutter
   - OR: Click the test name and press `⌃⌥⌘U`

6. **View results:**
   - Green checkmarks ✅ = Passing
   - Red X ❌ = Failing
   - Click failed tests to see details

### Using Command Line

```bash
# Build the project
xcodebuild -scheme T1DCalculator build

# Run all tests
xcodebuild test -scheme T1DCalculator -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test class
xcodebuild test -scheme T1DCalculator -only-testing:T1DCalculatorTests/T1DCalculatorTestsEnhanced

# Run specific test method
xcodebuild test -scheme T1DCalculator -only-testing:T1DCalculatorTests/T1DCalculatorTestsEnhanced/testBasicCarbDose
```

---

## Running the App

### Using iPhone Simulator

1. **Select a simulator:**
   - Click the device selector (top-left, next to scheme)
   - Choose: iPhone 15, iPhone SE, or iPad

2. **Build and run:**
   - Press `⌘R`
   - OR: Product → Run
   - OR: Click the ▶︎ Play button

3. **App opens in simulator:**
   - Interact using mouse/trackpad
   - Use keyboard for typing

### Using Physical Device

1. **Connect iPhone/iPad via USB**
2. **Trust computer on device**
3. **Select device** from device menu
4. **Enable Developer Mode** on device (Settings → Privacy & Security)
5. **Build and run** (`⌘R`)
6. **Trust developer certificate** on device if prompted

---

## QA Testing Workflow

### 1. Automated Testing (5 minutes)

```bash
# Run enhanced test suite
⌘U in Xcode

# Expected results:
✅ 30+ tests passing
✅ 100% calculation coverage
✅ All edge cases handled
```

### 2. Manual UI Testing (15 minutes)

Follow the checklist in `QA_TESTING_PLAN.md`:

**Quick Manual Test:**
1. Launch app
2. Enter: BG = 150, Carbs = 45
3. Verify: ~3.5 units recommended
4. Toggle units to mmol/L
5. Verify: Values convert correctly
6. Test low BG warning (BG = 80)

### 3. Real-World Scenarios (10 minutes)

Test the 5 scenarios in the QA plan:
- Standard meal (BG 150, 45g carbs)
- High BG (BG 280, 60g carbs)
- Low BG (BG 85, 30g carbs)
- mmol/L units
- Zero carbs (correction only)

### 4. Device Testing

Test on multiple devices:
- [ ] iPhone SE (small screen)
- [ ] iPhone 15 (standard)
- [ ] iPhone 15 Pro Max (large)
- [ ] iPad (if supported)

### 5. Accessibility Testing

```bash
# Enable VoiceOver in Simulator:
Settings → Accessibility → VoiceOver → On

# Test:
- Navigate with VoiceOver
- Verify all labels are readable
- Check slider announcements
```

---

## Common Issues & Solutions

### Issue: "No such module 'T1DCalculator'"

**Solution:**
```bash
1. Build the project first (⌘B)
2. Clean build folder (⇧⌘K)
3. Rebuild (⌘B)
```

### Issue: Tests won't run

**Solution:**
```bash
1. Select the test target in scheme
2. Ensure test files are in test target membership
3. Clean and rebuild
```

### Issue: Simulator won't boot

**Solution:**
```bash
1. Quit Xcode
2. Quit Simulator
3. Delete simulator: xcrun simctl delete unavailable
4. Restart Xcode
```

### Issue: Code signing error

**Solution:**
```bash
1. Select project in navigator
2. Select target
3. Signing & Capabilities tab
4. Select your Team from dropdown
5. Let Xcode manage signing automatically
```

---

## Test Coverage Report

### Generate Coverage Report

1. **Enable code coverage:**
   - Edit Scheme (⌘<)
   - Test tab
   - Options → Check "Gather coverage for all targets"

2. **Run tests** (`⌘U`)

3. **View coverage:**
   - Show Report Navigator (`⌘9`)
   - Select latest test report
   - Click "Coverage" tab

4. **Expected coverage:**
   - `InsulinCalculator.swift`: 100%
   - `CalculatorView.swift`: 60-80% (UI harder to test)
   - `ContentView.swift`: 50-70%
   - Overall: 70%+

---

## Performance Testing

### Using Instruments

1. **Profile app:**
   - Product → Profile (`⌘I`)
   - Select "Time Profiler"

2. **Perform calculations:**
   - Enter values
   - Adjust sliders
   - Toggle units
   - Repeat 20+ times

3. **Check results:**
   - Calculation time: <10ms
   - Memory usage: <50MB
   - No memory leaks

### Using XCTest Performance

Add to test file:
```swift
func testCalculationPerformance() {
    calculator.currentBG = "180"
    calculator.carbs = "45"

    measure {
        _ = calculator.calculationResult
    }
}
```

Expected: <0.001s per calculation

---

## Continuous Integration (Future)

### GitHub Actions Workflow

```yaml
# .github/workflows/ios-tests.yml
name: iOS Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tests
        run: |
          xcodebuild test \
            -scheme T1DCalculator \
            -destination 'platform=iOS Simulator,name=iPhone 15'
```

---

## Sign-Off Checklist

Before releasing:

- [ ] All unit tests passing (30+ tests)
- [ ] Manual UI tests completed
- [ ] All 5 real-world scenarios verified
- [ ] Tested on 3+ device sizes
- [ ] VoiceOver accessibility verified
- [ ] Dark/Light mode both work
- [ ] Medical disclaimer visible
- [ ] Clinical sources accessible
- [ ] No compiler warnings
- [ ] Code coverage >70%

**Approved by:** ___________
**Date:** ___________
**Version:** 1.0

---

## Questions?

- Review full QA plan: `QA_TESTING_PLAN.md`
- Check test implementations: `T1DCalculatorTests_Enhanced.swift`
- See calculation logic: `InsulinCalculator.swift`
