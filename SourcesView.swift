import SwiftUI

struct SourcesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SourceItemView(
                title: "Carb Counting Method",
                description: "American Diabetes Association. Standards of Care in Diabetes—2025, Section 5 (Nutrition Therapy) & Section 9 (Type 1 Diabetes).",
                linkText: "Read ADA Standards 2025 →",
                linkURL: "https://diabetesjournals.org/care/issue/48/Supplement_1"
            )
            
            SourceItemView(
                title: "500 Rule for Insulin-to-Carb Ratio",
                description: "Walsh J, Roberts R. Pumping Insulin: Everything You Need for Success on an Insulin Pump. 6th ed. Torrey Pines Press; 2016. Formula: ICR = 500 ÷ Total Daily Dose.\n\nValidated in pediatrics: Hanas R, et al. \"Bolus calculator settings in well-controlled prepubertal children.\" J Diabetes Sci Technol. 2017;11(3):632-639.",
                linkText: "Read Hanas et al. study →",
                linkURL: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5478012/"
            )
            
            SourceItemView(
                title: "1800 Rule for Insulin Sensitivity Factor",
                description: "Walsh J, Roberts R, Bailey TS. \"Guidelines for optimal bolus calculator settings in adults.\" J Diabetes Sci Technol. 2011;5(1):129-135. Formula: ISF = 1800 ÷ Total Daily Dose.\n\nBased on Davidson PC, et al. \"Analysis of guidelines for basal-bolus insulin dosing.\" Endocr Pract. 2008;14(7):933-946.",
                linkText: "Read Walsh et al. guidelines →",
                linkURL: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3192590/"
            )
            
            SourceItemView(
                title: "Correction Dose Formula",
                description: "Correction = (Current BG - Target BG) ÷ ISF. Standard algorithm used in insulin pump bolus calculators.",
                linkText: nil,
                linkURL: nil
            )
            
            SourceItemView(
                title: "Pediatric Considerations",
                description: "DiMeglio LA, et al. \"ISPAD Clinical Practice Consensus Guidelines 2018: Glycemic control targets.\" Pediatr Diabetes. 2018;19(Suppl 27):105-114.\n\nNote: Young children often need more insulin per carb than the 500 Rule suggests, especially at breakfast.",
                linkText: "Read ISPAD Guidelines →",
                linkURL: "https://pubmed.ncbi.nlm.nih.gov/30039513/"
            )
            
            // Important Notice
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("Important")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                Text("These calculations provide starting points only. Work with your endocrinologist to adjust ICR and ISF based on actual blood glucose patterns. Values change during honeymoon phase and throughout life with T1D.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct SourceItemView: View {
    let title: String
    let description: String
    let linkText: String?
    let linkURL: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(nil)
            
            if let linkText = linkText, let linkURL = linkURL {
                Link(linkText, destination: URL(string: linkURL)!)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    SourcesView()
        .padding()
}
