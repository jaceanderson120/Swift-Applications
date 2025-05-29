//
//  CurrentWord.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/2/24.
//

import SwiftUI

struct CurrentWord: View {
    var letterManager : LetterManager
    var wordManager : WordManager
    
    var body: some View {
        HStack {
            ForEach(Array(wordManager.currentString), id: \.self) { currLetter in
                Text(String(currLetter))
                    .font(.system(size: 40))
                    .foregroundStyle(letterManager.letterGetter(number: 2) == String(currLetter) ? .yellow : .black)
            }
        }
        .frame(minHeight: 50)
    }
}

#Preview {
    let letterMan = LetterManager()
    let wordMan = WordManager(currentString: "hello")
    return CurrentWord(letterManager: letterMan, wordManager: wordMan)
}
