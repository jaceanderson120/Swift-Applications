//
//  LetterManager.swift
//  Lion Spell
//
//  Created by Jace Anderson on 8/31/24.
//

import Foundation

@Observable
class LetterManager {
    private var letterHolder : Letters
    
    var language : LanguagePreference = .english
    var numLetters : NumberOfLetters = .five
    
    var usableWords : UsableWords
    var hintData : HintData
    
    
    init(firstLetter: String = "s", secondLetter: String = "n", thirdLetter: String = "a", fourthLetter: String = "k", fifthLetter: String = "e", sixthLetter: String = "p", seventhLetter: String = "d") {
        self.letterHolder
        = Letters(firstLetter: firstLetter, secondLetter: secondLetter, thirdLetter: thirdLetter, fourthLetter: fourthLetter, fifthLetter: fifthLetter, sixthLetter: "", seventhLetter: "")
        self.usableWords = UsableWords(fiveLtrEng: [], sixLtrEng: [], sevenLtrEng: [], fiveLtrFrch: [], sixLtrFrch: [], sevenLtrFrch: [])
        self.hintData = HintData(totalWordPerLet: [:], totalWords: 0, panagrams: 0, totalPoints: 0, maxLenWord: 4)
        
        let wordsList = getWordsToCheckAgainst()
        
        self.usableWords = UsableWords(fiveLtrEng: wordsList[0], sixLtrEng: wordsList[1], sevenLtrEng: wordsList[2], fiveLtrFrch: wordsList[3], sixLtrFrch: wordsList[4], sevenLtrFrch: wordsList[5])
        
        getHints()
    }
    
    func changeLetters(wordManager : WordManager) {
        
        switch language {
        case .english:
            switch numLetters {
            case .five:
                englishWords(engWords: usableWords.fiveLtrEng)
            case .six:
                englishWords(engWords: usableWords.sixLtrEng)
            case .seven:
                englishWords(engWords: usableWords.sevenLtrEng)
            }
        case .french:
            switch numLetters {
            case .five:
                frenchWords(frchWords: usableWords.fiveLtrFrch)
            case .six:
                frenchWords(frchWords: usableWords.sixLtrFrch)
            case .seven:
                frenchWords(frchWords: usableWords.sevenLtrFrch)
            }
        }
        
        getHints()
    }
    
    func shuffleLetters() {
        switch numLetters {
        case .five:
            let letters = "\(letterHolder.firstLetter)\(letterHolder.thirdLetter)\(letterHolder.fourthLetter)\(letterHolder.fifthLetter)"
            let shuffledLetters = Array(letters).shuffled()
            letterHolder.firstLetter = String(shuffledLetters[0])
            letterHolder.thirdLetter = String(shuffledLetters[1])
            letterHolder.fourthLetter = String(shuffledLetters[2])
            letterHolder.fifthLetter = String(shuffledLetters[3])
        case .six:
            let letters = "\(letterHolder.firstLetter)\(letterHolder.thirdLetter)\(letterHolder.fourthLetter)\(letterHolder.fifthLetter)\(letterHolder.sixthLetter)"
            let shuffledLetters = Array(letters).shuffled()
            letterHolder.firstLetter = String(shuffledLetters[0])
            letterHolder.thirdLetter = String(shuffledLetters[1])
            letterHolder.fourthLetter = String(shuffledLetters[2])
            letterHolder.fifthLetter = String(shuffledLetters[3])
            letterHolder.sixthLetter = String(shuffledLetters[4])
        case .seven:
            let letters = "\(letterHolder.firstLetter)\(letterHolder.thirdLetter)\(letterHolder.fourthLetter)\(letterHolder.fifthLetter)\(letterHolder.sixthLetter)\(letterHolder.seventhLetter)"
            let shuffledLetters = Array(letters).shuffled()
            letterHolder.firstLetter = String(shuffledLetters[0])
            letterHolder.thirdLetter = String(shuffledLetters[1])
            letterHolder.fourthLetter = String(shuffledLetters[2])
            letterHolder.fifthLetter = String(shuffledLetters[3])
            letterHolder.sixthLetter = String(shuffledLetters[4])
            letterHolder.seventhLetter = String(shuffledLetters[5])
        }
    }
    
