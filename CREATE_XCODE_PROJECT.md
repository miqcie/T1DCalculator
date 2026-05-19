# Creating Your T1D Calculator Xcode Project

**Goal:** Convert your Swift code into a working iOS app

**Time Required:** 5 minutes

---

## Prerequisites

✅ You already have all the Swift code!
✅ Overlapping sources error is fixed
✅ Ready to create Xcode project

---

## Step-by-Step Instructions

### 1. Open Xcode (2 minutes)

1. **Launch Xcode**
2. Click **File → New → Project** (or press ⇧⌘N)
3. Select **iOS** tab at the top
4. Choose **App** template
5. Click **Next**

### 2. Configure Project Settings (1 minute)

Enter these settings:

| Field | Value |
|-------|-------|
| **Product Name** | `T1DCalculator` |
| **Team** | (Select your Apple Developer account, or leave as "None") |
| **Organization Identifier** | `studio.humaine` |
| **Bundle Identifier** | `studio.humaine.T1DCalculator` (auto-generated) |
| **Interface** | **SwiftUI** ← IMPORTANT! |
| **Language** | **Swift** |
| **Storage** | Swift Data (leave unchecked) |
| **Include Tests** | ✅ **CHECK THIS BOX** |

Click **Next**

### 3. Choose Save Location (30 seconds)

1. Navigate to: `/Users/chrismcconnell/GitHub/T1DCalculator`
2. **IMPORTANT:** When you see existing files warning:
   - Click **"Merge"** or **"Replace"** to combine with existing Swift files
   - Xcode will NOT delete your Swift files - it will integrate them
3. Click **Create**

### 4. Delete Xcode's Template Files (1 minute)

Xcode will create default files you don't need. Delete these:

1. In the Project Navigator (left sidebar), **right-click** and delete:
   - ❌ `ContentView.swift` (Xcode's template - you have a better one!)
   - ❌ `T1DCalculatorApp.swift` (Xcode's template - you have this!)
   
2. When prompted, choose **"Move to Trash"** (not just remove reference)

### 5. Add Your Swift Files (1 minute)

1. In Xcode, **right-click** on the `T1DCalculator` folder (blue icon)
2. Select **Add Files to "T1DCalculator"...**
3. **Select ALL these files** (hold ⌘ to multi-select):
   ```
   ✅ T1DCalculatorApp.swift
   ✅ ContentView.swift
   ✅ InsulinCalculator.swift
   ✅ CalculatorView.swift
   ✅ ResultsView.swift
   ✅ SourcesView.swift
   ```
4. **IMPORTANT:** Make sure these options are checked:
   - ✅ **"Copy items if needed"** (unchecked is fine - files are already in folder)
   - ✅ **"Create groups"** (selected)
   - ✅ **"Add to targets: T1DCalculator"** (checked)
5. Click **Add**

### 6. Add Test Files (30 seconds)

1. In Project Navigator, expand **T1DCalculatorTests** folder
2. Delete the default test file: `T1DCalculatorTests.swift` (Xcode's template)
3. **Right-click** on `T1DCalculatorTests` folder
4. Select **Add Files to "T1DCalculator"...**
5. Select both test files:
   ```
   ✅ T1DCalculatorTests.swift
   ✅ T1DCalculatorTests_Enhanced.swift
   ```
6. **IMPORTANT:** Make sure:
   - ✅ **"Add to targets: T1DCalculatorTests"** (checked)
7. Click **Add**

### 7. Build and Run! (30 seconds)

1. Select a simulator: Click the device selector (top-left) → Choose **iPhone 15 Pro**
2. Press **⌘R** or click the **Play** button
3. Wait for build... 🎉 **Your app should launch!**

---

## Verification Checklist

After following the steps, verify:

- [ ] App builds without errors (⌘B)
- [ ] App runs in simulator (⌘R)
- [ ] You see "T1D Insulin Calculator" title
- [ ] Calculator inputs are visible
- [ ] Tests run successfully (⌘U)
- [ ] 34 tests pass ✅

---

## Troubleshooting

### "No such module 'SwiftUI'"
- **Fix:** Make sure you selected **SwiftUI** (not UIKit) when creating project

### "Multiple '@main' entry points"
- **Fix:** You didn't delete Xcode's template `T1DCalculatorApp.swift` file
- Delete it and keep YOUR version

### "Cannot find 'InsulinCalculator' in scope"
- **Fix:** Files weren't added to the target
- Select the file → File Inspector (right sidebar) → Check **"T1DCalculator"** under Target Membership

### Build errors about missing types
- **Fix:** Make sure ALL 6 Swift files are added to the main target

---

## What Xcode Creates For You

When you create the project, Xcode generates:

```
T1DCalculator.xcodeproj/       ← The Xcode project file
T1DCalculator/                 ← Main app folder
    ├── Assets.xcassets/       ← App icon & images
    ├── Preview Content/       ← SwiftUI preview assets
    └── (Your Swift files)
T1DCalculatorTests/            ← Test folder
    └── (Your test files)
```

---

## Next Steps After Creation

Once the app runs successfully:

1. **Run Tests** → Press ⌘U (should see 34 tests pass)
2. **Test Calculator** → Enter values and verify calculation
3. **Add App Icon** → Drag icon into Assets.xcassets
4. **Review Code** → Make sure everything looks correct
5. **Follow QA Plan** → Open `QA_TESTING_PLAN.md`

---

## Alternative: Quick Command-Line Method

If you prefer automation, you can use this after creating the Xcode project:

```bash
cd /Users/chrismcconnell/GitHub/T1DCalculator

# Xcode project already created via GUI above
# Just verify everything built correctly
xcodebuild -scheme T1DCalculator -destination 'platform=iOS Simulator,name=iPhone 15 Pro' build
xcodebuild -scheme T1DCalculator -destination 'platform=iOS Simulator,name=iPhone 15 Pro' test
```

---

## Questions?

- Check: `TESTING_QUICKSTART.md` for testing info
- Check: `PROJECT_STATUS.md` for project overview
- Check: `README.md` for calculator documentation

---

**Ready?** Open Xcode and follow the steps above! 🚀

You'll have a working iOS app in 5 minutes.
