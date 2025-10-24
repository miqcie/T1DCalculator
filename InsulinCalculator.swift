import Foundation
import SwiftUI

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
    
    // MARK: - Computed Properties
    var hasValidInputs: Bool {
        return !currentBG.isEmpty && !carbs.isEmpty && 
               Double(currentBG) != nil && Double(carbs) != nil
    }
    
    var calculationResult: CalculationResult? {
        guard hasValidInputs,
              let bg = Double(currentBG),
              let carbCount = Double(carbs) else {
            return nil
        }
        
        return calculateDose(currentBG: bg, carbs: carbCount)
    }
    
    // MARK: - Conversion Methods
    func mgdlToMmol(_ mgdl: Double) -> Double {
        return mgdl / 18.0
    }
    
    func mmolToMgdl(_ mmol: Double) -> Double {
        return mmol * 18.0
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
    
    // MARK: - Calculation Logic
    func calculateDose(currentBG: Double, carbs: Double) -> CalculationResult {
        // Convert to mg/dL for calculation if in mmol/L
        let bgInMgdl = units == .mmol ? currentBG * 18 : currentBG
        let targetInMgdl = units == .mmol ? targetBG * 18 : targetBG
        let isfInMgdl = units == .mmol ? isf * 18 : isf
        
        let bgDifference = bgInMgdl - targetInMgdl
        let correctionUnits = bgDifference / isfInMgdl
        let carbUnits = carbs / icr
        let totalDose = correctionUnits + carbUnits
        
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
        
        return CalculationResult(
            bgDifference: units == .mmol ? bgDifference / 18 : bgDifference,
            correctionUnits: correctionUnits,
            carbUnits: carbUnits,
            totalDose: totalDose,
            roundedDose: roundedDose,
            bgInMgdl: bgInMgdl,
            targetInMgdl: targetInMgdl,
            isfInMgdl: isfInMgdl
        )
    }
    
    // MARK: - Validation
    func isValidBG(_ value: String) -> Bool {
        guard let bg = Double(value) else { return false }
        
        if units == .mgdl {
            return bg >= 20 && bg <= 600
        } else {
            return bg >= 1.1 && bg <= 33.3
        }
    }
    
    func isValidCarbs(_ value: String) -> Bool {
        guard let carbs = Double(value) else { return false }
        return carbs >= 0 && carbs <= 200
    }
}
