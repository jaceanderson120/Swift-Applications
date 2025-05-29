//
//  LetterCircle.swift
//  Lion Spell
//
//  Created by Jace Anderson on 8/31/24.
//

import SwiftUI

struct LetterCircle: View {
    var wordManager : WordManager
    var singleLetter : String
    var letterManager: LetterManager
    
    var body: some View {
        Button(action: {
            wordManager.addCharacter(char: singleLetter, letterManager: letterManager)
        }, label: {
            Circle()
              .foregroundColor(Color.red)
              .overlay(Text(singleLetter)
                  .font(.largeTitle)
                  .foregroundColor(Color.white))
        })
        .scaledToFit()
    }
}

#Preview {
    let letterManager = LetterManager()
    let wordMan = WordManager()
    return LetterCircle(wordManager: wordMan, singleLetter: "H", letterManager: letterManager)
}
