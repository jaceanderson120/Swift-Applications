//
//  WordList.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/1/24.
//

import SwiftUI

struct WordList: View {
    var wordManager : WordManager
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(wordManager.wordList, id: \.self) { word in
                    Text(word)
                        .padding()
                }
            }
            .padding()
            .frame(maxHeight: 40)
        }
        .background(Color.gray)
    }
}

#Preview {
    let wordList = WordManager(wordList: ["Bacon", "Fries", "Meat", "Pasta", "Food", "Cheese"])
    return WordList(wordManager: wordList)
}
