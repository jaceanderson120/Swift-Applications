//
//  Puzzle.swift
//  Pentominoes
//
//  Created by Jace Anderson on 9/22/24.
//

import SwiftUI

struct Puzzle: Shape {
    var puzzles : PuzzleOutline
    var outlineIndex : Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        var value = 0
        let xVal = rect.width / CGFloat(puzzles.size.width)
        let yVal = rect.height / CGFloat(puzzles.size.height)
        
        for puzzle in puzzles.outlines[outlineIndex] {
            let xPoint = CGFloat(puzzle.x) * xVal
            let yPoint = CGFloat(puzzle.y) * yVal
            if (value == 0) {
                path.move(to: CGPoint(x: xPoint, y: yPoint))
                value = 1
            } else {
                path.addLine(to: CGPoint(x: xPoint, y: yPoint))
            }
        }
        
        return path
        
    }
}

#Preview {
    let puzzle = PuzzlePieces()
    Puzzle(puzzles: puzzle.currentPuzzle!, outlineIndex: 0)
        .frame(width: 200, height: 200)
}