    func letterGetter(number: Int) -> String {
        switch number {
        case 1:
            return letterHolder.firstLetter
        case 2:
            return letterHolder.secondLetter
        case 3:
            return letterHolder.thirdLetter
        case 4:
            return letterHolder.fourthLetter
        case 5:
            return letterHolder.fifthLetter
        case 6:
            return letterHolder.sixthLetter
        case 7:
            return letterHolder.seventhLetter
        default:
            return ""
        }
    }
    
    func getWordsToCheckAgainst() -> [[String]] {
        var fiveLtrEng : [String] = []
        var sixLtrEng : [String] = []
        var sevenLtrEng : [String] = []
        var fiveLtrFrch : [String] = []
        var sixLtrFrch : [String] = []
        var sevenLtrFrch : [String] = []
        for i in Words.words {
            if i.count == 5 && Set(i).count == 5 {
                fiveLtrEng.append(i)
            }
            else if i.count == 6 && Set(i).count == 6 {
                sixLtrEng.append(i)
            }
            else if i.count == 7 && Set(i).count == 7 {
                sevenLtrEng.append(i)
            }
        }
        for i in FrenchWords.frenchWords {
            if i.count == 5 && Set(i).count == 5 {
                fiveLtrFrch.append(i)
            }
            else if i.count == 6 && Set(i).count == 6 {
                sixLtrFrch.append(i)
            }
            else if i.count == 7 && Set(i).count == 7 {
                sevenLtrFrch.append(i)
            }
        }
        return [fiveLtrEng, sixLtrEng, sevenLtrEng, fiveLtrFrch, sixLtrFrch, sevenLtrFrch]
    }
    
    func englishWords(engWords : [String]) {
        
        let randomInd = Int.random(in: 0..<engWords.count)
        let randomElm = Array(engWords[randomInd])
        
        switch numLetters {
        case .five:
            letterHolder.firstLetter = String(randomElm[0])
            letterHolder.secondLetter = String(randomElm[1])
            letterHolder.thirdLetter = String(randomElm[2])
            letterHolder.fourthLetter = String(randomElm[3])
            letterHolder.fifthLetter = String(randomElm[4])
            letterHolder.sixthLetter = ""
            letterHolder.seventhLetter = ""
        case .six:
            letterHolder.firstLetter = String(randomElm[0])
            letterHolder.secondLetter = String(randomElm[1])
            letterHolder.thirdLetter = String(randomElm[2])
            letterHolder.fourthLetter = String(randomElm[3])
            letterHolder.fifthLetter = String(randomElm[4])
            letterHolder.sixthLetter = String(randomElm[5])
            letterHolder.seventhLetter = ""
        case .seven:
            letterHolder.firstLetter = String(randomElm[0])
            letterHolder.secondLetter = String(randomElm[1])
            letterHolder.thirdLetter = String(randomElm[2])
            letterHolder.fourthLetter = String(randomElm[3])
            letterHolder.fifthLetter = String(randomElm[4])
            letterHolder.sixthLetter = String(randomElm[5])
            letterHolder.seventhLetter = String(randomElm[6])
        }
    }
    
    func frenchWords(frchWords : [String]) {
        let randomInd = Int.random(in: 0..<frchWords.count)
        let randomElm = Array(frchWords[randomInd])
        
        switch numLetters {
        case .five:
            letterHolder.firstLetter = String(randomElm[0])
            letterHolder.secondLetter = String(randomElm[1])
            letterHolder.thirdLetter = String(randomElm[2])
            letterHolder.fourthLetter = String(randomElm[3])
            letterHolder.fifthLetter = String(randomElm[4])
            letterHolder.sixthLetter = ""
            letterHolder.seventhLetter = ""
        case .six:
            letterHolder.firstLetter = String(randomElm[0])
            letterHolder.secondLetter = String(randomElm[1])
            letterHolder.thirdLetter = String(randomElm[2])
            letterHolder.fourthLetter = String(randomElm[3])
            letterHolder.fifthLetter = String(randomElm[4])
            letterHolder.sixthLetter = String(randomElm[5])
            letterHolder.seventhLetter = ""
        case .seven:
            letterHolder.firstLetter = String(randomElm[0])
            letterHolder.secondLetter = String(randomElm[1])
            letterHolder.thirdLetter = String(randomElm[2])
            letterHolder.fourthLetter = String(randomElm[3])
            letterHolder.fifthLetter = String(randomElm[4])
            letterHolder.sixthLetter = String(randomElm[5])
            letterHolder.seventhLetter = String(randomElm[6])
        }
    }
    
