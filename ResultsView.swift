import SwiftUI

struct ResultsView: View {
    @ObservedObject var calculator: InsulinCalculator
    @State private var showingLargeDoseConfirmation = false

    var body: some View {
        VStack(spacing: 24) {
            if let result = calculator.calculationResult {
                // CRITICAL: IOB Warning (Always Show)
                IOBWarningView()

                // CRITICAL: Low BG Alert (Improved - Shows at <70 mg/dL)
                if result.isLowBG {
                    CriticalLowBGAlert(
                        currentBG: calculator.displayValue(result.bgInMgdl),
                        targetBG: calculator.displayValue(result.targetInMgdl),
                        units: calculator.units.displayName,
                        isCritical: result.isCriticallyLow
                    )
                }

                // Step-by-Step Calculation
                VStack(alignment: .leading, spacing: 16) {
                    Text("Step-by-Step Calculation")
                        .font(.title2)
                        .fontWeight(.semibold)

                    VStack(spacing: 12) {
                        CalculationStepView(
                            step: "Step 1:",
                            description: "Current BG - Target BG",
                            value: "\(calculator.displayValue(result.bgInMgdl)) - \(calculator.displayValue(result.targetInMgdl)) = \(calculator.displayValue(abs(result.bgDifference)))"
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
                .accessibilityElement(children: .contain)
                .accessibilityLabel("Step by step calculation")

                // Recommended Dose with Large Dose Warning
                VStack(spacing: 16) {
                    Text("Recommended Dose")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("\(String(format: "%.1f", result.roundedDose)) units")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(result.isLargeDose ? .orange : .primary)
                        .accessibilityLabel("Recommended dose: \(String(format: "%.1f", result.roundedDose)) units")

                    Text(calculator.insulinType.rawValue)
                        .font(.headline)
                        .foregroundColor(.secondary)

                    // Large Dose Warning
                    if result.isLargeDose {
                        LargeDoseWarningView(dose: result.roundedDose)
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
                .accessibilityLabel("Reminder to check glucose in 2 hours")
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - IOB Warning (CRITICAL - Always Visible)
struct IOBWarningView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                    .font(.title3)
                Text("CRITICAL: Insulin On Board (IOB)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("⚠️ This calculator does NOT account for active insulin still in your system.")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text("Before dosing:")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                VStack(alignment: .leading, spacing: 4) {
                    Text("• Check your pump/CGM for active insulin (IOB)")
                    Text("• Subtract IOB from the recommended dose")
                    Text("• Insulin stacking can cause severe hypoglycemia")
                    Text("• When in doubt, consult your diabetes care team")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red, lineWidth: 2)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Critical warning: This calculator does not account for active insulin. Check your pump or CGM for insulin on board before dosing.")
    }
}

// MARK: - Critical Low BG Alert (Improved)
struct CriticalLowBGAlert: View {
    let currentBG: String
    let targetBG: String
    let units: String
    let isCritical: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: isCritical ? "exclamationmark.octagon.fill" : "exclamationmark.triangle.fill")
                    .foregroundColor(isCritical ? .red : .orange)
                    .font(.title3)
                Text(isCritical ? "CRITICAL: Dangerously Low BG" : "Warning: Low Blood Glucose")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(isCritical ? .red : .orange)
            }

            if isCritical {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your blood glucose is critically low (\(currentBG) \(units)).")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text("DO NOT DOSE INSULIN. Instead:")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.red)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("1. Treat low immediately (15g fast carbs)")
                        Text("2. Wait 15 minutes and retest")
                        Text("3. If still low, repeat treatment")
                        Text("4. Once BG >70 \(units), recalculate dose")
                        Text("5. Call emergency services if unconscious")
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                }
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your blood glucose is below target (\(currentBG) < \(targetBG) \(units)).")
                        .font(.subheadline)

                    Text("The recommended dose is reduced to account for this. Consider:")
                        .font(.subheadline)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("• Eating before dosing")
                        Text("• Reducing dose by 10-20%")
                        Text("• Consulting your care team if frequently low")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background((isCritical ? Color.red : Color.orange).opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isCritical ? Color.red : Color.orange, lineWidth: 2)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(isCritical ?
            "Critical alert: Blood glucose dangerously low. Do not dose insulin. Treat low immediately." :
            "Warning: Blood glucose below target. Recommended dose is reduced.")
    }
}

// MARK: - Large Dose Warning
struct LargeDoseWarningView: View {
    let dose: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text("Large Dose Alert")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
            }

            Text("This is a large insulin dose (\(String(format: "%.1f", dose)) units). Before dosing:")
                .font(.subheadline)

            VStack(alignment: .leading, spacing: 4) {
                Text("• Verify carb count is accurate")
                Text("• Check for active insulin (IOB)")
                Text("• Consider splitting dose (half now, half in 30-60 min)")
                Text("• Monitor BG closely for 4+ hours")
                Text("• Consult your care team if unsure")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.orange, lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Large dose alert: This is a large insulin dose. Verify carb count and check for active insulin.")
    }
}

// MARK: - Calculation Step View
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(step) \(description): \(value)")
    }
}

#Preview {
    let calculator = InsulinCalculator()
    calculator.currentBG = "150"
    calculator.carbs = "45"

    return ResultsView(calculator: calculator)
        .padding()
}
