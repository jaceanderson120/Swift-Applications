//
//  ViewStateHolder.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/5/24.
//

import SwiftUI

struct ViewStateHolder: View {
    @Environment(LetterManager.self) var letterManager
    @Environment(WordManager.self) var wordManager
    
    @State var showingPref = false
    @State var showingHints = false
    

    
    var body: some View {
        @Bindable var letters = letterManager
        @Bindable var words = wordManager
        return VStack {
            LionSpellHeader()
            WordList(wordManager: wordManager)
            CurrentWord(letterManager: letterManager, wordManager: wordManager)
            LettersView(wordManager: wordManager, letterManager: letterManager)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            SubmitDelete(wordManager: wordManager, letterManager: letterManager)
            ScoreDisplay(score: wordManager)
            ButtonRow(buttons: ButtonManager(letterManager: letterManager, wordManager: wordManager), showingPref: $showingPref, showingHints: $showingHints)
                .sheet(isPresented: $showingPref, content: {
                    Preferences(letterManager: letterManager, wordManager: wordManager, numLetters: $letters.numLetters, language: $letters.language)
                })
                .sheet(isPresented: $showingHints, content: {
                    Hints(letterManager: letterManager, wordManager: wordManager)
                })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .background(Color.teal)
    }
}

#Preview {
    ViewStateHolder()
        .environment(LetterManager())
        .environment(WordManager())
}
