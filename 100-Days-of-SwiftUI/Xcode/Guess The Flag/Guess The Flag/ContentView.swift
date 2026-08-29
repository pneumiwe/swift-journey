//
//  ContentView.swift
//  Guess The Flag
//
//  Created by Tarannum on 02/07/26.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreCount = 0
    
    @State private var playerChoice = -1
    @State private var degrees = 0.0
    @State private var opacity = false
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                Gradient.Stop(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                Gradient.Stop(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                Spacer()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            withAnimation(.spring(response: 1.2, dampingFraction: 0.75, blendDuration: 0)) {
                                degrees += 360
                                opacity = true
                            }
                        } label: {
                            Flag(name: countries[number])
                        }
                        .rotation3DEffect(.degrees(playerChoice == number ? degrees : 0.0), axis: (x: 0.0, y: 1.0, z: 0.0))
                        .opacity(opacity && playerChoice != number ? 0.25 : 1.0)
                        .scaleEffect(opacity && playerChoice != number ? 0.9 : 1.0)
                        .blur(radius: opacity && playerChoice != number ? 1.0 : 0.0)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .cornerRadius(20)
                
                Spacer()
                Spacer()
                
                Text("Score: \(scoreCount)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
                
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(scoreCount)")
        }
    }
    
    func flagTapped(_ number: Int) {
        playerChoice = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            scoreCount += 1
        } else {
            scoreTitle = "Wrong"
        }

        showingScore = true
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacity = false
    }
}

struct Flag: View {
    var name: String
    
    var body: some View {
        Image(name)
            .cornerRadius(16)
            .shadow(radius: 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
