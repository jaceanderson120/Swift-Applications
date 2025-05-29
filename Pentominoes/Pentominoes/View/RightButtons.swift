//
//  RightButtons.swift
//  Pentominoes
//
//  Created by Jace Anderson on 9/22/24.
//

import SwiftUI

struct RightButtons: View {
    var puzzles : PuzzlePieces
    var rows = 3
    var columns = 3
    
    var body: some View {
        VStack {
            ForEach(4...6, id: \.self) { nums in
                Button(action: {puzzles.updatePuzzle(puzzle: puzzles.puzzles[nums])}) {
                    ZStack {
                        let puzzleWidth = CGFloat(puzzles.puzzles[nums].size.width) / 14.0 * 100
                        let puzzleHeight = CGFloat(puzzles.puzzles[nums].size.height) / 14.0 * 100
                        PuzzleView(puzzles: puzzles.puzzles[nums])
                            .frame(width: puzzleWidth, height: puzzleHeight)
                        Grid(rows: 3, columns: 3)
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(width: 100, height: 100)
                    }
                    .frame(width: 100, height: 100)
                }
                .padding()
            }
            Button(action: {}) {
                Grid(rows: 3, columns: 3)
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: 100, height: 100)
            }
        }
    }}

#Preview {
    let puzzles = PuzzlePieces()
    RightButtons(puzzles: puzzles)
}
