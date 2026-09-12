import XCTest
@testable import T1DCalculator

class T1DCalculatorTests: XCTestCase {
    
    func testInsulinCalculatorInitialization() {
        let calculator = InsulinCalculator()
        
        XCTAssertEqual(calculator.icr, 15.0)
        XCTAssertEqual(calculator.isf, 50.0)
        XCTAssertEqual(calculator.targetBG, 120.0)
        XCTAssertEqual(calculator.units, .mgdl)
        XCTAssertEqual(calculator.insulinType, .humalog)
    }
    
    func testUnitConversion() {
        let calculator = InsulinCalculator()
        
        // Test mg/dL to mmol/L conversion
        let mgdlValue = 180.0
        let mmolValue = calculator.mgdlToMmol(mgdlValue)
        XCTAssertEqual(mmolValue, 10.0, accuracy: 0.1)
        
        // Test mmol/L to mg/dL conversion
        let mmolValue2 = 8.0
        let mgdlValue2 = calculator.mmolToMgdl(mmolValue2)
        XCTAssertEqual(mgdlValue2, 144.0, accuracy: 0.1)
    }
    
    func testDoseCalculation() {
        let calculator = InsulinCalculator()
        calculator.currentBG = "180"
        calculator.carbs = "45"
        calculator.icr = 15.0
        calculator.isf = 50.0
        calculator.targetBG = 120.0
        
        guard let result = calculator.calculationResult else {
            XCTFail("Calculation result should not be nil")
            return
        }
        
        // Expected calculations:
        // BG difference: 180 - 120 = 60 mg/dL
        // Correction: 60 ÷ 50 = 1.2 units
        // Carbs: 45 ÷ 15 = 3.0 units
        // Total: 1.2 + 3.0 = 4.2 units
        // Rounded: 4.2 → 4.0 units (decimal 0.2 ≤ 0.3, round down)
        
        XCTAssertEqual(result.bgDifference, 60.0, accuracy: 0.1)
        XCTAssertEqual(result.correctionUnits, 1.2, accuracy: 0.1)
        XCTAssertEqual(result.carbUnits, 3.0, accuracy: 0.1)
        XCTAssertEqual(result.totalDose, 4.2, accuracy: 0.1)
        XCTAssertEqual(result.roundedDose, 4.0, accuracy: 0.1)
    }
    
    func testRoundingLogic() {
        let calculator = InsulinCalculator()
        
        // Test case 1: 4.2 → 4.0 (decimal 0.2 ≤ 0.3, round down)
        calculator.currentBG = "180"
        calculator.carbs = "45"
        if let result1 = calculator.calculationResult {
            XCTAssertEqual(result1.roundedDose, 4.0, accuracy: 0.1)
        }
        
        // Test case 2: 4.5 → 4.5 (decimal 0.5, round to half)
        calculator.currentBG = "195"
        calculator.carbs = "45"
        if let result2 = calculator.calculationResult {
            XCTAssertEqual(result2.roundedDose, 4.5, accuracy: 0.1)
        }
        
        // Test case 3: 4.8 → 5.0 (decimal 0.8 ≥ 0.7, round up)
        calculator.currentBG = "210"
        calculator.carbs = "45"
        if let result3 = calculator.calculationResult {
            XCTAssertEqual(result3.roundedDose, 5.0, accuracy: 0.1)
        }
    }
    
    func testUnitToggle() {
        let calculator = InsulinCalculator()
        calculator.currentBG = "180"
        calculator.targetBG = 120.0
        calculator.isf = 50.0
        
        // Toggle to mmol/L
        calculator.toggleUnits()
        
        XCTAssertEqual(calculator.units, .mmol)
        XCTAssertEqual(calculator.currentBG, "10.0") // 180 ÷ 18 = 10.0
        XCTAssertEqual(calculator.targetBG, 6.7, accuracy: 0.1) // 120 ÷ 18 = 6.7
        XCTAssertEqual(calculator.isf, 2.8, accuracy: 0.1) // 50 ÷ 18 = 2.8
    }
    
    func testValidation() {
        let calculator = InsulinCalculator()
        
        // Test valid BG values
        XCTAssertTrue(calculator.isValidBG("120"))
        XCTAssertTrue(calculator.isValidBG("180"))
        XCTAssertFalse(calculator.isValidBG("10")) // Too low
        XCTAssertFalse(calculator.isValidBG("700")) // Too high
        
        // Test valid carb values
        XCTAssertTrue(calculator.isValidCarbs("45"))
        XCTAssertTrue(calculator.isValidCarbs("0"))
        XCTAssertTrue(calculator.isValidCarbs("250")) // Within 300g maximum
        XCTAssertFalse(calculator.isValidCarbs("-10")) // Negative
    }
    
    func testLowBGWarning() {
        let calculator = InsulinCalculator()
        calculator.currentBG = "80"  // Below target
        calculator.carbs = "30"
        calculator.targetBG = 120.0
        
        guard let result = calculator.calculationResult else {
            XCTFail("Calculation result should not be nil")
            return
        }
        
        // Should have negative correction (reducing dose)
        XCTAssertLessThan(result.correctionUnits, 0)
    }
}
