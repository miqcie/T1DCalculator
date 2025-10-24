import SwiftUI

struct CalculatorView: View {
    @ObservedObject var calculator: InsulinCalculator
    
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
                    
                    Text(calculator.units.displayName)
                        .foregroundColor(.secondary)
                }
            }
            
            // ICR and ISF Sliders
            HStack(spacing: 16) {
                // ICR Slider
                VStack(alignment: .leading, spacing: 8) {
                    Text("Carb Ratio (ICR)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 8) {
                        HStack {
                            Slider(value: $calculator.icr, in: 5...80, step: 1)
                            
                            Text("1:\(Int(calculator.icr))")
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(minWidth: 60)
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
                            Slider(value: $calculator.isf, in: isfRange, step: isfStep)
                            
                            Text("1:\(calculator.displayValue(calculator.isf))")
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(minWidth: 60)
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
                            if !calculator.isValidBG(newValue) && !newValue.isEmpty {
                                // Show validation feedback if needed
                            }
                        }
                    
                    Text(calculator.units.displayName)
                        .foregroundColor(.secondary)
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
                            if !calculator.isValidCarbs(newValue) && !newValue.isEmpty {
                                // Show validation feedback if needed
                            }
                        }
                    
                    Text("grams")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Computed Properties
    private var isfRange: ClosedRange<Double> {
        calculator.units == .mgdl ? 20...150 : 1.1...8.3
    }
    
    private var isfStep: Double {
        calculator.units == .mgdl ? 5 : 0.3
    }
}

#Preview {
    CalculatorView(calculator: InsulinCalculator())
        .padding()
}
