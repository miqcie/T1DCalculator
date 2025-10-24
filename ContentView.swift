import SwiftUI

struct ContentView: View {
    @StateObject private var calculator = InsulinCalculator()
    @State private var showingSources = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("T1D Insulin Calculator")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                
                                Text("Evidence-based dosing for Type 1 Diabetes")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button(calculator.units == .mgdl ? "Switch to mmol/L" : "Switch to mg/dL") {
                                calculator.toggleUnits()
                            }
                            .buttonStyle(.bordered)
                            .font(.caption)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Medical Disclaimer
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("Medical Disclaimer")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        
                        Text("This calculator is for educational purposes only and is NOT medical advice. Always follow your endocrinologist's prescribed insulin regimen and dosing instructions. Consult your diabetes care team before making any changes to your treatment plan. Individual insulin needs vary significantly.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Calculator Inputs
                    CalculatorView(calculator: calculator)
                    
                    // Results
                    if calculator.hasValidInputs {
                        ResultsView(calculator: calculator)
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "syringe")
                                .font(.system(size: 48))
                                .foregroundColor(.secondary)
                            
                            Text("Enter current BG and carb count to calculate dose")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(40)
                    }
                    
                    // Sources Section
                    VStack(spacing: 16) {
                        Button(action: {
                            showingSources.toggle()
                        }) {
                            HStack {
                                Text("Clinical Sources & Methodology")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: showingSources ? "chevron.down" : "chevron.right")
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if showingSources {
                            SourcesView()
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
