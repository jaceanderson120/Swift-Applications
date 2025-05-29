//
//  GameBoard.swift
//  Pentominoes
//
//  Created by Jace Anderson on 9/22/24.
//

import SwiftUI

struct GameBoard: View {
    var puzzles : PuzzlePieces
    @Binding var resetSignal : Bool
    @Binding var solveSignal : Bool
    
    var body: some View {
        HStack {
            LeftButtons(puzzles: puzzles)
            ZStack {
                VStack {
                    ZStack {
                        if let currentPuzzle = puzzles.currentPuzzle {
                            let puzzleWidth = CGFloat(currentPuzzle.size.width) / 14.0 * 400
                            let puzzleHeight = CGFloat(currentPuzzle.size.height) / 14.0 * 400
                            
                            PuzzleView(puzzles: currentPuzzle)
                                .frame(width: puzzleWidth, height: puzzleHeight)
                        }
                        Grid(rows: 14, columns: 14)
                            .stroke(Color.black, lineWidth: 2)
                            .background(
                                    GeometryReader { geometry in
                                        Color.clear
                                    }
                                )
                    }
                    .frame(width: 400, height: 400)
                    PentaminoView(resetSignal: $resetSignal, solveSignal: $solveSignal, puzzles: puzzles)
                }
            }
            RightButtons(puzzles: puzzles)
        }
    }
}

#Preview {
    @Previewable @State var reset : Bool = false
    @Previewable @State var solve : Bool = false
    let puzzles = PuzzlePieces()
    GameBoard(puzzles: puzzles, resetSignal: $reset, solveSignal: $solve)
}
