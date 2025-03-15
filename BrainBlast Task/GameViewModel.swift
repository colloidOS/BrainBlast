//
//  GameViewModel.swift
//  BrainBlast Task
//
//  Created by Macintosh HD on 15/03/2025.
//

import SwiftUI


final class GameViewModel: ObservableObject {
    @Published var currentQuestion: Question = Question(prompt: "", answer: 0)
    @Published var currentPlayer: Player = .player1
    @Published var player1Score = 0
    @Published var player2Score = 0
    @Published var roundResults: [RoundResult] = []
    @Published var gameOver = false
    @Published var roundNumber = 1
    @Published var feedbackMessage: String = ""
    @Published var startTime: Date?
    
    // Temporary round state
    private var player1Time: Double = 0
    private var player2Time: Double = 0
    private var player1CurrentAnswer: String = ""
    private var player2CurrentAnswer: String = ""
    
    init() {
        startNewRound()
    }
    
    func generateQuestion() -> Question {
        let a = Int.random(in: 1...20)
        let b = Int.random(in: 1...20)
        return Question(prompt: "What is \(a) * \(b)?", answer: a * b)
    }
    
    /// Start a new round if neither player has reached 3 wins.
    func startNewRound() {
        if player1Score >= 3 || player2Score >= 3 {
            gameOver = true
            return
        }
        currentQuestion = generateQuestion()
        currentPlayer = .player1
        startTime = Date()
        feedbackMessage = ""
    }
    
    /// Called when the current player submits their answer.
    func submitAnswer(_ answerText: String) {
        guard let start = startTime else { return }
        let timeTaken = Date().timeIntervalSince(start)
        let trimmedAnswer = answerText.trimmingCharacters(in: .whitespaces)
        // Convert answer; if conversion fails, treat as wrong answer.
        let answerInt = Int(trimmedAnswer) ?? -999
        let isCorrect = answerInt == currentQuestion.answer
        
        if currentPlayer == .player1 {
            // For Player 1: record their answer and time.
            player1Time = timeTaken
            player1CurrentAnswer = trimmedAnswer
            feedbackMessage = "Your answer was \(isCorrect ? "correct" : "incorrect"). (Time: \(String(format: "%.2f", player1Time)) sec)"
            
            currentPlayer = .player2
            startTime = Date()
        } else {
            // For Player 2: record answer and compute round results.
            player2Time = timeTaken
            player2CurrentAnswer = trimmedAnswer
            let player2Correct = isCorrect
            
            // Determine round winner based on the rules.
            var roundWinner = ""
            let player1AnswerInt = Int(player1CurrentAnswer) ?? -999
            let player1WasCorrect = player1AnswerInt == currentQuestion.answer
            
            if player1WasCorrect && player2Correct {
                if player1Time < player2Time {
                    roundWinner = "Player 1"
                    player1Score += 1
                } else if player2Time < player1Time {
                    roundWinner = "Player 2"
                    player2Score += 1
                } else {
                    roundWinner = "Tie"
                }
            } else if player1WasCorrect && !player2Correct {
                roundWinner = "Player 1"
                player1Score += 1
            } else if !player1WasCorrect && player2Correct {
                roundWinner = "Player 2"
                player2Score += 1
            } else {
                roundWinner = "Tie"
            }
            
            // Create and store the round result.
            let roundResult = RoundResult(
                question: currentQuestion,
                player1Answer: player1CurrentAnswer,
                player1Correct: player1WasCorrect,
                player1Time: player1Time,
                player2Answer: player2CurrentAnswer,
                player2Correct: player2Correct,
                player2Time: player2Time,
                roundWinner: roundWinner
            )
            roundResults.append(roundResult)
            feedbackMessage = """
            Round Result: \(roundWinner)
            Player 1: \(player1CurrentAnswer) (\(player1WasCorrect ? "Correct" : "Incorrect"), \(String(format: "%.2f", player1Time)) sec)
            Player 2: \(player2CurrentAnswer) (\(player2Correct ? "Correct" : "Incorrect"), \(String(format: "%.2f", player2Time)) sec)
            """
            
            roundNumber += 1
            // Brief delay before starting the next round.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.startNewRound()
            }
        }
    }
    
    /// Resets the game to start over.
    func resetGame() {
        player1Score = 0
        player2Score = 0
        roundNumber = 1
        gameOver = false
        roundResults.removeAll()
        startNewRound()
    }
}
