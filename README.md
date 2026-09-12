# T1D Insulin Calculator - iOS App

A native iOS app version of the Humaine Studio T1D Insulin Calculator, built with SwiftUI.

## Features

- **Insulin dose calculation** (carb coverage + correction)
- **Unit conversion** (mg/dL ↔ mmol/L)
- **Adjustable ICR and ISF** via sliders
- **Multiple insulin type support**
- **Step-by-step calculation display**
- **Clinical source references**
- **Native iOS design** with SwiftUI

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.0+

## Installation

Run the setup check first. It verifies the file layout and runs the
34 calculation-engine unit tests through Swift Package Manager:

```bash
bash check-setup.sh
```

The SwiftUI app itself needs an Xcode project (SwiftPM cannot run iOS
apps). Create it once, in this folder:

1. Xcode: File → New → Project → iOS → App
2. Product Name `T1DCalculator`, Organization Identifier `studio.humaine`, Interface SwiftUI, Language Swift, Include Tests checked
3. Save into this repository folder
4. Delete Xcode's generated `ContentView.swift` and `T1DCalculatorApp.swift`
5. File → Add Files: add the six app `.swift` files to the `T1DCalculator` target and the two `*Tests*.swift` files to the `T1DCalculatorTests` target
6. Build and run (⌘R); run tests (⌘U)

Do not commit `xcuserdata/` or build output; `.gitignore` already covers them.
See `TESTING_QUICKSTART.md` for the full testing workflow.

## Usage

1. **Select Insulin Type**: Choose from the dropdown menu
2. **Set Target BG**: Enter your target blood glucose level
3. **Adjust Ratios**: Use sliders to set your ICR and ISF
4. **Enter Current BG**: Input your current blood glucose reading
5. **Enter Carbs**: Input the carbohydrate count for your meal
6. **View Results**: See the calculated dose with step-by-step breakdown

## Medical Disclaimer

This calculator is for educational purposes only and is NOT medical advice. Always follow your endocrinologist's prescribed insulin regimen and dosing instructions. Consult your diabetes care team before making any changes to your treatment plan. Individual insulin needs vary significantly.

## Clinical Sources

The calculator is based on established clinical guidelines:

- **Carb Counting**: American Diabetes Association Standards of Care 2025
- **500 Rule (ICR)**: Walsh & Roberts, "Pumping Insulin" 6th Edition
- **1800 Rule (ISF)**: Walsh et al., J Diabetes Sci Technol 2011
- **Correction Formula**: Standard insulin pump algorithms

## Architecture

- **SwiftUI**: Modern declarative UI framework
- **MVVM Pattern**: Clean separation of concerns
- **ObservableObject**: Reactive data binding
- **Type Safety**: Strong typing with enums and structs

## File Structure

```
T1DCalculator/
├── T1DCalculatorApp.swift      # App entry point
├── ContentView.swift           # Main view container
├── InsulinCalculator.swift     # Core calculation logic
├── CalculatorView.swift        # Input form UI
├── ResultsView.swift          # Results display
├── SourcesView.swift         # Clinical sources
└── README.md                 # This file
```

## Development

### Key Components

1. **InsulinCalculator**: ObservableObject containing all calculation logic
2. **BloodGlucoseUnit**: Enum for mg/dL and mmol/L units
3. **InsulinType**: Enum for different insulin types
4. **CalculationResult**: Struct for calculation results

### Calculation Logic

The app implements the same clinical algorithms as the web version:
- Correction dose = (Current BG - Target BG) ÷ ISF
- Carb dose = Carbs ÷ ICR
- Total dose = Correction + Carb
- Hospital rounding for half-unit dosing

## Future Enhancements

- Save personal settings (UserDefaults)
- Insulin on board (IOB) tracking
- Dose history logging
- Time-based ratios
- Quick food database
- Treatment calculator for hypoglycemia

## License

This project is part of Humaine Studio. All rights reserved.

## Support

For questions or issues, please contact the development team.
