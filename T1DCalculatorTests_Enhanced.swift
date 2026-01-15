import XCTest
@testable import T1DCalculator

/// Comprehensive test suite for T1D Insulin Calculator
/// Covers all calculation scenarios, edge cases, and unit conversions
class T1DCalculatorTestsEnhanced: XCTestCase {

    var calculator: InsulinCalculator!

    override func setUp() {
        super.setUp()
        calculator = InsulinCalculator()
    }

    override func tearDown() {
        calculator = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func testDefaultInitialization() {
        XCTAssertEqual(calculator.icr, 15.0, "Default ICR should be 1:15")
        XCTAssertEqual(calculator.isf, 50.0, "Default ISF should be 1:50")
        XCTAssertEqual(calculator.targetBG, 120.0, "Default target should be 120 mg/dL")
        XCTAssertEqual(calculator.units, .mgdl, "Default units should be mg/dL")
        XCTAssertEqual(calculator.insulinType, .humalog, "Default insulin should be Humalog")
    }

    // MARK: - Basic Calculation Tests

    func testBasicCarbDose() {
        // 60g carbs with ICR 1:15 should give 4.0 units
        calculator.currentBG = "120"  // At target, no correction
        calculator.carbs = "60"
        calculator.icr = 15.0
        calculator.targetBG = 120.0

        guard let result = calculator.calculationResult else {
            XCTFail("Calculation result should not be nil")
            return
        }

        XCTAssertEqual(result.carbUnits, 4.0, accuracy: 0.01, "60g ÷ 15 should equal 4.0 units")
        XCTAssertEqual(result.correctionUnits, 0.0, accuracy: 0.01, "No correction when at target")
        XCTAssertEqual(result.totalDose, 4.0, accuracy: 0.01, "Total should equal carb dose")
    }

    func testCorrectionDosePositive() {
        // BG 180, Target 120, ISF 1:50 should give 1.2 units correction
        calculator.currentBG = "180"
        calculator.carbs = "0"
        calculator.isf = 50.0
        calculator.targetBG = 120.0

        guard let result = calculator.calculationResult else {
            XCTFail("Calculation result should not be nil")
            return
        }

        XCTAssertEqual(result.bgDifference, 60.0, accuracy: 0.01, "180 - 120 = 60")
        XCTAssertEqual(result.correctionUnits, 1.2, accuracy: 0.01, "60 ÷ 50 = 1.2 units")
    }

    func testCorrectionDoseNegative() {
        // BG 90, Target 120, ISF 1:50 should give -0.6 units (below target)
        calculator.currentBG = "90"
        calculator.carbs = "0"
        calculator.isf = 50.0
        calculator.targetBG = 120.0

        guard let result = calculator.calculationResult else {
            XCTFail("Calculation result should not be nil")
            return
        }

        XCTAssertEqual(result.bgDifference, -30.0, accuracy: 0.01, "90 - 120 = -30")
        XCTAssertEqual(result.correctionUnits, -0.6, accuracy: 0.01, "-30 ÷ 50 = -0.6 units")
        XCTAssertLessThan(result.correctionUnits, 0, "Correction should be negative when below target")
    }

    func testTotalDoseCalculation() {
        // Combined carb and correction dose
        calculator.currentBG = "180"
        calculator.carbs = "60"
        calculator.icr = 15.0
        calculator.isf = 50.0
        calculator.targetBG = 120.0

        guard let result = calculator.calculationResult else {
            XCTFail("Calculation result should not be nil")
            return
        }

        XCTAssertEqual(result.correctionUnits, 1.2, accuracy: 0.01, "Correction: 60 ÷ 50 = 1.2")
        XCTAssertEqual(result.carbUnits, 4.0, accuracy: 0.01, "Carb dose: 60 ÷ 15 = 4.0")
        XCTAssertEqual(result.totalDose, 5.2, accuracy: 0.01, "Total: 1.2 + 4.0 = 5.2")
    }

    // MARK: - Hospital Rounding Tests

    func testRoundingDown() {
        // Decimal 0.1-0.3 should round down to whole unit
        calculator.currentBG = "180"
        calculator.carbs = "45"
        calculator.icr = 15.0
        calculator.isf = 50.0
        calculator.targetBG = 120.0

        // Total = 1.2 + 3.0 = 4.2, decimal 0.2 → round down to 4.0
        guard let result = calculator.calculationResult else {
            XCTFail("Calculation result should not be nil")
            return
        }

        XCTAssertEqual(result.totalDose, 4.2, accuracy: 0.01)
        XCTAssertEqual(result.roundedDose, 4.0, accuracy: 0.01, "4.2 should round down to 4.0")
    }

    func testRoundingToHalf() {
        // Decimal 0.4-0.6 should round to nearest half (0.5)
        calculator.currentBG = "195"
        calculator.carbs = "45"
        calculator.icr = 15.0
        calculator.isf = 50.0
        calculator.targetBG = 120.0

        // Total = 1.5 + 3.0 = 4.5, decimal 0.5 → stay at 4.5
        guard let result = calculator.calculationResult else {
            XCTFail("Calculation result should not be nil")
            return
        }

        XCTAssertEqual(result.totalDose, 4.5, accuracy: 0.01)
        XCTAssertEqual(result.roundedDose, 4.5, accuracy: 0.01, "4.5 should stay at 4.5")
    }

    func testRoundingUp() {
        // Decimal 0.7-0.9 should round up to next whole unit
        calculator.currentBG = "210"
        calculator.carbs = "45"
        calculator.icr = 15.0
        calculator.isf = 50.0
        calculator.targetBG = 120.0

        // Total = 1.8 + 3.0 = 4.8, decimal 0.8 → round up to 5.0
        guard let result = calculator.calculationResult else {
            XCTFail("Calculation result should not be nil")
            return
        }

        XCTAssertEqual(result.totalDose, 4.8, accuracy: 0.01)
        XCTAssertEqual(result.roundedDose, 5.0, accuracy: 0.01, "4.8 should round up to 5.0")
    }

    func testRoundingEdgeCases() {
        // Test specific decimal values
        let testCases: [(input: Double, expected: Double)] = [
            (2.1, 2.0),   // Round down
            (2.3, 2.0),   // Round down (boundary)
            (2.35, 2.5),  // Round to half
            (2.4, 2.5),   // Round to half
            (2.5, 2.5),   // Stay at half
            (2.6, 2.5),   // Round to half
            (2.64, 2.5),  // Round to half
            (2.7, 3.0),   // Round up (boundary)
            (2.8, 3.0),   // Round up
            (2.9, 3.0),   // Round up
        ]

        for (input, expected) in testCases {
            let result = roundDoseHospitalProtocol(input)
            XCTAssertEqual(result, expected, accuracy: 0.01, "\(input) should round to \(expected)")
        }
    }

    // Helper function matching the app's rounding logic
    private func roundDoseHospitalProtocol(_ dose: Double) -> Double {
        let decimal = dose - floor(dose)

        if decimal >= 0 && decimal <= 0.3 {
            return floor(dose)
        } else if decimal > 0.3 && decimal < 0.7 {
            return floor(dose) + 0.5
        } else {
            return ceil(dose)
        }
    }

    // MARK: - Unit Conversion Tests

    func testMgdlToMmolConversion() {
        XCTAssertEqual(calculator.mgdlToMmol(180), 10.0, accuracy: 0.1, "180 mg/dL = 10.0 mmol/L")
        XCTAssertEqual(calculator.mgdlToMmol(90), 5.0, accuracy: 0.1, "90 mg/dL = 5.0 mmol/L")
        XCTAssertEqual(calculator.mgdlToMmol(120), 6.67, accuracy: 0.1, "120 mg/dL ≈ 6.67 mmol/L")
    }

    func testMmolToMgdlConversion() {
        XCTAssertEqual(calculator.mmolToMgdl(10.0), 180, accuracy: 0.1, "10.0 mmol/L = 180 mg/dL")
        XCTAssertEqual(calculator.mmolToMgdl(5.0), 90, accuracy: 0.1, "5.0 mmol/L = 90 mg/dL")
        XCTAssertEqual(calculator.mmolToMgdl(6.67), 120, accuracy: 1.0, "6.67 mmol/L ≈ 120 mg/dL")
    }

    func testISFConversionOnUnitToggle() {
        calculator.isf = 50.0
        calculator.units = .mgdl

        // Toggle to mmol/L
        calculator.toggleUnits()

        XCTAssertEqual(calculator.units, .mmol, "Units should be mmol/L")
        XCTAssertEqual(calculator.isf, 2.78, accuracy: 0.1, "ISF 50 mg/dL ≈ 2.78 mmol/L")

        // Toggle back to mg/dL
        calculator.toggleUnits()

        XCTAssertEqual(calculator.units, .mgdl, "Units should be mg/dL")
        XCTAssertEqual(calculator.isf, 50.0, accuracy: 1.0, "ISF should convert back to 50 mg/dL")
    }

    func testTargetBGConversionOnUnitToggle() {
        calculator.targetBG = 120.0
        calculator.units = .mgdl

        calculator.toggleUnits()

        XCTAssertEqual(calculator.targetBG, 6.67, accuracy: 0.1, "Target 120 mg/dL ≈ 6.67 mmol/L")
    }

    func testCurrentBGConversionOnUnitToggle() {
        calculator.currentBG = "180"
        calculator.units = .mgdl

        calculator.toggleUnits()

        XCTAssertEqual(calculator.currentBG, "10.0", "Current BG 180 mg/dL = 10.0 mmol/L")
    }

    // MARK: - Input Validation Tests

    func testBGValidationMgdl() {
        calculator.units = .mgdl

        // Valid range: 20-600 mg/dL
        XCTAssertTrue(calculator.isValidBG("20"), "20 mg/dL should be valid (minimum)")
        XCTAssertTrue(calculator.isValidBG("120"), "120 mg/dL should be valid")
        XCTAssertTrue(calculator.isValidBG("600"), "600 mg/dL should be valid (maximum)")

        XCTAssertFalse(calculator.isValidBG("10"), "10 mg/dL should be invalid (too low)")
        XCTAssertFalse(calculator.isValidBG("650"), "650 mg/dL should be invalid (too high)")
        XCTAssertFalse(calculator.isValidBG("abc"), "Non-numeric should be invalid")
    }

    func testBGValidationMmol() {
        calculator.units = .mmol

        // Valid range: 1.1-33.3 mmol/L
        XCTAssertTrue(calculator.isValidBG("1.1"), "1.1 mmol/L should be valid (minimum)")
        XCTAssertTrue(calculator.isValidBG("6.7"), "6.7 mmol/L should be valid")
        XCTAssertTrue(calculator.isValidBG("33.3"), "33.3 mmol/L should be valid (maximum)")

        XCTAssertFalse(calculator.isValidBG("0.5"), "0.5 mmol/L should be invalid (too low)")
        XCTAssertFalse(calculator.isValidBG("40.0"), "40.0 mmol/L should be invalid (too high)")
    }

    func testCarbsValidation() {
        // Valid range: 0-200g
        XCTAssertTrue(calculator.isValidCarbs("0"), "0g should be valid")
        XCTAssertTrue(calculator.isValidCarbs("45"), "45g should be valid")
        XCTAssertTrue(calculator.isValidCarbs("200"), "200g should be valid (maximum)")

        XCTAssertFalse(calculator.isValidCarbs("-5"), "Negative carbs should be invalid")
        XCTAssertFalse(calculator.isValidCarbs("250"), "250g should be invalid (too high)")
        XCTAssertFalse(calculator.isValidCarbs("abc"), "Non-numeric should be invalid")
    }

    func testEmptyInputHandling() {
        calculator.currentBG = ""
        calculator.carbs = "45"

        XCTAssertFalse(calculator.hasValidInputs, "Empty BG should make inputs invalid")
        XCTAssertNil(calculator.calculationResult, "No calculation with empty BG")

        calculator.currentBG = "120"
        calculator.carbs = ""

        XCTAssertFalse(calculator.hasValidInputs, "Empty carbs should make inputs invalid")
        XCTAssertNil(calculator.calculationResult, "No calculation with empty carbs")
    }

    // MARK: - Edge Case Tests

    func testZeroCarbs() {
        // Correction only, no carb dose
        calculator.currentBG = "180"
        calculator.carbs = "0"
        calculator.isf = 50.0
        calculator.targetBG = 120.0

        guard let result = calculator.calculationResult else {
            XCTFail("Calculation result should not be nil")
            return
        }

        XCTAssertEqual(result.carbUnits, 0.0, accuracy: 0.01, "No carb dose with 0g carbs")
        XCTAssertEqual(result.correctionUnits, 1.2, accuracy: 0.01, "Should still have correction")
        XCTAssertEqual(result.totalDose, 1.2, accuracy: 0.01, "Total equals correction only")
    }

    func testPerfectBG() {
        // BG equals target, carb dose only
        calculator.currentBG = "120"
        calculator.carbs = "45"
        calculator.icr = 15.0
        calculator.targetBG = 120.0

        guard let result = calculator.calculationResult else {
            XCTFail("Calculation result should not be nil")
            return
        }

        XCTAssertEqual(result.bgDifference, 0.0, accuracy: 0.01, "No BG difference at target")
        XCTAssertEqual(result.correctionUnits, 0.0, accuracy: 0.01, "No correction at target")
        XCTAssertEqual(result.carbUnits, 3.0, accuracy: 0.01, "Carb dose: 45 ÷ 15 = 3.0")
        XCTAssertEqual(result.totalDose, 3.0, accuracy: 0.01, "Total equals carb dose only")
    }

    func testVeryHighBG() {
        calculator.currentBG = "400"
        calculator.carbs = "0"
        calculator.isf = 50.0
        calculator.targetBG = 120.0

        guard let result = calculator.calculationResult else {
            XCTFail("Calculation result should not be nil")
            return
        }

        XCTAssertEqual(result.bgDifference, 280.0, accuracy: 0.01, "400 - 120 = 280")
        XCTAssertEqual(result.correctionUnits, 5.6, accuracy: 0.01, "280 ÷ 50 = 5.6 units")
    }

    func testVeryLowBG() {
        calculator.currentBG = "50"
        calculator.carbs = "30"
        calculator.icr = 15.0
        calculator.isf = 50.0
        calculator.targetBG = 120.0

        guard let result = calculator.calculationResult else {
            XCTFail("Calculation result should not be nil")
            return
        }

        XCTAssertEqual(result.bgDifference, -70.0, accuracy: 0.01, "50 - 120 = -70")
        XCTAssertEqual(result.correctionUnits, -1.4, accuracy: 0.01, "-70 ÷ 50 = -1.4 units")
        XCTAssertEqual(result.carbUnits, 2.0, accuracy: 0.01, "30 ÷ 15 = 2.0 units")
        XCTAssertEqual(result.totalDose, 0.6, accuracy: 0.01, "-1.4 + 2.0 = 0.6 units")
        XCTAssertLessThan(result.correctionUnits, 0, "Should have negative correction")
    }

    // MARK: - Real-World Scenario Tests

    func testStandardMealScenario() {
        // Scenario: Moderate BG, typical meal
        calculator.currentBG = "150"
        calculator.carbs = "45"
        calculator.icr = 15.0
        calculator.isf = 50.0
        calculator.targetBG = 120.0
        calculator.insulinType = .humalog

        guard let result = calculator.calculationResult else {
            XCTFail("Calculation result should not be nil")
            return
        }

        XCTAssertEqual(result.bgDifference, 30.0, accuracy: 0.01)
        XCTAssertEqual(result.correctionUnits, 0.6, accuracy: 0.01)
        XCTAssertEqual(result.carbUnits, 3.0, accuracy: 0.01)
        XCTAssertEqual(result.totalDose, 3.6, accuracy: 0.01)
        XCTAssertEqual(result.roundedDose, 3.5, accuracy: 0.01, "3.6 rounds to 3.5")
    }

    func testHighBGScenario() {
        // Scenario: High BG before meal
        calculator.currentBG = "280"
        calculator.carbs = "60"
        calculator.icr = 12.0
        calculator.isf = 40.0
        calculator.targetBG = 120.0

        guard let result = calculator.calculationResult else {
            XCTFail("Calculation result should not be nil")
            return
        }

        XCTAssertEqual(result.bgDifference, 160.0, accuracy: 0.01)
        XCTAssertEqual(result.correctionUnits, 4.0, accuracy: 0.01, "160 ÷ 40 = 4.0")
        XCTAssertEqual(result.carbUnits, 5.0, accuracy: 0.01, "60 ÷ 12 = 5.0")
        XCTAssertEqual(result.totalDose, 9.0, accuracy: 0.01, "4.0 + 5.0 = 9.0")
        XCTAssertEqual(result.roundedDose, 9.0, accuracy: 0.01)
    }

    func testLowBGScenario() {
        // Scenario: Below target before meal
        calculator.currentBG = "85"
        calculator.carbs = "30"
        calculator.icr = 15.0
        calculator.isf = 50.0
        calculator.targetBG = 120.0

        guard let result = calculator.calculationResult else {
            XCTFail("Calculation result should not be nil")
            return
        }

        XCTAssertEqual(result.bgDifference, -35.0, accuracy: 0.01)
        XCTAssertEqual(result.correctionUnits, -0.7, accuracy: 0.01, "-35 ÷ 50 = -0.7")
        XCTAssertEqual(result.carbUnits, 2.0, accuracy: 0.01, "30 ÷ 15 = 2.0")
        XCTAssertEqual(result.totalDose, 1.3, accuracy: 0.01, "-0.7 + 2.0 = 1.3")
        XCTAssertEqual(result.roundedDose, 1.5, accuracy: 0.01, "1.3 rounds to 1.5")
    }

    func testMmolScenario() {
        // Scenario: Using mmol/L units
        calculator.units = .mmol
        calculator.currentBG = "10.0"  // 180 mg/dL
        calculator.carbs = "45"
        calculator.icr = 15.0
        calculator.isf = 2.8  // ~50 mg/dL
        calculator.targetBG = 6.7  // ~120 mg/dL

        guard let result = calculator.calculationResult else {
            XCTFail("Calculation result should not be nil")
            return
        }

        // Calculations happen in mg/dL internally
        XCTAssertEqual(result.bgInMgdl, 180.0, accuracy: 1.0)
        XCTAssertEqual(result.targetInMgdl, 120.6, accuracy: 1.0)
        XCTAssertEqual(result.correctionUnits, 1.2, accuracy: 0.2)
        XCTAssertEqual(result.carbUnits, 3.0, accuracy: 0.01)
    }

    // MARK: - Insulin Type Tests

    func testInsulinTypeSelection() {
        let types: [InsulinType] = [
            .humalog, .humalogJunior, .novolog, .apidra,
            .fiasp, .lyumjev, .admelog, .other
        ]

        for type in types {
            calculator.insulinType = type
            XCTAssertEqual(calculator.insulinType, type, "\(type.rawValue) should be selectable")
        }
    }
}
