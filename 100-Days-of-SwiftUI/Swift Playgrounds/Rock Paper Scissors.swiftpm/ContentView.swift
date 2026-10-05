import SwiftUI

// Challenge

// Each turn of the game the app will randomly pick either rock, paper, or scissors.
// Each turn the app will alternate between prompting the player to win or lose.
// The player must then tap the correct move to win or lose the game.
// If they are correct they score a point; otherwise they lose a point.
// The game ends after 10 questions, at which point their score is shown.
// So, if the app chose “Rock” and “Win” the player would need to choose “Paper”, but if the app chose “Rock” and “Lose” the player would need to choose “Scissors”.

 // To solve this challenge you’ll need to draw on skills you learned in tutorials 1 and 2:
            
// Start with an App template, then create a property to store the three possible moves: rock, paper, and scissors.
// You’ll need to create two @State properties to store the app’s current choice and whether the player should win or lose.
// You can use Int.random(in:) to select a random move. You can use it for whether the player should win too if you want, but there’s an even easier choice: Bool.random() is randomly true or false. After the initial value, use toggle() between rounds so it’s always changing.
// Create a VStack showing the player’s score, the app’s move, and whether the player should win or lose. You can use if shouldWin to return one of two different text views.
// The important part is making three buttons that respond to the player’s move: Rock, Paper, or Scissors.
// Use the font() modifier to adjust the size of your text. If you’re using emoji for the three moves, they also scale. Tip: You can ask for very large system fonts using .font(.system(size: 200)) – they’ll be a fixed size, but at least you can make sure they are nice and big!

struct ContentView: View {
    let gameOptions = ["🪨", "📄", "✂️"]
    
    @State private var computerChoice = "🪨"
    @State private var shouldWin = Bool.random()
    @State private var isShowingScore = false
    @State private var score = 0
    @State private var roundCount = 1
    @State private var gradient = Gradient(colors: [.gray, .white])
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    VStack {
                        Text("Round \(roundCount)/10")
                        Text("Score: \(score)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("Computer Chooses...")
                            .font(.title.bold())
                            .padding(.bottom)
                        Text(computerChoice)
                            .font(.system(size: 100))
                    }
                    
                    Spacer()
                    
                    Text("Pick the \(shouldWin ? "winning move" : "losing move") to score")
                    HStack {
                        ForEach(gameOptions, id: \.self) { option in
                            Button(option) {
                                makeMove(option)
                                nextRound()
                                
                            }
                            .font(.system(size: 50))
                            .padding()
                            .background(.white)
                            .clipShape(Circle())
                        }
                        .padding(.horizontal, 10)
                    }
                    Spacer()
                }
                .padding(.vertical, 15)
                .alert("Game Over!", isPresented: $isShowingScore) {
                    Button("New Game", action: resetGame)
                } message: {
                    Text("Score: \(score)")
                }
            }
            .navigationTitle("Rock Paper Scissors")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    // Help used to make this function more efficient. 
    // Went from using a switch to using guard let and modulo (new concept).
    func makeMove(_ playerChoice: String) {
        guard let compIndex = gameOptions.firstIndex(of: computerChoice),
        let playerIndex = gameOptions.firstIndex(of: playerChoice) else { return }
        
        let correctChoice = shouldWin ? (compIndex + 1) % 3 : (compIndex + 2) % 3
        
        if playerIndex == correctChoice { score += 1 } else { 
            if score > 0 {
                score -= 1
            }
        }
    }
    func nextRound() {
        roundCount += 1
        shouldWin.toggle()
        computerChoice = gameOptions[Int.random(in: 0..<3)]
        updateGradient()
        
        if roundCount > 10 {
            roundCount = 10
            if score < 0 { score = 0 }
            isShowingScore = true
        }
    }
    func resetGame() {
        score = 0
        roundCount = 1
        shouldWin = Bool.random()
        computerChoice = gameOptions.randomElement() ?? "🪨"
        updateGradient()
    }

    func updateGradient() {
        gradient = switch computerChoice {
        case "🪨":
            Gradient(colors: [.gray, .white]) 
        case "📄": 
            Gradient(colors: [.black.opacity(0.2), .white])
        case "✂️":
            Gradient(colors: [.red, .white])
        default: Gradient(colors: [.white])
        }
    }
}
