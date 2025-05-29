//
//  BoardSquareMult.swift
//  GridBattle
//
//  Created by Jace Anderson on 12/11/24.
//

import SwiftUI

struct BoardSquareMult: View {
    @Binding var multmanager: MultiplayerGameManager
    @Binding var manager: MultiplayerGameManagerBoardTwo
    let position: Position

    var square: SquareState {
        manager.board[position] ?? SquareState(color: "clear", containsPiece: false, isHighlighted: false, possibleMove: false)
    }

    func color(from name: String) -> Color {
        switch name.lowercased() {
        case "white": return .white
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "yellow": return .yellow
        default: return .clear
        }
    }

    var pieceOverlay: some View {
        Group {
            if square.containsPiece {
                manager.getImage(position: position)
                    .resizable()
                    .scaledToFit()
            }
        }
    }

    var moveOverlay: some View {
        Group {
            if square.possibleMove {
                Circle()
                    .fill(Color.yellow.opacity(0.6))
                    .frame(width: 20, height: 20)
            }
        }
    }

    func handleTap() {
        if manager.playerTurn == manager.player {
            if !manager.gameOver && manager.turnPhase == .move {
                if square.containsPiece && ((manager.player == .player1 && square.color == "blue") || (manager.player == .player2 && square.color == "red")) {
                    manager.resetBoard()
                    let moves = manager.getAvailableMoves(position: position)
                    for move in moves {
                        manager.board[move]?.isHighlighted = true
                    }
                } else if square.possibleMove {
                    manager.movePiece(position: position)
                    multmanager.sendBoardAndPieces()
                    manager.resetBoard()
                } else {
                    manager.resetBoard()
                }
            } else if !manager.gameOver && manager.turnPhase == .relocate && ((manager.player == .player1 && square.color == "blue") || (manager.player == .player2 && square.color == "red")) {
                if square.containsPiece {
                    manager.resetBoard()
                    let moves = manager.getAllRelocateMoves(position: position)
                    for move in moves {
                        manager.board[move]?.isHighlighted = true
                    }
                } else if square.possibleMove {
                    manager.relocatePiece(position: position)
                    multmanager.sendBoardAndPieces()
                    manager.resetBoard()
                } else {
                    manager.resetBoard()
                }
            }
        }
    }

    var body: some View {
        Rectangle()
            .fill(color(from: square.color))
            .frame(width: 75, height: 75)
            .overlay(pieceOverlay)
            .overlay(moveOverlay)
            .onTapGesture(perform: handleTap)
    }
}

#Preview {
    @Previewable @State var multmanager = MultiplayerGameManager()
    @Previewable @State var manager = MultiplayerGameManagerBoardTwo()
    let position = Position(row: 0, column: 0)
    BoardSquareMult(multmanager: $multmanager, manager: $manager, position: position)
}
