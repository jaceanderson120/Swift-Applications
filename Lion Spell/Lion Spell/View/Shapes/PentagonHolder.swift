//
//  PentagonHolder.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/14/24.
//

import SwiftUI

struct PentagonHolder: View {
    let wordManager : WordManager
    let letterManager : LetterManager
    
    var body: some View {
        ZStack {
            Button(action: {
                wordManager.addCharacter(char: letterManager.letterGetter(number: 2), letterManager: letterManager)
            }) {
                Pentagon(letter: letterManager.letterGetter(number: 2), color: .yellow, rotation: Angle(degrees: 0))
            }
            .frame(width: 100, height: 100)
            Button(action: {
                wordManager.addCharacter(char: letterManager.letterGetter(number: 4), letterManager: letterManager)
            }) {
                Pentagon(letter: letterManager.letterGetter(number: 4), rotation: Angle(degrees: 180))
            }
            .offset(y: 100)
            .frame(width: 100, height: 100)
            Button(action: {
                wordManager.addCharacter(char: letterManager.letterGetter(number: 1), letterManager: letterManager)
            }) {
                Pentagon(letter: letterManager.letterGetter(number: 1), rotation: Angle(degrees: 180))
            }
            .offset(x: 100, y: 35)
            .frame(width: 100, height: 100)
            Button(action: {
                wordManager.addCharacter(char: letterManager.letterGetter(number: 5), letterManager: letterManager)
            }) {
                Pentagon(letter: letterManager.letterGetter(number: 5), rotation: Angle(degrees: 180))
            }
            .offset(x: -100, y: 35)
            .frame(width: 100, height: 100)
            Button(action: {
                wordManager.addCharacter(char: letterManager.letterGetter(number: 3), letterManager: letterManager)
            }) {
                Pentagon(letter: letterManager.letterGetter(number: 3), rotation: Angle(degrees: 180))
            }
            .offset(x: -65, y: -85)
            .frame(width: 100, height: 100)
            Button(action: {
                wordManager.addCharacter(char: letterManager.letterGetter(number: 6), letterManager: letterManager)
            }) {
                Pentagon(letter: letterManager.letterGetter(number: 6), rotation: Angle(degrees: 180))
            }
            .offset(x: 65, y: -85)
            .frame(width: 100, height: 100)
        }
        .padding()
    }
}

#Preview {
    let wordMan = WordManager()
    let letterMan = LetterManager()
    return PentagonHolder(wordManager: wordMan, letterManager: letterMan)
}
