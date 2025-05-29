//
//  WordManager.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/1/24.
//

import Foundation

@Observable
class WordManager {
    var wordList : [String]
    var currentString : String
    var score : Int
    var word : Bool
    
    init(wordList: [String] = [], currentString: String = "", score: Int = 0) {
        self.wordList = wordList
        self.currentString = currentString
        self.score = score
        self.word = false
    }
    
    func addWord(letterManager : LetterManager) {
        if Words.words.contains(currentString) && !(wordList.contains(currentString)){
            wordList.append(currentString)
            let count = currentString.count
            scoreWord(counter: count, letterManager: letterManager)
        }
    }
    
    func deleteWords(letterManager: LetterManager) {
        wordList.removeAll()
        currentString = ""
        isWord(letterManager: letterManager)
        resetScore()
    }
    
    func addCharacter(char : String, letterManager : LetterManager) {
        currentString += char
        self.isWord(letterManager: letterManager)
    }
    
    func backSpace(letterManager : LetterManager) {
        if currentString.count != 0 {
            currentString.removeLast()
            self.isWord(letterManager: letterManager)
        }
    }
    
    func scoreWord(counter: Int, letterManager : LetterManager) {
        if letterManager.isPanagram(word: currentString) {
            score += 10
        } else {
            score += (currentString.count - 3)
        }
        currentString = ""
        self.isWord(letterManager: letterManager)
    }
    
    func resetScore() {
        score = 0
    }
    
    func isWord(letterManager : LetterManager) {
        if Words.words.contains(currentString) && !(wordList.contains(currentString)) && currentString.contains(letterManager.letterGetter(number: 2)){
            word = true
        }
        else {
            word = false
        }
    }
}
