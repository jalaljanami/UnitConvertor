//
//  ContentView.swift
//  UnitConvertor
//
//  Created by jalal on 10/19/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedUnitType: UnitType = .length
    @State private var selectedUnits: [String] = []
    
    @State private var originUnit: String = String()
    @State private var destinationUnit: String = String()
    
    @State private var originValue: Double? = nil
    
    var destinationValue: Double? {
        guard let originValue = originValue else { return nil }
        return UnitConverter.convert(from: originUnit, to: destinationUnit, value: originValue)
    }
    
    var body: some View {
        Form {
            Section {
                Picker("Select Unit", selection: $selectedUnitType) {
                    ForEach(UnitType.allCases, id: \.self) {
                        Text($0.rawValue)
                            .fixedSize()
                            .scaledToFill()
                    }
                }
                .pickerStyle(.segmented)
                .onAppear {
                    updateUnits(for: selectedUnitType.units)
                }
                .onChange(of: selectedUnitType) {
                    updateUnits(for: selectedUnitType.units)
                }
            }
            
            Section {
                VStack {
                    TextField("Type your value", value: $originValue, format: .number)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .multilineTextAlignment(.center)
                        .bold()
                        .font(.title)
                        .keyboardType(.decimalPad)
                
                    HStack {
                        HStack(alignment: .center) {
                            Text("From:")
                                .font(.system(size: 12))
                            Picker("", selection: $originUnit) {
                                ForEach(selectedUnits, id: \.self) { unit in
                                    Text(unit)
                                }
                            }
                            .pickerStyle(.automatic)
                        }
                        
                        Divider()
                        HStack {
                            Text("To:")
                                .font(.system(size: 12))
                            Picker("", selection: $destinationUnit) {
                                ForEach(selectedUnits, id: \.self) { unit in
                                    Text(unit)
                                }
                            }
                            .pickerStyle(.automatic)
                        }
                    }
                }
            }
            
            Section {
                Text(String(format: "%.2f", destinationValue ?? 0.0))
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    func updateUnits(for Unit: [String]) {
        selectedUnits = Unit
        originUnit = Unit.first ?? "Meter"
        destinationUnit = Unit.first ?? "Meter"
        print(selectedUnits)
    }
}

#Preview {
    ContentView()
}

extension ContentView {
    
    public enum UnitType: String, CaseIterable {
        case length = "length"
        case weight = "weight"
        case volume = "volume"
        case temperature = "temp"
        
        var units: [String] {
            switch self {
            case.length: return Length.allCases.map(\.rawValue)
            case.weight: return Weight.allCases.map(\.rawValue)
            case.volume: return Volume.allCases.map(\.rawValue)
            case.temperature: return Temperature.allCases.map(\.rawValue)
            }
        }
    }
    
    enum Length: String, CaseIterable {
        case meter = "Meter"
        case foot = "Foot"
        case inch = "Inch"
    }
    
    enum Weight: String, CaseIterable {
        case kilogram = "Kilogram"
        case pound = "Pound"
        case ounce = "Ounce"
    }
    
    enum Volume: String, CaseIterable {
        case liter = "Liter"
        case gallon = "Gallon"
        case cubicFoot = "Cubic Foot"
    }
    
    enum Temperature: String, CaseIterable {
        case celsius = "Celsius"
        case fahrenheit = "Fahrenheit"
        case kelvin = "Kelvin"
    }
}

struct UnitConverter {
    static func convert(from: String, to: String, value: Double) -> Double {
        switch (from, to) {
        case ("Meter", "Foot"): return value * 3.281
        case ("Meter", "Inch"): return value * 39.370
        case ("Foot", "Meter"): return value * 0.304
        case ("Foot", "Inch"): return value * 12
        case ("Inch", "Foot"): return value * 0.083
        case ("Inch", "Meter"): return value * 0.025

        case ("Kilogram", "Pound"): return value * 2.205
        case ("Kilogram", "Ounce"): return value * 35.274
        case ("Pound", "Kilogram"): return value * 0.453
        case ("Pound", "Ounce"): return value * 16
        case ("Ounce", "Kilogram"): return value * 0.028
        case ("Ounce", "Pound"): return value * 0.062

        case ("Liter", "Gallon"): return value * 0.264
        case ("Liter", "Cubic Foot"): return value * 0.035
        case ("Gallon", "Liter"): return value * 3.785
        case ("Gallon", "Cubic Foot"): return value * 0.133
        case ("Cubic Foot", "Liter"): return value * 28.316
        case ("Cubic Foot", "Gallon"): return value * 7.480

        case ("Celsius", "Fahrenheit"): return (value * 9 / 5) + 32
        case ("Celsius", "Kelvin"): return value + 273.15
        case ("Fahrenheit", "Celsius"): return (value - 32) * 5 / 9
        case ("Fahrenheit", "Kelvin"): return ((value - 32) * 5 / 9) + 273.15
        case ("Kelvin", "Celsius"): return value - 273.15
        case ("Kelvin", "Fahrenheit"): return ((value - 273.15) * 9 / 5) + 32

        default: return value
        }
    }
}
