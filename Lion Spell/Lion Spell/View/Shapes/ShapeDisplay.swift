//
//  ShapeDisplay.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/15/24.
//

import SwiftUI

struct ShapeDisplay: View {
    let letters : LetterManager
    let words : WordManager
    
    var body: some View {
        switch letters.numLetters {
        case .five:
            DiamondHolder(wordManager: words, letterManager: letters)
        case .six:
            PentagonHolder(wordManager: words, letterManager: letters)
        case .seven:
            HexagonHolder(wordManager: words, letterManager: letters)
        }
    }
}

#Preview {
    let letterMan = LetterManager()
    let wordMan = WordManager()
    return ShapeDisplay(letters: letterMan, words: wordMan)
}
