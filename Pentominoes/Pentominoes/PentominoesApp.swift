//
//  PentominoesApp.swift
//  Pentominoes
//
//  Created by Jace Anderson on 9/21/24.
//

import SwiftUI

@main
struct PentominoesApp: App {
    @Environment(\.scenePhase) var scenePhase
    @State var puzzles = PuzzlePieces()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(puzzles)
        }
    }
}
