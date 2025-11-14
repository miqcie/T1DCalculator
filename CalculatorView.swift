import SwiftUI

struct CalculatorView: View {
    @ObservedObject var calculator: InsulinCalculator
    @State private var showingBGError = false
    @State private var showingCarbsError = false

    var body: some View {
        VStack(spacing: 24) {
            // Insulin Type Selection
            VStack(alignment: .leading, spacing: 8) {
                Text("Insulin Type")
                    .font(.headline)
                    .foregroundColor(.primary)

                Picker("Insulin Type", selection: $calculator.insulinType) {
                    ForEach(InsulinType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .accessibilityLabel("Select insulin type")
                .accessibilityValue(calculator.insulinType.rawValue)
            }

            // Target BG
            VStack(alignment: .leading, spacing: 8) {
                Text("Target BG (\(calculator.units.displayName))")
                    .font(.headline)
                    .foregroundColor(.primary)

                HStack {
                    TextField("Target BG", value: $calculator.targetBG, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .accessibilityLabel("Target blood glucose")
                        .accessibilityValue("\(calculator.displayValue(calculator.targetBG)) \(calculator.units.displayName)")

                    Text(calculator.units.displayName)
                        .foregroundColor(.secondary)
                }

                // Show range hint
                Text("Range: \(calculator.displayValue(calculator.targetBGRange.lowerBound))-\(calculator.displayValue(calculator.targetBGRange.upperBound)) \(calculator.units.displayName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // ICR and ISF Sliders
            VStack(spacing: 16) {
                // ICR Slider
                VStack(alignment: .leading, spacing: 8) {
                    Text("Carb Ratio (ICR)")
                        .font(.headline)
                        .foregroundColor(.primary)

                    VStack(spacing: 8) {
                        HStack {
                            Slider(value: $calculator.icr, in: calculator.icrRange, step: 1)
                                .accessibilityLabel("Insulin to carb ratio")
                                .accessibilityValue("1 unit per \(Int(calculator.icr)) grams of carbs")
                                .accessibilityHint("Adjust how many grams of carbs one unit of insulin covers")

                            Text("1:\(Int(calculator.icr))")
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(minWidth: 50)
                        }

                        Text("1 unit per \(Int(calculator.icr))g carbs")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                // ISF Slider
                VStack(alignment: .leading, spacing: 8) {
                    Text("Correction Factor (ISF)")
                        .font(.headline)
                        .foregroundColor(.primary)

                    VStack(spacing: 8) {
                        HStack {
                            Slider(value: $calculator.isf, in: calculator.isfRange, step: isfStep)
                                .accessibilityLabel("Insulin sensitivity factor")
                                .accessibilityValue("1 unit drops blood glucose by \(calculator.displayValue(calculator.isf)) \(calculator.units.displayName)")
                                .accessibilityHint("Adjust how much one unit of insulin lowers your blood glucose")

                            Text("1:\(calculator.displayValue(calculator.isf))")
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(minWidth: 50)
                        }

                        Text("1 unit drops BG by \(calculator.displayValue(calculator.isf)) \(calculator.units.displayName)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            // Current BG Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Current Blood Glucose (\(calculator.units.displayName))")
                    .font(.headline)
                    .foregroundColor(.primary)

                HStack {
                    TextField("Enter current BG", text: $calculator.currentBG)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .onChange(of: calculator.currentBG) { newValue in
                            validateBGInput(newValue)
                        }
                        .accessibilityLabel("Current blood glucose")
                        .accessibilityHint("Enter your current blood glucose reading")

                    Text(calculator.units.displayName)
                        .foregroundColor(.secondary)
                }

                // Validation feedback
                if showingBGError && !calculator.currentBG.isEmpty {
                    if calculator.isCriticallyLowBG(calculator.currentBG) {
                        Text("⚠️ CRITICAL: Blood glucose dangerously low. Treat immediately!")
                            .font(.caption)
                            .foregroundColor(.red)
                            .fontWeight(.semibold)
                    } else if !calculator.isValidBG(calculator.currentBG) {
                        let range = calculator.units == .mgdl ? "40-600 mg/dL" : "2.2-33.3 mmol/L"
                        Text("Valid range: \(range)")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }

            // Carbs Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Carbs in Meal (grams)")
                    .font(.headline)
                    .foregroundColor(.primary)

                HStack {
                    TextField("Enter carb count", text: $calculator.carbs)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .onChange(of: calculator.carbs) { newValue in
                            validateCarbsInput(newValue)
                        }
                        .accessibilityLabel("Carbohydrates in meal")
                        .accessibilityHint("Enter the total grams of carbs you're eating")

                    Text("grams")
                        .foregroundColor(.secondary)
                }

                // Validation feedback
                if showingCarbsError && !calculator.carbs.isEmpty {
                    if calculator.isLargeCarbs(calculator.carbs) {
                        Text("⚠️ Large carb count. Consider splitting dose or consulting your care team.")
                            .font(.caption)
                            .foregroundColor(.orange)
                    } else if !calculator.isValidCarbs(calculator.carbs) {
                        Text("Valid range: 0-300 grams")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Validation Methods
    private func validateBGInput(_ value: String) {
        guard !value.isEmpty else {
            showingBGError = false
            return
        }

        showingBGError = calculator.isCriticallyLowBG(value) || !calculator.isValidBG(value)

        // Haptic feedback for critical values
        if calculator.isCriticallyLowBG(value) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }

    private func validateCarbsInput(_ value: String) {
        guard !value.isEmpty else {
            showingCarbsError = false
            return
        }

        showingCarbsError = calculator.isLargeCarbs(value) || !calculator.isValidCarbs(value)
    }

    // MARK: - Computed Properties
    private var isfStep: Double {
        calculator.units == .mgdl ? 1.0 : 0.1  // Finer granularity for mmol/L
    }
}

#Preview {
    CalculatorView(calculator: InsulinCalculator())
        .padding()
}
