//
//  LettersView.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/14/24.
//

import SwiftUI

struct LettersView: View {
    var wordManager : WordManager
    var letterManager : LetterManager
    
    var body: some View {
        switch letterManager.numLetters {
        case .five:
            DiamondHolder(wordManager: wordManager, letterManager: letterManager)
        case .six:
            PentagonHolder(wordManager: wordManager, letterManager: letterManager)
        case .seven:
            HexagonHolder(wordManager: wordManager, letterManager: letterManager)
        }
    }
}

#Preview {
    let wordMan = WordManager()
    let letterMan = LetterManager()
    return LettersView(wordManager: wordMan, letterManager: letterMan)
}
