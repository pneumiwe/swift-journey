//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Tarannum on 04/07/26.
//

import SwiftUI

struct ContentView: View {
    enum options {
        case rock, paper, scissors
    }
    
    let tempOptions = ["Rock", "Paper", "Scissors"]
    
    @State private var shouldWinText = "win"
    @State private var computerChoice = "Rock"
    @State private var playerChoice = "Rock"
    @State private var shouldWin = false
    @State private var scoreCount = 0
    @State private var scoreTitle = ""
    
    @State private var choice = options.rock
    
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(computerChoice)
                .font(.largeTitle.bold())
            Text("You should: \(shouldWinText)")
            
            Spacer()
            
            HStack(spacing: 50) {
                Button("Rock") {
                    newRound()
                    playerChoice = "Rock"
                    choice = .rock
                }
                Button("Paper") {
                    newRound()
                    playerChoice = "Paper"
                    choice = .paper
                }
                Button("Scissors") {
                    newRound()
                    playerChoice = "Scissors"
                    choice = .scissors
                }
            }
            
            Spacer()
        }
        
        
    }
    
    func newRound() {
        computerChoice = tempOptions[Int.random(in: 0..<3)]
        shouldWin.toggle()
        if shouldWin {
            shouldWinText = "win"
        } else {
            shouldWinText = "lose"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
