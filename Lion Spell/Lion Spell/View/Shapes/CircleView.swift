//
//  CircleView.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/1/24.
//

import SwiftUI

struct CircleView: View {
    var letters : LetterManager
    var wordManager : WordManager
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { number in
                LetterCircle(wordManager: wordManager, singleLetter: letters.letterGetter(number: number), letterManager: letters)
            }
        }
        .padding()
    }
}

#Preview {
    let letters = LetterManager()
    let wordManager = WordManager()
    return CircleView(letters: letters, wordManager: wordManager)
}
