//
//  Lion_SpellApp.swift
//  Lion Spell
//
//  Created by Jace Anderson on 8/31/24.
//

import SwiftUI

@main
struct Lion_SpellApp: App {
    @State var letterManager = LetterManager()
    @State var wordManager = WordManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(letterManager)
                .environment(wordManager)
        }
    }
}
