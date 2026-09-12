#!/bin/bash
# T1D Calculator setup check. Exits non-zero on any failure.
# Verifies the repo layout, the single .gitignore, and runs the
# calculation-engine XCTest suite via Swift Package Manager.
set -euo pipefail
cd "$(dirname "$0")"

fail() { echo "FAIL: $*" >&2; exit 1; }

for f in T1DCalculatorApp.swift ContentView.swift InsulinCalculator.swift \
         CalculatorView.swift ResultsView.swift SourcesView.swift \
         T1DCalculatorTests.swift T1DCalculatorTests_Enhanced.swift \
         Package.swift Info.plist; do
    [ -f "$f" ] || fail "missing $f"
done

stray=$(git ls-files | grep -E '^\.gitignore .+' || true)
[ -z "$stray" ] || fail "stray gitignore copy tracked: $stray"

command -v swift >/dev/null || fail "swift not found; install Xcode or Command Line Tools"

echo "Running engine tests..."
if swift test 2>/tmp/t1d-swift-test.log | grep -E 'Executed|error:'; then
    :
elif grep -q "unable to resolve module dependency: 'XCTest'" /tmp/t1d-swift-test.log \
     && [ -d /Applications/Xcode.app ]; then
    # Command Line Tools ship no XCTest. Borrow Xcode's without needing
    # xcode-select/xcodebuild (which require the Xcode license to be accepted).
    echo "XCTest missing from Command Line Tools; using Xcode.app frameworks."
    P=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer
    F=$P/Library/Frameworks; PF=$P/Library/PrivateFrameworks; L=$P/usr/lib
    swift build --build-tests -Xswiftc -F"$F" -Xswiftc -I"$L" -Xlinker -F"$F" -Xlinker -L"$L" \
        -Xlinker -rpath -Xlinker "$F" -Xlinker -rpath -Xlinker "$PF" -Xlinker -rpath -Xlinker "$L" \
        2>&1 | grep -E 'error:|Build complete' || fail "test build failed"
    bundle=$(find .build -name 'T1DCalculatorTests.xctest' -type d | head -1)
    [ -n "$bundle" ] || fail "test bundle not found under .build"
    DYLD_FRAMEWORK_PATH="$F:$PF" DYLD_LIBRARY_PATH="$L" \
        /Applications/Xcode.app/Contents/Developer/usr/bin/xctest "$bundle" >/tmp/t1d-xctest.log 2>&1 || true
    grep -E "error:|Executed [0-9]+ tests" /tmp/t1d-xctest.log | tail -6
    grep -qE "Test Suite 'All tests' passed" /tmp/t1d-xctest.log || fail "engine tests failed"
else
    cat /tmp/t1d-swift-test.log >&2
    fail "swift test failed"
fi

if [ -d T1DCalculator.xcodeproj ]; then
    echo "Xcode project present: run 'xcodebuild -scheme T1DCalculator -destination \"platform=iOS Simulator,name=iPhone 16\" test' for the app target."
else
    echo "No Xcode project yet: see README.md > Installation to create one for the app."
fi
echo "OK: setup check passed"
