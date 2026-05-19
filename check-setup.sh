#!/bin/bash

# T1D Calculator - Xcode Project Setup Script
# This script helps verify your environment is ready

echo "🏥 T1D Calculator - Xcode Project Setup"
echo "========================================"
echo ""

# Check if Xcode is installed
if command -v xcodebuild &> /dev/null; then
    echo "✅ Xcode is installed"
    xcodebuild -version
else
    echo "❌ Xcode is NOT installed"
    echo "   Please install Xcode from the App Store"
    exit 1
fi

echo ""
echo "📁 Current Directory: $(pwd)"
echo ""

# Check for required Swift files
echo "🔍 Checking for required Swift files..."
required_files=(
    "T1DCalculatorApp.swift"
    "ContentView.swift"
    "InsulinCalculator.swift"
    "CalculatorView.swift"
    "ResultsView.swift"
    "SourcesView.swift"
)

all_files_present=true
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✅ $file"
    else
        echo "   ❌ $file (MISSING)"
        all_files_present=false
    fi
done

echo ""

# Check for test files
echo "🧪 Checking for test files..."
test_files=(
    "T1DCalculatorTests.swift"
    "T1DCalculatorTests_Enhanced.swift"
)

for file in "${test_files[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✅ $file"
    else
        echo "   ❌ $file (MISSING)"
    fi
done

echo ""

# Check if Xcode project exists
if [ -d "T1DCalculator.xcodeproj" ]; then
    echo "📦 Xcode project: ✅ EXISTS"
    echo ""
    echo "🚀 You can now:"
    echo "   1. Open the project: open T1DCalculator.xcodeproj"
    echo "   2. Build: xcodebuild -scheme T1DCalculator build"
    echo "   3. Run tests: xcodebuild -scheme T1DCalculator test"
else
    echo "📦 Xcode project: ❌ NOT YET CREATED"
    echo ""
    if [ "$all_files_present" = true ]; then
        echo "✨ Ready to create Xcode project!"
        echo ""
        echo "📖 Next steps:"
        echo "   1. Read: CREATE_XCODE_PROJECT.md"
        echo "   2. Open Xcode: open -a Xcode"
        echo "   3. File → New → Project → iOS App"
        echo "   4. Follow the guide in CREATE_XCODE_PROJECT.md"
    else
        echo "⚠️  Some Swift files are missing. Please check your repository."
    fi
fi

echo ""
echo "📚 Documentation available:"
[ -f "CREATE_XCODE_PROJECT.md" ] && echo "   ✅ CREATE_XCODE_PROJECT.md - How to create the Xcode project"
[ -f "README.md" ] && echo "   ✅ README.md - Project overview"
[ -f "TESTING_QUICKSTART.md" ] && echo "   ✅ TESTING_QUICKSTART.md - Testing guide"
[ -f "QA_TESTING_PLAN.md" ] && echo "   ✅ QA_TESTING_PLAN.md - Full QA strategy"

echo ""
echo "✅ Setup check complete!"
