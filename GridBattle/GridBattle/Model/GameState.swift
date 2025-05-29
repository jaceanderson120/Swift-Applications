//
//  GameState.swift
//  GridBattle
//
//  Created by Jace Anderson on 12/9/24.
//
import Foundation

struct GameState: Codable {
    let pieces: [Position: GamePiece]
    let board: [Position: SquareState]
    let currentPlayer: Players
    let gamePhase: TurnPhase
    let turnCount: Int
    let gameOver: Bool
    let redWon: Bool
    let blueWon: Bool
    let deadPieces: [GamePiece]
}
