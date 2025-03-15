//
//  GameOverView.swift
//  BrainBlast Task
//
//  Created by Macintosh HD on 15/03/2025.
//

import SwiftUI

struct GameOverView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Game Over")
                .font(.largeTitle)
            Text("Final Score")
                .font(.title)
            HStack {
                Text("Player 1: \(viewModel.player1Score)")
                Text("Player 2: \(viewModel.player2Score)")
            }
            if viewModel.player1Score > viewModel.player2Score {
                Text("Player 1 Wins!")
                    .font(.headline)
                    .foregroundColor(.brainBlue)
            } else if viewModel.player2Score > viewModel.player1Score {
                Text("Player 2 Wins!")
                    .font(.headline)
                    .foregroundColor(.brainBlue)
            } else {
                Text("It's a Tie!")
                    .font(.headline)
                    .foregroundColor(.orange)
            }
            Divider()
            Text("Round Results")
                .font(.title2)
            List(viewModel.roundResults.indices, id: \.self) { index in
                let result = viewModel.roundResults[index]
                VStack(alignment: .leading, spacing: 4) {
                    Text("Round \(index + 1): \(result.question.prompt)")
                    Text("Player 1: \(result.player1Answer) – \(result.player1Correct ? "Correct" : "Incorrect") (\(String(format: "%.2f", result.player1Time)) sec)")
                    Text("Player 2: \(result.player2Answer) – \(result.player2Correct ? "Correct" : "Incorrect") (\(String(format: "%.2f", result.player2Time)) sec)")
                    Text("Winner: \(result.roundWinner)")
                        .bold()
                }
                .padding(5)
            }

            Button{
                viewModel.resetGame()
                }
        label: {
          Text("Play Again")
                .bold()
                .font(.title3)
                .foregroundColor(.white)
                .padding()
                .background(
                    Color.black
                        .cornerRadius(10)
                )
                .padding()
            
        }
        
        }
        .padding()
    }
}

#Preview {
    GameOverView(viewModel: GameViewModel.init())
}
