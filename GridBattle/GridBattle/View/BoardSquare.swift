//
//  BoardSquare.swift
//  GridBattle
//
//  Created by Jace Anderson on 11/21/24.
//

import SwiftUI

struct BoardSquare: View {
    @Binding var manager : GameManagerBoardTwo
    let position : Position
    
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

    var body: some View {
        let square = manager.board[position] ?? SquareState(color: "clear", containsPiece: false, isHighlighted: false, possibleMove: false)
        Rectangle()
            .fill(color(from: square.color))
            .frame(width: 75, height: 75)
            .overlay(
                Group {
                    if square.containsPiece {
                        manager.getImage(position: position)
                            .resizable()
                            .scaledToFit()
                    }
                }
            )
            .overlay(
                Group {
                    if square.possibleMove {
                        Circle()
                            .fill(Color.yellow.opacity(0.6))
                            .frame(width: 20, height: 20)
                    }
                }
            )
            .onTapGesture {
                if !manager.gameOver && manager.turnPhase == .move {
                    if square.containsPiece && ((manager.player == .player1 && square.color == "blue") || (manager.player == .player2 && square.color == "red")) {
                        manager.resetBoard()
                        let moves = manager.getAvailableMoves(position: position)
                        for move in moves {
                            manager.board[move]?.isHighlighted = true
                        }
                    } else if square.possibleMove {
                        manager.movePiece(position: position)
                        manager.resetBoard()
                    }
                    else {
                        manager.resetBoard()
                    }
                } else if !manager.gameOver && manager.turnPhase == .relocate && ((manager.player == .player1 && square.color == "blue") || (manager.player == .player2 && square.color == "red")) {
                    if square.containsPiece {
                        manager.resetBoard()
                        let moves = manager.getAllRelocateMoves(position: position)
                        if moves.count == 0 {
                            manager.endRelocatePhase()
                        }
                        for move in moves {
                            manager.board[move]?.isHighlighted = true
                        }
                    } else if square.possibleMove {
                        manager.relocatePiece(position: position)
                        manager.resetBoard()
                    } else {
                        manager.resetBoard()
                    }
                }
            }
    }
}

#Preview {
    @Previewable @State var manager = GameManagerBoardTwo()
    let position = Position(row: 0, column: 0)
    BoardSquare(manager: $manager, position: position)
}
