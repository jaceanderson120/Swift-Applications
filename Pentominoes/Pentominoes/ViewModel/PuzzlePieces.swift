//
//  PuzzlePieces.swift
//  Pentominoes
//
//  Created by Jace Anderson on 9/21/24.
//

import Foundation

@Observable
class PuzzlePieces {
    var pentominoPieces : [Piece] = []
    var puzzles : [PuzzleOutline] = []
    var solutions: [String: [String: Position]] = [:]
    
    let puzzleManager : StorePuzzles = StorePuzzles<[PuzzleOutline]>()
    let pentominoManager : StorePentominos = StorePentominos<[PentominoOutline]>()
    let solutionManager : StoreSolutions = StoreSolutions<[String: [String: Position]]>()
    
    var currentPuzzle : PuzzleOutline?
    var rows : Int = 0
    var columns : Int = 0
    
    init() {
        if let modelData = pentominoManager.modelData {
                modelData.forEach { pentomino in
                let piece = Piece(position: Position(), outline: pentomino)
                self.pentominoPieces.append(piece)
            }
        } else {
            self.pentominoPieces = []
        }
        self.puzzles = puzzleManager.modelData ?? []
        if !puzzles.isEmpty {
            self.currentPuzzle = puzzles[0]
            if let currentPuzzle = self.currentPuzzle {
                self.rows = currentPuzzle.size.height
                self.columns = currentPuzzle.size.width
            }
        } else {
            self.currentPuzzle = nil
            self.rows = 0
            self.columns = 0
        }
        
        if let solutionData = solutionManager.modelData {
            self.solutions = solutionData
        } else {
            self.solutions = [:]
        }
    }
    
    func savePentominos() {
        let pentoOutlines : [PentominoOutline] = pentominoPieces.map { pentoOutline in
            return pentoOutline.outline
        }
        pentominoManager.save(components: pentoOutlines)
    }
    
    func savePuzzles() {
        puzzleManager.save(components: puzzles)
    }
    
    func updatePuzzle(puzzle : PuzzleOutline) {
        currentPuzzle = puzzle
    }
    
    
    func updateGrid(puzzle : PuzzleOutline) {
        rows = currentPuzzle!.size.height
        columns = currentPuzzle!.size.width
    }
    
    func solution() -> String {
        return currentPuzzle!.name
    }
    
    func getName(index : Int) -> String {
        switch index {
        case 0:
            return "X"
        case 1:
            return "P"
        case 2:
            return "F"
        case 3:
            return "W"
        case 4:
            return "Z"
        case 5:
            return "U"
        case 6:
            return "V"
        case 7:
            return "T"
        case 8:
            return "L"
        case 9:
            return "Y"
        case 10:
            return "N"
        case 11:
            return "I"
        default:
            return ""
        }
    }
    
    func getSolution(name: String) -> Position? {
        if let currentPuzzleName = currentPuzzle?.name,
           let currentSol = solutions[currentPuzzleName] {
            if let position = currentSol[name] {
                return position
            }
        }
        
        return nil
    }
}
