//
//  ButtonManager.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/6/24.
//

import Foundation

@Observable
class ButtonManager {
    var buttons : [BottomButtons] = []
    
    init(letterManager: LetterManager = LetterManager(), wordManager: WordManager = WordManager()) {
        self.buttons = [
            BottomButtons(id: "shuffle", action: {letterManager.shuffleLetters()}, imageString: "shuffle"),
            BottomButtons(id: "regenGame", action: {
                letterManager.changeLetters(wordManager: wordManager)
                wordManager.deleteWords(letterManager: letterManager)
                wordManager.resetScore()
                wordManager.isWord(letterManager: letterManager)
            }, imageString: "arrow.clockwise"),
            BottomButtons(id: "hints", action: {
                
            }, imageString: "questionmark.circle.fill"),
            BottomButtons(id: "preferences", action: {}, imageString: "slider.horizontal.3")
        ]
    }
}
