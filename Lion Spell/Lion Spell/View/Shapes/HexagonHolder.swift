//
//  HexagonHolder.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/14/24.
//

import SwiftUI

struct HexagonHolder: View {
    let wordManager : WordManager
    let letterManager : LetterManager
    
    let colorColOne = [
        Color.black, Color.yellow, Color.black
    ]
    let colorColTwoThree = [
        Color.black, Color.black
    ]
    
    
    
    var body: some View {
        ZStack {
            HexColumn(wordManager: wordManager, letterManager: letterManager, colors: colorColOne, offset: 0, startInd: 1, endInd: 3)
            HexColumn(wordManager: wordManager, letterManager: letterManager, colors: colorColTwoThree, offset: 90, startInd: 4, endInd: 5)
            HexColumn(wordManager: wordManager, letterManager: letterManager, colors: colorColTwoThree, offset: -90, startInd: 6, endInd: 7)
        }
    }
}

struct HexColumn : View {
    var wordManager : WordManager
    var letterManager : LetterManager
    var colors : [Color]
    var offset : CGFloat
    var startInd : Int
    var endInd : Int
    
    var body: some View {
        VStack {
            ForEach(startInd..<endInd + 1, id: \.self) { index in
                Button(action: {
                    wordManager.addCharacter(char: letterManager.letterGetter(number: index), letterManager: letterManager)
                }) {
                    Hexagon(letter: letterManager.letterGetter(number: index))
                        .frame(width: 100, height: 100)
                        .foregroundColor(index == 2 ? .yellow : .black)
                }
            }
        }
        .offset(x: offset)
    }
}

#Preview {
    let wordMan = WordManager()
    let letterMan = LetterManager()
    return HexagonHolder(wordManager: wordMan, letterManager: letterMan)
}
