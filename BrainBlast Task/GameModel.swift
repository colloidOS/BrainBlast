//
//  GameModel.swift
//  BrainBlast Task
//
//  Created by Macintosh HD on 15/03/2025.
//

import SwiftUI


enum Player {
    case player1, player2
}

struct Question {
    let prompt: String
    let answer: Int
}

struct RoundResult {
    let question: Question
    let player1Answer: String
    let player1Correct: Bool
    let player1Time: Double
    let player2Answer: String
    let player2Correct: Bool
    let player2Time: Double
    let roundWinner: String 
}
