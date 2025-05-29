//
//  Preferences.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/14/24.
//

import SwiftUI

struct Preferences: View {
    var letterManager : LetterManager
    var wordManager : WordManager
    @Binding var numLetters : NumberOfLetters
    @Binding var language : LanguagePreference
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Number of Letters") {
                    Picker("Choose Letter Amount", selection: $numLetters) {
                        ForEach(NumberOfLetters.allCases) { value in
                            Text("\(value.rawValue) Letters")
                                .tag(value)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: numLetters) {
                        wordManager.deleteWords(letterManager: letterManager)
                        wordManager.resetScore()
                        letterManager.changeLetters(wordManager: wordManager)
                    }
                }
                Section("Language") {
                    Picker("Choose Language", selection: $language) {
                        ForEach(LanguagePreference.allCases) { value in
                            Text("\(value.rawValue)")
                                .tag(value)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: language) {
                        wordManager.deleteWords(letterManager: letterManager)
                        wordManager.resetScore()
                        letterManager.changeLetters(wordManager: wordManager)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing)  {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var letters : NumberOfLetters = .five
    @Previewable @State var language : LanguagePreference = .english
    let wordMan = WordManager()
    let letterMan = LetterManager()
    return Preferences(letterManager: letterMan, wordManager: wordMan, numLetters: $letters, language: $language)
}
