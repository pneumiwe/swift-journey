import SwiftUI

// Day 19 Challenge
// Build an app that handles unit conversions: users will select an input unit and an output unit, then enter a value, and see the output of the conversion.

struct ContentView: View {
    @State private var input: Double = 0
    @State private var currentInputUnit = "Celsius"
    @State private var currentOutputUnit = "Fahrenheit"
    
    @FocusState private var isFocused: Bool
    
    let tempUnits = ["Celsius", "Fahrenheit", "Kelvin"]
    var output: Double {
        let temp = convertToC(input, inputUnit: currentInputUnit)
        return convertTemp(temp, outputUnit: currentOutputUnit)
    }
    
    func convertToC(_ input: Double, inputUnit: String) -> Double {
        switch inputUnit {
        case "Fahrenheit": 
            return (input - 32) * 5/9
        case "Kelvin":
            return input - 273.15
        default:
            return input
        }
    }
    
    func convertTemp(_ input: Double, outputUnit: String) -> Double {
        switch outputUnit {
        case "Fahrenheit":
            return (input * 9/5) + 32
        case "Kelvin":
            return input + 273.15
        default:
            return input
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Input") {
                    TextField("Input", value: $input, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isFocused)
                    
                    Picker("Input Unit", selection: $currentInputUnit) {
                        ForEach(tempUnits, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Converted Temperature") {
                    Text(output, format: .number)
                    Picker("Output Unit", selection: $currentOutputUnit) {
                        ForEach(tempUnits, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Temperature Converter")
            .toolbar {
                if isFocused {
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
        }
    }
}
