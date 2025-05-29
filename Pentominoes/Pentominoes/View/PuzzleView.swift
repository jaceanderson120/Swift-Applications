//
//  PuzzleView.swift
//  Pentominoes
//
//  Created by Jace Anderson on 9/23/24.
//

import SwiftUI

struct PuzzleView: View {
    var puzzles : PuzzleOutline
    
    var body: some View {
        ZStack {
            ForEach(0..<puzzles.outlines.count, id: \.self) { index in
                Puzzle(puzzles: puzzles, outlineIndex: index)
                    .fill(index == 0 ? Color.gray : Color.white)
                    .stroke(Color.black, lineWidth: 2)
            }
        }
    }
}

#Preview {
    let puzzles = PuzzlePieces()
    PuzzleView(puzzles: puzzles.puzzles[3])
}
