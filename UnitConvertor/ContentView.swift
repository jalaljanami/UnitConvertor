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
    
    private var destinationValue: Double {
        convert()
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
                Text(String(format: "%.2f", destinationValue))
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
    
    func convert() -> Double {
        
        let value = (originValue ?? 0.0)
        let from = originUnit
        let to = destinationUnit
        
        switch (from, to) {
        case (Length.meter.rawValue, Length.foot.rawValue): return (originValue ?? 0.0) * 3.281 //Multiply
        case (Length.meter.rawValue, Length.inch.rawValue): return value * 39.370 //Multiply
        case (Length.foot.rawValue, Length.meter.rawValue): return value * 0.304 //Multiply
        case (Length.foot.rawValue, Length.inch.rawValue): return value * 12 //Multiply
        case (Length.inch.rawValue, Length.foot.rawValue): return value * 0.083 //Multiply
        case (Length.inch.rawValue, Length.meter.rawValue): return value * 0.025 //Multiply
            
        case (Weight.kilogram.rawValue, Weight.pound.rawValue): return value * 2.205 //Multiply
        case (Weight.kilogram.rawValue, Weight.ounce.rawValue): return value * 35.274 //Multiply
        case (Weight.pound.rawValue, Weight.kilogram.rawValue): return value * 0.453 //Multiply
        case (Weight.pound.rawValue, Weight.ounce.rawValue): return value * 16 //Multiply
        case (Weight.ounce.rawValue, Weight.kilogram.rawValue): return value * 0.028 //Multiply
        case (Weight.ounce.rawValue, Weight.pound.rawValue): return value * 0.062 //Multiply
            
        case (Volume.liter.rawValue, Volume.gallon.rawValue): return value * 0.264 //Multiply
        case (Volume.liter.rawValue, Volume.cubicFoot.rawValue): return value * 0.035 //Multiply
        case (Volume.gallon.rawValue, Volume.liter.rawValue): return value * 3.785 //Multiply
        case (Volume.gallon.rawValue, Volume.cubicFoot.rawValue): return value * 0.133 //Multiply
        case (Volume.cubicFoot.rawValue, Volume.liter.rawValue): return value * 28.316 //Multiply
        case (Volume.cubicFoot.rawValue, Volume.gallon.rawValue): return value * 7.480 //Multiply
            
        case (Temperature.celsius.rawValue, Temperature.fahrenheit.rawValue): return ((value * 9 / 5) + 32)
        case (Temperature.celsius.rawValue, Temperature.kelvin.rawValue): return (value + 273.15)
        case (Temperature.fahrenheit.rawValue, Temperature.celsius.rawValue): return ((value - 32) * 5 / 9)
        case (Temperature.fahrenheit.rawValue, Temperature.kelvin.rawValue): return ((((value - 32) * 5 / 9)) + 273.15)
        case (Temperature.kelvin.rawValue, Temperature.celsius.rawValue): return (value - 273.15)
        case (Temperature.kelvin.rawValue, Temperature.fahrenheit.rawValue): return (((value - 273.15) * 9 / 5) + 32)
            
        case (_, _):
            return value * 1.0
        }
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
