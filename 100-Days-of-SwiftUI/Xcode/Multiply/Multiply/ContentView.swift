//
//  ContentView.swift
//  Multiply
//
//  Created by Tarannum on 02/08/26.
//

import SwiftUI

struct ContentView: View {
    @State private var number1 = Int.random(in: 2...12)
    @State private var number2 = Int.random(in: 2...12)
    @State private var score = 0
    @State private var isShowingGame = false
    @State private var tablesUpTo = 10
    @State private var numberOfRounds = 10
    @State private var roundNumber = 1
    @State private var playerAnswer = ""
    
    @State private var animationAmount = 1.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.5)
                
                if isShowingGame {
                    gameView
                } else {
                    settingsView
                }
            }
        }
    }
    
    private var settingsView: some View {
        VStack {
            VStack(alignment: .leading) {
                CustomStepper(binding: $tablesUpTo, title: "Tables up to", changeBy: 1, upperBound: 12, lowerBound: 2)
            }
            
            VStack(alignment: .leading) {
                CustomStepper(binding: $numberOfRounds, title: "Number of rounds", changeBy: 5, upperBound: 20, lowerBound: 5)
            }
            Spacer()
            
            Button("Start Game") { isShowingGame = true }
                .buttonStyle(.borderedProminent)
                
            
            Spacer()
        }
        .navigationTitle("Multiply")
    }
    
    private var gameView: some View {
        VStack {
            Spacer()
            Text("Round: \(roundNumber)/\(numberOfRounds)")
            Text("Score: \(score)")
            Text("\(number1) X \(number2) = \(playerAnswer)")
                .font(.largeTitle.bold())
                .padding()
            Spacer()
            VStack {
                HStack(spacing: 25) {
                    ForEach(1..<4) { number in
                        AddButton(playerAnswer: $playerAnswer, number: number)
                    }
                }
                HStack(spacing: 25) {
                    ForEach(4..<7) { number in
                        AddButton(playerAnswer: $playerAnswer, number: number)
                    }
                }
                HStack(spacing: 25) {
                    ForEach(7..<10) { number in
                        AddButton(playerAnswer: $playerAnswer, number: number)
                    }
                }
                
                HStack(spacing: 25) {
                    Button {
                        playerAnswer = ""
                    } label: {
                        Image(systemName: "delete.backward")
                            .font(.system(size: 45))
                    }
                    
                    AddButton(playerAnswer: $playerAnswer, number: 0)
                        .padding(25)
                    
                    Button {
                        nextQuestion()
                    } label: {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 50))
                    }
                }
            }
        }
        .padding()
        .toolbar {
            Button("End Game") {
                isShowingGame = false
            }
            .foregroundColor(.red)
            .buttonStyle(.bordered)
        }
    }
    
    struct AddButton: View {
        @Binding var playerAnswer: String
        let number: Int
        let gradient = LinearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom)
        
        var body: some View {
            Button {
                playerAnswer += "\(number)"
            } label: {
                Image(systemName: "\(number).square")
                    .font(.system(size: 60))
                    .foregroundColor(Color(red: 0.15, green: 0.08, blue: 0.02))
                    .frame(width: 100, height: 100)
            }
        }
    }
    func nextQuestion() {
        score += number1 * number2 == Int(playerAnswer) ? 1 : -1
        playerAnswer = ""
        
        if score < 0 { score = 0 }
        
        number1 = Int.random(in: 2...tablesUpTo)
        number2 = Int.random(in: 2...12)
        if roundNumber < 10 {
            roundNumber += 1
        } else {
            roundNumber = 0
            isShowingGame = false
        }
    }
}

struct CustomStepper: View {
    @Binding var binding: Int
    
    let title: String
    let changeBy: Int
    let upperBound: Int
    let lowerBound: Int
    
    var body: some View {
        Text(title)
        HStack(spacing: 24) {
            StepperButton(binding: $binding, isPositive: false, changeBy: changeBy, upperBound: upperBound, lowerBound: lowerBound)
            
            ZStack {
                Circle()
                    .frame(width: 150, height: 150)
                    .foregroundStyle(.gray.opacity(0.2))
                    
                Text("\(binding)")
                    .font(.largeTitle)
            }
            
            StepperButton(binding: $binding, isPositive: true, changeBy: changeBy, upperBound: upperBound, lowerBound: lowerBound)
        }
        .frame(width: 350, height: 200)
        .background(Color.white.opacity(0.7))
        .cornerRadius(16)
    }
}

struct StepperButton: View {
    @Binding var binding: Int
    
    let isPositive: Bool
    let changeBy: Int
    let upperBound: Int
    let lowerBound: Int
    
    var body: some View {
        Button {
            if isPositive {
                binding += changeBy
            } else {
                binding -= changeBy
            }
        } label: {
            Image(systemName: isPositive ? "plus.circle" : "minus.circle")
                .font(.largeTitle)
        }
        .disabled(isPositive ? binding >= upperBound : binding <= lowerBound)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
