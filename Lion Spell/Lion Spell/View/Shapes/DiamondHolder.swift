//
//  DiamondHolder.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/14/24.
//

import SwiftUI

struct DiamondHolder: View {
    let wordManager : WordManager
    let letterManager : LetterManager
    
    var body: some View {
        ZStack {
            VStack {
                DiamondMaker(wordManager: wordManager, letterManager: letterManager, xOffset1: -10, xOffset2: 10, yOffset1: -10, yOffset2: -10, width: 100, color: .black, case1: 1, case2: 3)
                DiamondMaker(wordManager: wordManager, letterManager: letterManager, xOffset1: -10, xOffset2: 10, yOffset1: 10, yOffset2: 10, width: 100, color: .black, case1: 4, case2: 5)
            }
            Button(action: {
                wordManager.addCharacter(char: letterManager.letterGetter(number: 2), letterManager: letterManager)
            }) {
                Diamond(letter: letterManager.letterGetter(number: 2))
                    .frame(width: 100, height: 100)
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct DiamondMaker : View {
    var wordManager : WordManager
    var letterManager : LetterManager
    var xOffset1 : CGFloat
    var xOffset2 : CGFloat
    var yOffset1 : CGFloat
    var yOffset2 : CGFloat
    var width : CGFloat
    var color : Color
    var case1 : Int
    var case2 : Int
    
    var body: some View {
        HStack {
            Button(action: {
                wordManager.addCharacter(char: letterManager.letterGetter(number: case1), letterManager: letterManager)
            }) {
                Diamond(letter: letterManager.letterGetter(number: case1))
                    .frame(width: width, height: width)
                    .foregroundColor(color)
                    .offset(x: xOffset1, y: yOffset1)
            }
            Button(action: {
                wordManager.addCharacter(char: letterManager.letterGetter(number: case2), letterManager: letterManager)
            }) {
                Diamond(letter: letterManager.letterGetter(number: case2))
                    .frame(width: width, height: width)
                    .foregroundColor(color)
                    .offset(x: xOffset2, y: yOffset2)
            }
        }
    }
}

#Preview {
    let wordMan = WordManager()
    let letterMan = LetterManager()
    return DiamondHolder(wordManager: wordMan, letterManager: letterMan)
}
