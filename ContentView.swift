import SwiftUI

struct ContentView: View {
    @StateObject private var calculator = InsulinCalculator()
    @State private var showingSources = false
    @State private var showingUnitToggleConfirmation = false
    @AppStorage("hasAcknowledgedDisclaimer") private var hasAcknowledgedDisclaimer = false

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
                                showingUnitToggleConfirmation = true
                            }
                            .buttonStyle(.bordered)
                            .font(.caption)
                            .accessibilityLabel("Toggle blood glucose units")
                            .accessibilityHint("Currently using \(calculator.units.displayName)")
                        }
                    }
                    .padding(.horizontal)

                    // Persistent Medical Disclaimer (Always visible, lighter)
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                            Text("This app is NOT FDA approved and is for educational purposes only")
                                .font(.caption2)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.orange.opacity(0.08))
                    .cornerRadius(8)
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
                        .accessibilityLabel("Waiting for input. Enter blood glucose and carb count to calculate insulin dose.")
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
                        .accessibilityLabel(showingSources ? "Hide clinical sources" : "Show clinical sources")

                        if showingSources {
                            SourcesView()
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: Binding(
            get: { !hasAcknowledgedDisclaimer },
            set: { _ in }
        )) {
            DisclaimerModalView(hasAcknowledged: $hasAcknowledgedDisclaimer)
                .interactiveDismissDisabled()
        }
        .confirmationDialog("Switch Units?", isPresented: $showingUnitToggleConfirmation) {
            Button("Switch to \(calculator.units == .mgdl ? "mmol/L" : "mg/dL")") {
                calculator.toggleUnits()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            if !calculator.currentBG.isEmpty, let bg = Double(calculator.currentBG) {
                let converted = calculator.convertBG(bg, fromUnit: calculator.units)
                Text("This will convert your current BG from \(calculator.displayValue(bg)) \(calculator.units.displayName) to \(calculator.displayValue(converted)) \(calculator.units == .mgdl ? "mmol/L" : "mg/dL")")
            } else {
                Text("This will switch between mg/dL and mmol/L units")
            }
        }
    }
}

// MARK: - Mandatory Disclaimer Modal
struct DisclaimerModalView: View {
    @Binding var hasAcknowledged: Bool
    @State private var hasScrolledToBottom = false
    @State private var scrollPosition: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)

                Text("IMPORTANT MEDICAL DISCLAIMER")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Please read carefully before using this app")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 32)
            .padding(.horizontal)

            // Scrollable Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    DisclaimerSection(
                        icon: "cross.case.fill",
                        title: "Not FDA Approved",
                        content: "This app is NOT approved by the FDA or any regulatory agency. It is for educational and informational purposes only."
                    )

                    DisclaimerSection(
                        icon: "stethoscope",
                        title: "Not Medical Advice",
                        content: "This calculator does NOT provide medical advice, diagnosis, or treatment. Always follow your endocrinologist's prescribed insulin regimen and dosing instructions."
                    )

                    DisclaimerSection(
                        icon: "person.2.fill",
                        title: "Consult Your Healthcare Team",
                        content: "Individual insulin needs vary significantly. You MUST consult your diabetes care team before making any changes to your treatment plan or using this calculator."
                    )

                    DisclaimerSection(
                        icon: "drop.triangle.fill",
                        title: "Insulin On Board (IOB)",
                        content: "This calculator does NOT account for active insulin already in your system. Insulin stacking can cause severe hypoglycemia. Always check your pump/CGM for active insulin (IOB) before dosing."
                    )

                    DisclaimerSection(
                        icon: "exclamationmark.octagon.fill",
                        title: "Use At Your Own Risk",
                        content: "You assume all risks and responsibility for using this app. The developer assumes no liability for any harm, injury, or death resulting from use of this calculator."
                    )

                    DisclaimerSection(
                        icon: "clock.fill",
                        title: "For Type 1 Diabetes Only",
                        content: "This calculator is designed for Type 1 Diabetes with rapid-acting insulin. Do not use for Type 2 diabetes or other insulin types without consulting your healthcare provider."
                    )

                    DisclaimerSection(
                        icon: "phone.fill",
                        title: "Emergency Contact",
                        content: "In case of emergency (severe hypoglycemia, unconsciousness, seizures), call 911 or your local emergency services immediately."
                    )

                    // Bottom indicator
                    VStack(spacing: 12) {
                        Divider()

                        Text("By tapping \"I Understand and Accept\", you acknowledge that you have read, understood, and agree to this disclaimer.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.vertical, 20)
                    .background(
                        GeometryReader { geometry in
                            Color.clear.preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: geometry.frame(in: .named("scroll")).minY
                            )
                        }
                    )
                }
                .padding()
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                // Enable button when scrolled near bottom
                hasScrolledToBottom = value < 50
            }

            // Accept Button
            VStack(spacing: 12) {
                Button(action: {
                    hasAcknowledged = true
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("I Understand and Accept")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(hasScrolledToBottom ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(!hasScrolledToBottom)
                .padding(.horizontal)

                if !hasScrolledToBottom {
                    Text("↓ Scroll to bottom to continue")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical)
            .background(Color(.systemBackground))
            .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
        }
    }
}

struct DisclaimerSection: View {
    let icon: String
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.red)

                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
            }

            Text(content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ContentView()
}
