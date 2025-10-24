import SwiftUI

struct ResultsView: View {
    @ObservedObject var calculator: InsulinCalculator
    
    var body: some View {
        VStack(spacing: 24) {
            if let result = calculator.calculationResult {
                // Step-by-Step Calculation
                VStack(alignment: .leading, spacing: 16) {
                    Text("Step-by-Step Calculation")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 12) {
                        CalculationStepView(
                            step: "Step 1:",
                            description: "Current BG - Target BG",
                            value: "\(calculator.displayValue(Double(calculator.currentBG) ?? 0)) - \(calculator.displayValue(calculator.targetBG)) = \(calculator.displayValue(abs(result.bgDifference)))"
                        )
                        
                        CalculationStepView(
                            step: "Step 2:",
                            description: "Correction dose",
                            value: "\(calculator.displayValue(abs(result.bgDifference))) ÷ \(calculator.displayValue(calculator.isf)) = \(String(format: "%.2f", result.correctionUnits)) units"
                        )
                        
                        CalculationStepView(
                            step: "Step 3:",
                            description: "Carb coverage",
                            value: "\(calculator.carbs) ÷ \(Int(calculator.icr)) = \(String(format: "%.2f", result.carbUnits)) units"
                        )
                        
                        CalculationStepView(
                            step: "Step 4:",
                            description: "Total dose",
                            value: "\(String(format: "%.2f", result.correctionUnits)) + \(String(format: "%.2f", result.carbUnits)) = \(String(format: "%.2f", result.totalDose)) units"
                        )
                        
                        CalculationStepView(
                            step: "Step 5:",
                            description: "Round per hospital protocol",
                            value: "\(String(format: "%.2f", result.totalDose)) → \(String(format: "%.1f", result.roundedDose)) units"
                        )
                    }
                    
                    // Rounding Rules
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rounding rules for half-unit dosing:")
                            .font(.caption)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("• 0.1-0.3 → Round down to whole unit")
                            Text("• 0.4-0.6 → Round to nearest half unit (0.5)")
                            Text("• 0.7-0.9 → Round up to whole unit")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .padding(.top, 8)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Recommended Dose
                VStack(spacing: 16) {
                    Text("Recommended Dose")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("\(String(format: "%.1f", result.roundedDose)) units")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text(calculator.insulinType.rawValue)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    // Low BG Warning
                    if result.correctionUnits < 0 {
                        LowBGWarningView(
                            currentBG: calculator.displayValue(Double(calculator.currentBG) ?? 0),
                            targetBG: calculator.displayValue(calculator.targetBG),
                            units: calculator.units.displayName
                        )
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Reminder
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                    Text("Reminder: Check glucose monitor in 2 hours post-meal")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
}

struct CalculationStepView: View {
    let step: String
    let description: String
    let value: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(step)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

struct LowBGWarningView: View {
    let currentBG: String
    let targetBG: String
    let units: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.orange)
                Text("Note")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            Text("Your blood glucose is below target (\(currentBG) < \(targetBG) \(units)). The recommended dose is reduced to account for this. If BG is very low (<\(units == "mg/dL" ? "70" : "3.9") \(units)), treat the low first before eating and dosing insulin.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    let calculator = InsulinCalculator()
    calculator.currentBG = "150"
    calculator.carbs = "45"
    
    return ResultsView(calculator: calculator)
        .padding()
}