    func getHints() {
        switch language {
        case .english:
            englishHints()
        case .french:
            frenchHints()
        }
    }
    
    func englishHints() {
        var counter : [Character: [Int : Int]] = [:]
        var panagrams = 0
        var maxLenWord = 4
        var totalPoints = 0
        var totalWords = 0
        
        
        let letterSet = Set("\(letterHolder.firstLetter)\(letterHolder.secondLetter)\(letterHolder.thirdLetter)\(letterHolder.fourthLetter)\(letterHolder.fifthLetter)\(letterHolder.sixthLetter)\(letterHolder.seventhLetter)")
        
        for i in Words.words {
            let wordSet = Set(i)
            if wordSet.isSubset(of: letterSet) && wordSet != letterSet && wordSet.contains(letterHolder.secondLetter) {
                totalWords += 1
                totalPoints += (i.count - 3)
                if i.count > maxLenWord {
                    maxLenWord = i.count
                }
                
                let firstLet = i.first!
                if counter[firstLet] != nil {
                    counter[firstLet]![i.count, default: 0] += 1
                }
                else {
                    counter[firstLet] = [i.count : 1]
                }
            }
            else if wordSet.isSubset(of: letterSet) && wordSet == letterSet {
                totalWords += 1
                totalPoints += 10
                panagrams += 1
            }
        }
        
        hintData.totalWords = totalWords
        hintData.maxLenWord = maxLenWord
        hintData.totalPoints = totalPoints
        hintData.panagrams = panagrams
        hintData.totalWordPerLet = counter
    }
    
    func frenchHints() {
        var counter : [Character: [Int: Int]] = [:]
        var panagrams = 0
        var totalPoints = 0
        var totalWords = 0
        var maxLenWord = 4
        
        let letterSet = Set("\(letterHolder.firstLetter)\(letterHolder.secondLetter)\(letterHolder.thirdLetter)\(letterHolder.fourthLetter)\(letterHolder.fifthLetter)\(letterHolder.sixthLetter)\(letterHolder.seventhLetter)")
        
        for i in FrenchWords.frenchWords {
            let wordSet = Set(i)
            if wordSet.isSubset(of: letterSet) && wordSet != letterSet && wordSet.contains(letterHolder.secondLetter) {
                totalWords += 1
                totalPoints += (i.count - 3)
                if i.count > maxLenWord {
                    maxLenWord = i.count
                }
                
                let firstLet = i.first!
                if counter[firstLet] != nil {
                    counter[firstLet]![i.count, default: 0] += 1
                }
                else {
                    counter[firstLet] = [i.count : 1]
                }
            }
            else if wordSet.isSubset(of: letterSet) && wordSet == letterSet {
                totalWords += 1
                totalPoints += 10
                panagrams += 1
            }
        }
        
        hintData.maxLenWord = maxLenWord
        hintData.totalWords = totalWords
        hintData.totalPoints = totalPoints
        hintData.panagrams = panagrams
        hintData.totalWordPerLet = counter
    }
    
    func isPanagram(word: String) -> Bool {
        let letterSet = Set("\(letterHolder.firstLetter)\(letterHolder.secondLetter)\(letterHolder.thirdLetter)\(letterHolder.fourthLetter)\(letterHolder.fifthLetter)\(letterHolder.sixthLetter)\(letterHolder.seventhLetter)")
        let wordSet = Set(word)
        
        if letterSet == wordSet {
            return true
        }
        return false
    }
}
