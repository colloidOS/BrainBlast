//
//  ContentView.swift
//  BrainBlast Task
//
//  Created by Macintosh HD on 15/03/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = GameViewModel()
    @State private var answerText: String = ""
    @State private var gameStarted = false
    @State private var elapsedTime: Double = 0.0
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            if !gameStarted {
                PreGameView {
                    gameStarted = true
                    viewModel.startTime = Date()
                }
                .navigationTitle("Get Ready")
            } else {
                if viewModel.gameOver {
                    GameOverView(viewModel: viewModel)
                } else {
                    VStack(spacing: 20) {
                        Text("Round \(viewModel.roundNumber)")
                            .font(.title)
                        Text("Player \(viewModel.currentPlayer == .player1 ? "1" : "2")'s Turn")
                            .font(.headline)
                        Text(viewModel.currentQuestion.prompt)
                            .font(.title2)
                            .padding()
                        
                        Text("Time: \(String(format: "%.1f", elapsedTime)) sec")
                            .font(.title3)
                            .onReceive(timer) { _ in
                                if let start = viewModel.startTime {
                                    elapsedTime = Date().timeIntervalSince(start)
                                }
                            }
                        
                        TextField("Enter your answer", text: $answerText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .padding()
                        Button {
                            guard !answerText.isEmpty else { return }
                            viewModel.submitAnswer(answerText)
                            answerText = ""
                            elapsedTime = 0.0
                        } label: {
                            Text("Submit")
//                                  .bold()
                                  .font(.title3)
                                  .foregroundColor(.white)
                                  .padding()
                                  .background(
                                      Color.black
                                          .cornerRadius(10)
                                  )
                                  .padding()
                              
                          }
                        .padding()
                        
                        Text(viewModel.feedbackMessage)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        HStack {
                            Text("Player 1 Wins: \(viewModel.player1Score)")
                            Spacer()
                            Text("Player 2 Wins: \(viewModel.player2Score)")
                        }
                        .padding()
                    }
                    .padding()
                    .navigationTitle("SAT Math Trivia")
                }
            }
        }
    }
}





#Preview {
    ContentView()
}
