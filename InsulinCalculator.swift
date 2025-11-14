import Foundation
import SwiftUI

// MARK: - Error Types
enum CalculationError: LocalizedError {
    case invalidBloodGlucose
    case invalidCarbs
    case criticallyLowBG
    case divisionByZero
    case invalidCalculation

    var errorDescription: String? {
        switch self {
        case .invalidBloodGlucose:
            return "Invalid blood glucose value"
        case .invalidCarbs:
            return "Invalid carbohydrate value"
        case .criticallyLowBG:
            return "Blood glucose critically low. Treat immediately and seek medical attention."
        case .divisionByZero:
            return "Invalid calculation: Division by zero"
        case .invalidCalculation:
            return "Unable to calculate dose. Please check your inputs."
        }
    }
}

// MARK: - Data Models
struct CalculationResult {
    let bgDifference: Double
    let correctionUnits: Double
    let carbUnits: Double
    let totalDose: Double
    let roundedDose: Double
    let bgInMgdl: Double
    let targetInMgdl: Double
    let isfInMgdl: Double
    let isCriticallyLow: Bool
    let isLowBG: Bool
    let isLargeDose: Bool

    var needsWarning: Bool {
        return isCriticallyLow || isLowBG || isLargeDose
    }
}

enum BloodGlucoseUnit: String, CaseIterable {
    case mgdl = "mg/dL"
    case mmol = "mmol/L"

    var displayName: String {
        return rawValue
    }
}

enum InsulinType: String, CaseIterable {
    case humalog = "Humalog (Lispro)"
    case humalogJunior = "Humalog Junior"
    case novolog = "NovoLog (Aspart)"
    case apidra = "Apidra (Glulisine)"
    case fiasp = "Fiasp (Faster Aspart)"
    case lyumjev = "Lyumjev (Ultra-rapid Lispro)"
    case admelog = "Admelog (Lispro)"
    case other = "Other rapid-acting"
}

// MARK: - Constants
private enum ValidationConstants {
    // BG limits (mg/dL)
    static let minBGMgdl: Double = 40.0  // Below this is critically low
    static let maxBGMgdl: Double = 600.0
    static let lowBGThresholdMgdl: Double = 70.0  // Show warning below this

    // BG limits (mmol/L)
    static let minBGMmol: Double = 2.2  // 40 mg/dL
    static let maxBGMmol: Double = 33.3  // 600 mg/dL
    static let lowBGThresholdMmol: Double = 3.9  // 70 mg/dL

    // Carb limits (grams)
    static let minCarbs: Double = 0.0
    static let maxCarbs: Double = 300.0  // Increased per review
    static let largeCarbs: Double = 150.0  // Warning threshold

    // ICR limits (Dr. Tintani feedback)
    static let minICR: Double = 2.0  // 1:2
    static let maxICR: Double = 80.0

    // ISF limits (mg/dL) - Dr. Tintani feedback
    static let minISFMgdl: Double = 5.0  // 1:5
    static let maxISFMgdl: Double = 150.0

    // ISF limits (mmol/L)
    static let minISFMmol: Double = 0.3  // ~5 mg/dL
    static let maxISFMmol: Double = 8.3  // ~150 mg/dL

    // Target BG limits (Dr. Tintani feedback)
    static let minTargetMgdl: Double = 100.0  // Must be 100 or higher
    static let maxTargetMgdl: Double = 180.0
    static let minTargetMmol: Double = 5.6  // ~100 mg/dL
    static let maxTargetMmol: Double = 10.0  // ~180 mg/dL

    // Dose safety limits
    static let largeDoseThreshold: Double = 15.0  // Require confirmation above this
    static let maxDoseCeiling: Double = 25.0  // Hard limit

    // Unit conversion
    static let mgdlToMmolFactor: Double = 18.0
}

// MARK: - Main Calculator Class
class InsulinCalculator: ObservableObject {
    // MARK: - Published Properties
    @Published var currentBG: String = ""
    @Published var carbs: String = ""
    @Published var icr: Double = 15.0
    @Published var isf: Double = 50.0
    @Published var targetBG: Double = 120.0
    @Published var insulinType: InsulinType = .humalog
    @Published var units: BloodGlucoseUnit = .mgdl

    // MARK: - Validation ranges (computed based on units)
    var icrRange: ClosedRange<Double> {
        return ValidationConstants.minICR...ValidationConstants.maxICR
    }

    var isfRange: ClosedRange<Double> {
        if units == .mgdl {
            return ValidationConstants.minISFMgdl...ValidationConstants.maxISFMgdl
        } else {
            return ValidationConstants.minISFMmol...ValidationConstants.maxISFMmol
        }
    }

    var targetBGRange: ClosedRange<Double> {
        if units == .mgdl {
            return ValidationConstants.minTargetMgdl...ValidationConstants.maxTargetMgdl
        } else {
            return ValidationConstants.minTargetMmol...ValidationConstants.maxTargetMmol
        }
    }

    // MARK: - Computed Properties with CRITICAL FIX: Range validation
    var hasValidInputs: Bool {
        guard !currentBG.isEmpty && !carbs.isEmpty,
              let bg = Double(currentBG),
              let carbCount = Double(carbs) else {
            return false
        }

        // CRITICAL FIX: Enforce range validation before calculation
        return isValidBG(String(bg)) && isValidCarbs(String(carbCount))
    }

