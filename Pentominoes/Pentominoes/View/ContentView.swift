//
//  ContentView.swift
//  Pentominoes
//
//  Created by Jace Anderson on 9/21/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(PuzzlePieces.self) var puzzleManager
    @State var resetSignal : Bool = false
    @State var solveSignal : Bool = false
    
    var body: some View {
        VStack {
            GameBoard(puzzles: puzzleManager, resetSignal: $resetSignal, solveSignal: $solveSignal)
            ResetSolve(resetSignal: $resetSignal, solveSignal: $solveSignal)
        }
    }
}

#Preview {
    ContentView()
        .environment(PuzzlePieces())
}
