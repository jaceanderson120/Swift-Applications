//
//  Hints.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/14/24.
//

import SwiftUI

struct Hints: View {
    @Environment(\.dismiss) var dismiss
    
    var letterManager : LetterManager
    var wordManager : WordManager
    
    
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(4..<(letterManager.hintData.maxLenWord + 1), id: \.self) { length in
                    let hasLength = letterManager.hintData.totalWordPerLet.values.contains { dict in
                        dict[length] != nil
                    }
                    if hasLength {
                        Section(header: Text("\(length) Letters")) {
                            ForEach(letterManager.hintData.totalWordPerLet.keys.sorted(), id: \.self) { letter in
                                if let count = letterManager.hintData.totalWordPerLet[letter]?[length] {
                                    HStack {
                                        Text("\(letter.uppercased()):")
                                        Spacer()
                                        Text(count > 1 ? "\(count) Words" : "\(count) Word")
                                    }
                                }
                            }
                        }
                    }
                }
                Section(header: Text("Pangrams")) {
                    HStack {
                        Text("Total Pangrams:")
                        Spacer()
                        Text(letterManager.hintData.panagrams > 1 ? "\(letterManager.hintData.panagrams) Pangrams" : "\(letterManager.hintData.panagrams) Pangram")
                    }
                }
                Section(header: Text("Words")) {
                    HStack {
                        Text("Total Words:")
                        Spacer()
                        Text(letterManager.hintData.totalWords > 1 ? "\(letterManager.hintData.totalWords) Words" : "\(letterManager.hintData.totalWords) Word")
                    }
                }
                Section(header: Text("Points")) {
                    HStack {
                        Text("Total Points:")
                        Spacer()
                        Text(letterManager.hintData.totalPoints > 1 ? "\(letterManager.hintData.totalPoints) Points" : "\(letterManager.hintData.totalPoints) Point")
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
    let wordMan = WordManager()
    let letterMan = LetterManager()
    return Hints(letterManager: letterMan, wordManager: wordMan)
}