    var calculationResult: CalculationResult? {
        guard hasValidInputs,
              let bg = Double(currentBG),
              let carbCount = Double(carbs) else {
            return nil
        }

        // CRITICAL FIX: Return nil instead of calculating with invalid values
        do {
            return try calculateDose(currentBG: bg, carbs: carbCount)
        } catch {
            // Log error in production (for now, silent fail is acceptable since we show nil)
            print("Calculation error: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Conversion Methods
    func mgdlToMmol(_ mgdl: Double) -> Double {
        return mgdl / ValidationConstants.mgdlToMmolFactor
    }

    func mmolToMgdl(_ mmol: Double) -> Double {
        return mmol * ValidationConstants.mgdlToMmolFactor
    }

    func convertBG(_ value: Double, fromUnit: BloodGlucoseUnit) -> Double {
        if fromUnit == .mgdl {
            return mgdlToMmol(value)
        } else {
            return mmolToMgdl(value)
        }
    }

    func displayValue(_ value: Double) -> String {
        if units == .mmol {
            return String(format: "%.1f", value)
        } else {
            return String(format: "%.0f", value)
        }
    }

    // MARK: - Unit Toggle
    func toggleUnits() {
        let newUnits: BloodGlucoseUnit = units == .mgdl ? .mmol : .mgdl

        // Convert current values
        if let bg = Double(currentBG) {
            let convertedBG = convertBG(bg, fromUnit: units)
            currentBG = String(format: "%.1f", convertedBG)
        }

        targetBG = convertBG(targetBG, fromUnit: units)
        isf = convertBG(isf, fromUnit: units)

        units = newUnits
    }

    // MARK: - Calculation Logic with ERROR HANDLING
    func calculateDose(currentBG: Double, carbs: Double) throws -> CalculationResult {
        // CRITICAL FIX: Validate inputs before calculation
        guard isValidBGValue(currentBG) else {
            throw CalculationError.invalidBloodGlucose
        }

        guard isValidCarbsValue(carbs) else {
            throw CalculationError.invalidCarbs
        }

        // Check for critically low BG
        let bgInMgdl = units == .mmol ? currentBG * ValidationConstants.mgdlToMmolFactor : currentBG
        if bgInMgdl < ValidationConstants.minBGMgdl {
            throw CalculationError.criticallyLowBG
        }

        // CRITICAL FIX: Check for division by zero
        guard icr > 0 && isf > 0 else {
            throw CalculationError.divisionByZero
        }

        // Convert to mg/dL for calculation if in mmol/L
        let targetInMgdl = units == .mmol ? targetBG * ValidationConstants.mgdlToMmolFactor : targetBG
        let isfInMgdl = units == .mmol ? isf * ValidationConstants.mgdlToMmolFactor : isf

        let bgDifference = bgInMgdl - targetInMgdl
        let correctionUnits = bgDifference / isfInMgdl
        let carbUnits = carbs / icr
        let totalDose = correctionUnits + carbUnits

        // CRITICAL FIX: Check for NaN or Infinity
        guard totalDose.isFinite else {
            throw CalculationError.invalidCalculation
        }

        // Hospital rounding logic for half-unit dosing
        let decimal = totalDose - floor(totalDose)
        let roundedDose: Double

        if decimal >= 0 && decimal <= 0.3 {
            roundedDose = floor(totalDose)
        } else if decimal > 0.3 && decimal < 0.7 {
            roundedDose = floor(totalDose) + 0.5
        } else {
            roundedDose = ceil(totalDose)
        }

        // Safety checks
        let isCriticallyLow = bgInMgdl < ValidationConstants.minBGMgdl
        let isLowBG = bgInMgdl < ValidationConstants.lowBGThresholdMgdl
        let isLargeDose = roundedDose > ValidationConstants.largeDoseThreshold

        return CalculationResult(
            bgDifference: units == .mmol ? bgDifference / ValidationConstants.mgdlToMmolFactor : bgDifference,
            correctionUnits: correctionUnits,
            carbUnits: carbUnits,
            totalDose: totalDose,
            roundedDose: max(0, roundedDose),  // Never return negative dose
            bgInMgdl: bgInMgdl,
            targetInMgdl: targetInMgdl,
            isfInMgdl: isfInMgdl,
            isCriticallyLow: isCriticallyLow,
            isLowBG: isLowBG,
            isLargeDose: isLargeDose
        )
    }

    // MARK: - Validation
    func isValidBG(_ value: String) -> Bool {
        guard let bg = Double(value) else { return false }
        return isValidBGValue(bg)
    }

    private func isValidBGValue(_ bg: Double) -> Bool {
        if units == .mgdl {
            return bg >= ValidationConstants.minBGMgdl && bg <= ValidationConstants.maxBGMgdl
        } else {
            return bg >= ValidationConstants.minBGMmol && bg <= ValidationConstants.maxBGMmol
        }
    }

    func isValidCarbs(_ value: String) -> Bool {
        guard let carbs = Double(value) else { return false }
        return isValidCarbsValue(carbs)
    }

    private func isValidCarbsValue(_ carbs: Double) -> Bool {
        return carbs >= ValidationConstants.minCarbs && carbs <= ValidationConstants.maxCarbs
    }

    func isCriticallyLowBG(_ value: String) -> Bool {
        guard let bg = Double(value) else { return false }
        let bgInMgdl = units == .mmol ? bg * ValidationConstants.mgdlToMmolFactor : bg
        return bgInMgdl < ValidationConstants.minBGMgdl
    }

    func isLargeCarbs(_ value: String) -> Bool {
        guard let carbs = Double(value) else { return false }
        return carbs > ValidationConstants.largeCarbs
    }
}
