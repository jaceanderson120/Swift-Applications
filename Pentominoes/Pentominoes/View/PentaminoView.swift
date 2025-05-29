//
//  PentaminoView.swift
//  Pentominoes
//
//  Created by Jace Anderson on 9/23/24.
//

import SwiftUI

struct PentaminoView: View {
    @Binding var resetSignal : Bool
    @Binding var solveSignal : Bool
    var puzzles : PuzzlePieces
    var body: some View {
        VStack {
            HStack {
                ForEach(0...3, id: \.self) { index in
                    ModularPentaminoView(puzzles: puzzles, index: index, resetSignal: $resetSignal, solveSignal: $solveSignal)
                }
            }
            HStack {
                ForEach(4...7, id: \.self) { index in
                    ModularPentaminoView(puzzles: puzzles, index: index, resetSignal: $resetSignal, solveSignal: $solveSignal)
                }
            }
            HStack {
                ForEach(8...11, id: \.self) { index in
                    ModularPentaminoView(puzzles: puzzles, index: index, resetSignal: $resetSignal, solveSignal: $solveSignal)
                }
            }
        }
    }
}

func getColors(index: Int) -> Color {
    switch index {
    case 0:
        return Color.red
    case 1:
        return Color.blue
    case 2:
        return Color.pink
    case 3:
        return Color.cyan
    case 4:
        return Color.yellow
    case 5:
        return Color.indigo
    case 6:
        return Color.purple
    case 7:
        return Color.orange
    case 8:
        return Color.green
    case 9:
        return Color.teal
    case 10:
        return Color.brown
    case 11:
        return Color.blue
    default:
        return Color.mint
    }
}

#Preview {
    @Previewable @State var resetSignal : Bool = false
    @Previewable @State var solve : Bool = false
    let puzzles = PuzzlePieces()
    PentaminoView(resetSignal: $resetSignal, solveSignal: $solve, puzzles: puzzles)
}
