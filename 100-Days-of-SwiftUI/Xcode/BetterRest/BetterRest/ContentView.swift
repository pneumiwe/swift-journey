//
//  ContentView.swift
//  BetterRest
//
//  Created by Suayd on 11/07/26.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? .now
    }
    
    var idealBedTime: String {
        calculateBedtime()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up?"){
                    DatePicker("Wake up time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                }
                .listRowBackground(Color(.systemBackground).opacity(0.5))
                    
                Section("Desired amount of sleep"){
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in:  4...12)
                }
                .listRowBackground(Color(.systemBackground).opacity(0.5))
                    
                Section("Desired amount of coffee") {
                    Picker("Number of cups", selection: $coffeeAmount) {
                        ForEach(1...20, id: \.self) { cup in
                            Text("^[\(cup) cup](inflect: true)")
                        }
                    }
                }
                .listRowBackground(Color(.systemBackground).opacity(0.5))
                
                Section("Your ideal bedtime:") {
                    Text(idealBedTime)
                        .font(.largeTitle)
                }
                .listRowBackground(Color(.systemBackground).opacity(0.5))
                
            }
            .scrollContentBackground(.hidden)
            .background {
                    LinearGradient(
                        colors: [.brown, Color(.systemBackground)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                }
            .navigationTitle("BetterRest ☕️")
        }
    }
    
    func calculateBedtime() -> String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "Error"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
