//
//  SubmitDelete.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/1/24.
//

import SwiftUI

struct SubmitDelete: View {
    var wordManager : WordManager
    var letterManager : LetterManager
    
    var body: some View {
        HStack {
            Button(action: {
                wordManager.backSpace(letterManager: letterManager)
            }) {
                Image(systemName: "delete.left")
            }
            .disabled(wordManager.currentString.count < 1)
            .foregroundColor(wordManager.currentString.count < 1 ? .gray : .red)
            .font(.title)
            Spacer()
            Button(action: {
                wordManager.addWord(letterManager: letterManager)
            }) {
                Image(systemName: "square.and.arrow.up")
            }
            .disabled(wordManager.word ? false : true)
            .foregroundColor(wordManager.word ? .green : .gray)
            .font(.title)
        }
        .padding()
    }
}

#Preview {
    let wordMan = WordManager()
    let letterMan = LetterManager()
    return SubmitDelete(wordManager: wordMan, letterManager: letterMan)
}
