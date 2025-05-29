//
//  GameManagerBoardTwo.swift
//  GridBattle
//
//  Created by Jace Anderson on 11/17/24.
//

import Foundation
import SwiftUI

@Observable
class GameManagerBoardTwo {
    var player : Players = .player1
    var turnPhase : TurnPhase = .move
    
    var gameType : GameType = .local
    
    var turn : Int = 25
    var turnMagicNumber : Int = 25
    
    var magicNumber : Int = 7
    
    var gameOver : Bool = false
    var blueWon : Bool = false
    var redWon : Bool = false
    
    var playerOneUnits : Int = 0
    var playerTwoUnits : Int = 0
    
    var startPosition : Position? = nil
    
    var pieces : [ Position: GamePiece]
    var board: [ Position: SquareState ] = [:]
    
    var deadPieces : [GamePiece] = []
    
    var blueSquareCount: Int {
        return board.values.filter { $0.color == "blue" }.count
    }
    var redSquareCount: Int {
        return board.values.filter { $0.color == "red" }.count
    }
    
    init() {
        pieces = [:]
        board = [:]
        setupBoard()
    }
    
    func resetPieces() {
        playerOneUnits = 0
        playerTwoUnits = 0
        pieces = [:]
        player = .player1
        turnPhase = .move
    }
    
    func addPlanes(airOne: Int, airTwo: Int) {
        for _ in 0..<airOne {
            if (playerOneUnits == 0) {
                pieces[Position(row: magicNumber, column: magicNumber)] = GamePiece(location: Position(row: magicNumber, column: magicNumber), pieceType: .plane, owner: .player1, state: .alive)
            } else {
                pieces[Position(row: magicNumber, column: magicNumber - 1)] = GamePiece(location: Position(row: magicNumber, column: magicNumber - 1), pieceType: .plane, owner: .player1, state: .alive)
            }
            playerOneUnits += 1
        }
        for _ in 0..<airTwo {
            if (playerTwoUnits == 0) {
                pieces[Position(row: 0, column: 0)] = GamePiece(location: Position(row: 0, column: 0), pieceType: .plane, owner: .player2, state: .alive)
            } else {
                pieces[Position(row: 0, column: 1)] = GamePiece(location: Position(row: 0, column: 1), pieceType: .plane, owner: .player2, state: .alive)
            }
            playerTwoUnits += 1
        }
    }
    
    func addTanks(tankOne: Int, tankTwo: Int) {
        for _ in 0..<tankOne {
            if playerOneUnits == 0 {
                pieces[Position(row: magicNumber, column: magicNumber)] = GamePiece(location: Position(row: magicNumber, column: magicNumber), pieceType: .tank, owner: .player1, state: .alive)
            } else {
                pieces[Position(row: magicNumber, column: magicNumber - 1)] = GamePiece(location: Position(row: magicNumber, column: magicNumber - 1), pieceType: .tank, owner: .player1, state: .alive)
            }
            playerOneUnits += 1
        }
        for _ in 0..<tankTwo {
            if (playerTwoUnits == 0) {
                pieces[Position(row: 0, column: 0)] = GamePiece(location: Position(row: 0, column: 0), pieceType: .tank, owner: .player2, state: .alive)
            } else {
                pieces[Position(row: 0, column: 1)] = GamePiece(location: Position(row: 0, column: 1), pieceType: .tank, owner: .player2, state: .alive)
            }
            playerTwoUnits += 1
        }
    }
    
    func addSoldiers(soldierOne: Int, soldierTwo: Int) {
        for _ in 0..<soldierOne {
            if playerOneUnits == 0 {
                pieces[Position(row: magicNumber, column: magicNumber)] = GamePiece(location: Position(row: magicNumber, column: magicNumber), pieceType: .soldier, owner: .player1, state: .alive)
            } else {
                pieces[Position(row: magicNumber, column: magicNumber - 1)] = GamePiece(location: Position(row: magicNumber, column: magicNumber - 1), pieceType: .soldier, owner: .player1, state: .alive)
            }
            playerOneUnits += 1
        }
        for _ in 0..<soldierTwo {
            if (playerTwoUnits == 0) {
                pieces[Position(row: 0, column: 0)] = GamePiece(location: Position(row: 0, column: 0), pieceType: .soldier, owner: .player2, state: .alive)
            } else {
                pieces[Position(row: 0, column: 1)] = GamePiece(location: Position(row: 0, column: 1), pieceType: .soldier, owner: .player2, state: .alive)
            }
            playerTwoUnits += 1
        }
    }
    
    func movePiece(position: Position) {
        var living = true
        var battled = false
        if board[position]?.containsPiece != nil && board[position]?.containsPiece != false {
            battled = true
            let pieceOne : GamePiece = pieces[position]!
            let pieceTwo : GamePiece = pieces[startPosition!]!
            living = pieceBattle(pieceOne: pieceOne, pieceTwo: pieceTwo)
        }
        if living {
            if battled {
                deadPieces.append(pieces[position]!)
            }
            let piece = pieces[startPosition!]
            
            var updatedPiece = piece
            updatedPiece?.location = position
            pieces[startPosition!] = nil
            pieces[position] = updatedPiece
            if player == .player1 {
                board[position]?.color = "blue"
                if position == Position(row: 0, column: 0) {
                    gameOver = true
                    blueWon = true
                }
            } else {
                board[position]?.color = "red"
                if position == Position(row: magicNumber, column: magicNumber) {
                    gameOver = true
                    redWon = true
                }
            }
            board[startPosition!]?.containsPiece = false
            board[position]?.containsPiece = true
            gameOver = !checkWinner()
        } else {
            deadPieces.append(pieces[startPosition!]!)
            pieces[startPosition!] = nil
            board[startPosition!]?.containsPiece = false
            gameOver = !checkWinner()
        }
        resetBoard()
        endTurnPhase()
        
        if gameOver {
            blueWon = didBlueWin()
            redWon = !blueWon
        }
    }
    
    func endTurnPhase() {
        turnPhase = .relocate
    }
    
    func skipPhase() {
        resetBoard()
        if turnPhase == .move {
            turnPhase = .relocate
        } else {
            if player == .player1 {
                turnPhase = .move
                player = .player2
                if gameType == .computer {
                    performComputerMove()
                }
            } else {
                turnPhase = .move
                player = .player1
                turn -= 1
            }
        }
    }
    
    func relocatePiece(position: Position) {
        let piece = pieces[startPosition!]
        var updatedPiece = piece
        updatedPiece?.location = position
        pieces[startPosition!] = nil
        pieces[position] = updatedPiece
        board[startPosition!]?.containsPiece = false
        board[position]?.containsPiece = true
        resetBoard()
        endRelocatePhase()
    }
    
    func removeAllPieces() {
        pieces = [:]
    }
    
    func checkWinner() -> Bool {
        var hasPlayerOne = false
        var hasPlayerTwo = false
        
        
        for piece in pieces.keys {
            if pieces[piece]?.owner == .player1 {
                hasPlayerOne = true
            } else if pieces[piece]?.owner == .player2 {
                hasPlayerTwo = true
            }
        }
        
        if board[Position(row: magicNumber, column: magicNumber)]!.color == "red" {
            return false
        } else if board[Position(row: 0, column: 0)]!.color == "blue" {
            return false
        }
        
        return hasPlayerOne && hasPlayerTwo
    }
    
    func didBlueWin() -> Bool {
        var blueCount = 0
        var redCount = 0
        for square in board.keys {
            if board[square]!.color == "blue" {
                blueCount += 1
            } else if board[square]!.color == "red" {
                redCount += 1
            }
        }
        return blueCount > redCount
    }
    
    func endRelocatePhase() {
        turnPhase = .move
        if player == .player1 {
            player = .player2
            if gameType == .computer {
                performComputerMove()
            }
        } else {
            turn -= 1
            player = .player1
        }
        if turn == 0 {
            gameOver = true
            blueWon = didBlueWin()
            redWon = !blueWon
        }
        resetBoard()
    }
    
    func pieceBattle(pieceOne: GamePiece, pieceTwo: GamePiece) -> Bool {
        var attackerWins : Bool = false
        let randomNum : Double = Double.random(in: 0.0...1.0)
        if pieceOne.pieceType == pieceTwo.pieceType {
            if randomNum > 0.5 {
                attackerWins = true
            }
        } else if pieceOne.pieceType == .soldier && pieceTwo.pieceType == .plane {
            if randomNum < 0.3 {
                attackerWins = true
            }
        } else if pieceOne.pieceType == .plane && pieceTwo.pieceType == .soldier {
            if randomNum > 0.3 {
                attackerWins = true
            }
        } else if pieceOne.pieceType == .soldier && pieceTwo.pieceType == .tank {
            if randomNum > 0.5 {
                attackerWins = true
            }
        } else if pieceOne.pieceType == .tank && pieceTwo.pieceType == .soldier {
            if randomNum > 0.5 {
                attackerWins = true
            }
        } else if pieceOne.pieceType == .tank && pieceTwo.pieceType == .plane {
            if randomNum > 0.7 {
                attackerWins = true
            }
        } else if pieceOne.pieceType == .plane && pieceTwo.pieceType == .tank {
            if randomNum > 0.1 {
                attackerWins = true
            }
        }
        if attackerWins && pieceOne.owner == .player1 {
            playerOneUnits -= 1
        } else if !attackerWins && pieceOne.owner == .player1 {
            playerTwoUnits -= 1
        } else if attackerWins && pieceOne.owner == .player2 {
            playerTwoUnits -= 1
        } else {
            playerOneUnits -= 1
        }
        if playerOneUnits == 0 {
            gameOver = true
            redWon = true
        }
        if playerTwoUnits == 0 {
            gameOver = true
            blueWon = true
        }
        return attackerWins
    }
    
    func setupBoard() {
        board = [:]
        for row in 0..<(magicNumber + 1) {
            for column in 0..<(magicNumber + 1) {
                board[Position(row: row, column: column)] = SquareState(
                    color: "white",
                    containsPiece: false,
                    isHighlighted: false,
                    possibleMove: false
                )
            }
        }
            
        board[Position(row: 0, column: 0)] = SquareState(color: "red", containsPiece: true, isHighlighted: false, possibleMove: false)
        board[Position(row: 0, column: 1)] = SquareState(color: "red", containsPiece: true, isHighlighted: false, possibleMove: false)
        board[Position(row: magicNumber, column: magicNumber)] = SquareState(color: "blue", containsPiece: true, isHighlighted: false, possibleMove: false)
        board[Position(row: magicNumber, column: magicNumber - 1)] = SquareState(color: "blue", containsPiece: true, isHighlighted: false, possibleMove: false)
        
    }
    
    func getAvailableMoves(position: Position) -> [Position] {
        var returnPositions: [Position] = []
        startPosition = position
        
        let rowVal = position.row
        let colVal = position.column
        
            
        let firstRow = position.row == 0
        let lastRow = position.row == magicNumber
        let firstCol = position.column == 0
        let lastCol = position.column == magicNumber
        
        
        if (!firstRow) {
            if (!board[Position(row: rowVal - 1, column: colVal)]!.containsPiece) {
                board[Position(row: rowVal - 1, column: colVal)]!.isHighlighted = true
                board[Position(row: rowVal - 1, column: colVal)]!.possibleMove = true
                returnPositions.append(Position(row: rowVal - 1, column: colVal))
            } else if board[Position(row: rowVal - 1, column: colVal)]!.containsPiece && ((pieces[Position(row: rowVal - 1, column: colVal)]!.owner == .player2 && player == .player1) || (pieces[Position(row: rowVal - 1, column: colVal)]!.owner == .player1 && player == .player2)) {
                board[Position(row: rowVal - 1, column: colVal)]!.isHighlighted = true
                board[Position(row: rowVal - 1, column: colVal)]!.possibleMove = true
                returnPositions.append(Position(row: rowVal - 1, column: colVal))
            }
        }
        if (!firstCol) {
            if (!board[Position(row: rowVal, column: colVal - 1)]!.containsPiece) {
                board[Position(row: rowVal, column: colVal - 1)]!.isHighlighted = true
                board[Position(row: rowVal, column: colVal - 1)]!.possibleMove = true
                returnPositions.append(Position(row: rowVal, column: colVal - 1))
            } else if board[Position(row: rowVal, column: colVal - 1)]!.containsPiece && ((pieces[Position(row: rowVal, column: colVal - 1)]!.owner == .player2 && player == .player1) || (pieces[Position(row: rowVal, column: colVal - 1)]!.owner == .player1 && player == .player2)) {
                board[Position(row: rowVal, column: colVal - 1)]!.isHighlighted = true
                board[Position(row: rowVal, column: colVal - 1)]!.possibleMove = true
                returnPositions.append(Position(row: rowVal, column: colVal - 1))
            }
        }
        if (!lastCol) {
            if (!board[Position(row: rowVal, column: colVal + 1)]!.containsPiece) {
                board[Position(row: rowVal, column: colVal + 1)]!.isHighlighted = true
                board[Position(row: rowVal, column: colVal + 1)]!.possibleMove = true
                returnPositions.append(Position(row: rowVal, column: colVal + 1))
            } else if board[Position(row: rowVal, column: colVal + 1)]!.containsPiece && ((pieces[Position(row: rowVal, column: colVal + 1)]!.owner == .player2 && player == .player1) || (pieces[Position(row: rowVal, column: colVal + 1)]!.owner == .player1 && player == .player2)) {
                board[Position(row: rowVal, column: colVal + 1)]!.isHighlighted = true
                board[Position(row: rowVal, column: colVal + 1)]!.possibleMove = true
                returnPositions.append(Position(row: rowVal, column: colVal + 1))
            }
        }
        if (!lastRow) {
            if (!board[Position(row: rowVal + 1, column: colVal)]!.containsPiece) {
                board[Position(row: rowVal + 1, column: colVal)]!.isHighlighted = true
                board[Position(row: rowVal + 1, column: colVal)]!.possibleMove = true
                returnPositions.append(Position(row: rowVal + 1, column: colVal))
            } else if board[Position(row: rowVal + 1, column: colVal)]!.containsPiece && ((pieces[Position(row: rowVal + 1, column: colVal)]!.owner == .player2 && player == .player1) || (pieces[Position(row: rowVal + 1, column: colVal)]!.owner == .player1 && player == .player2)) {
                board[Position(row: rowVal + 1, column: colVal)]!.isHighlighted = true
                board[Position(row: rowVal + 1, column: colVal)]!.possibleMove = true
                returnPositions.append(Position(row: rowVal + 1, column: colVal))
            }
        }
        if (!firstCol && !firstRow) {
            if (!board[Position(row: rowVal - 1, column: colVal - 1)]!.containsPiece) {
                board[Position(row: rowVal - 1, column: colVal - 1)]!.isHighlighted = true
                board[Position(row: rowVal - 1, column: colVal - 1)]!.possibleMove = true
                returnPositions.append(Position(row: rowVal - 1, column: colVal - 1))
            } else if board[Position(row: rowVal - 1, column: colVal - 1)]!.containsPiece && ((pieces[Position(row: rowVal - 1, column: colVal - 1)]!.owner == .player2 && player == .player1) || (pieces[Position(row: rowVal - 1, column: colVal - 1)]!.owner == .player1 && player == .player2)) {
                board[Position(row: rowVal - 1, column: colVal - 1)]!.isHighlighted = true
                board[Position(row: rowVal - 1, column: colVal - 1)]!.possibleMove = true
                returnPositions.append(Position(row: rowVal - 1, column: colVal - 1))
            }
        }
        if (!firstCol && !lastRow) {
            if (!board[Position(row: rowVal + 1, column: colVal - 1)]!.containsPiece) {
                board[Position(row: rowVal + 1, column: colVal - 1)]!.isHighlighted = true
                board[Position(row: rowVal + 1, column: colVal - 1)]!.possibleMove = true
                returnPositions.append(Position(row: rowVal + 1, column: colVal - 1))
            } else if board[Position(row: rowVal + 1, column: colVal - 1)]!.containsPiece && ((pieces[Position(row: rowVal + 1, column: colVal - 1)]!.owner == .player2 && player == .player1) || (pieces[Position(row: rowVal + 1, column: colVal - 1)]!.owner == .player1 && player == .player2)) {
                board[Position(row: rowVal + 1, column: colVal - 1)]!.isHighlighted = true
                board[Position(row: rowVal + 1, column: colVal - 1)]!.possibleMove = true
                returnPositions.append(Position(row: rowVal + 1, column: colVal - 1))
            }
        }
        if (!lastCol && !firstRow) {
            if (!board[Position(row: rowVal - 1, column: colVal + 1)]!.containsPiece) {
                board[Position(row: rowVal - 1, column: colVal + 1)]!.isHighlighted = true
                board[Position(row: rowVal - 1, column: colVal + 1)]!.possibleMove = true
                returnPositions.append(Position(row: rowVal - 1, column: colVal + 1))
            } else if board[Position(row: rowVal - 1, column: colVal + 1)]!.containsPiece && ((pieces[Position(row: rowVal - 1, column: colVal + 1)]!.owner == .player2 && player == .player1) || (pieces[Position(row: rowVal - 1, column: colVal + 1)]!.owner == .player1 && player == .player2)) {
                board[Position(row: rowVal - 1, column: colVal + 1)]!.isHighlighted = true
                board[Position(row: rowVal - 1, column: colVal + 1)]!.possibleMove = true
                returnPositions.append(Position(row: rowVal - 1, column: colVal + 1))
            }
        }
        if (!lastCol && !lastRow) {
            if (!board[Position(row: rowVal + 1, column: colVal + 1)]!.containsPiece) {
                board[Position(row: rowVal + 1, column: colVal + 1)]!.isHighlighted = true
                board[Position(row: rowVal + 1, column: colVal + 1)]!.possibleMove = true
                returnPositions.append(Position(row: rowVal + 1, column: colVal + 1))
            } else if board[Position(row: rowVal + 1, column: colVal + 1)]!.containsPiece && ((pieces[Position(row: rowVal + 1, column: colVal + 1)]!.owner == .player2 && player == .player1) || (pieces[Position(row: rowVal + 1, column: colVal + 1)]!.owner == .player1 && player == .player2)) {
                board[Position(row: rowVal + 1, column: colVal + 1)]!.isHighlighted = true
                board[Position(row: rowVal + 1, column: colVal + 1)]!.possibleMove = true
                returnPositions.append(Position(row: rowVal + 1, column: colVal + 1))
            }
        }
        
        
        return returnPositions
    }
    
    func getAllRelocateMoves(position : Position) -> [Position] {
        startPosition = position
        var returnPositions : [Position] = []
        if pieces[startPosition!]?.pieceType == .plane {
            for key in board.keys {
                if key != position && board[key]?.color == "blue" && !board[key]!.containsPiece && player == .player1 {
                    board[key]?.isHighlighted = true
                    board[key]?.possibleMove = true
                    returnPositions.append(key)
                } else if key != position && board[key]?.color == "red" && !board[key]!.containsPiece && player == .player2 {
                    board[key]?.isHighlighted = true
                    board[key]?.possibleMove = true
                    returnPositions.append(key)
                }
            }
        } else {
            for key in board.keys {
                if abs(position.column - key.column) <= 1 && abs(position.row - key.row) <= 1 {
                    if key != position && board[key]?.color == "blue" && !board[key]!.containsPiece && player == .player1 {
                        board[key]?.isHighlighted = true
                        board[key]?.possibleMove = true
                        returnPositions.append(key)
                    } else if key != position && board[key]?.color == "red" && !board[key]!.containsPiece && player == .player2 {
                        board[key]?.isHighlighted = true
                        board[key]?.possibleMove = true
                        returnPositions.append(key)
                    }
                }
            }
        }
        return returnPositions
    }
    
    func resetBoard() {
        startPosition = nil
        for square in board.keys {
            board[square]!.isHighlighted = false
            board[square]!.possibleMove = false
        }
    }
    
    func getImage(position: Position) -> Image {
        if pieces[position]?.pieceType == .plane {
            return Image("airplane")
        } else if pieces[position]?.pieceType == .tank {
            return Image("tank")
        } else {
            return Image("soldier")
        }
    }
    
    func addComputerPieces() {
        let randomNum : Double = Double.random(in: 0.0...1.0)
        let randomNum2 : Double = Double.random(in: 0.0...1.0)
        
        if randomNum < 0.33 {
            pieces[Position(row: 0, column: 0)] = GamePiece(location: Position(row: 0, column: 0), pieceType: .soldier, owner: .player2, state: .alive)
        } else if randomNum < 0.66 {
            pieces[Position(row: 0, column: 0)] = GamePiece(location: Position(row: 0, column: 0), pieceType: .plane, owner: .player2, state: .alive)
        } else {
            pieces[Position(row: 0, column: 0)] = GamePiece(location: Position(row: 0, column: 0), pieceType: .tank, owner: .player2, state: .alive)
        }
        
        if randomNum2 < 0.33 {
            pieces[Position(row: 0, column: 1)] = GamePiece(location: Position(row: 0, column: 1), pieceType: .soldier, owner: .player2, state: .alive)
        } else if randomNum2 < 0.66 {
            pieces[Position(row: 0, column: 1)] = GamePiece(location: Position(row: 0, column: 1), pieceType: .plane, owner: .player2, state: .alive)
        } else {
            pieces[Position(row: 0, column: 1)] = GamePiece(location: Position(row: 0, column: 1), pieceType: .tank, owner: .player2, state: .alive)
        }
        playerTwoUnits = 2
    }
    
    func performComputerMove() {
        var computerPieces : [GamePiece] = []
        var move : [Position?] = []
        var relocationMove : [Position?] = []
        
        
        for key in pieces.keys {
            if pieces[key]?.owner == .player2 {
                computerPieces.append(pieces[key]!)
            }
        }
        
        move = getAllComputerMoves(compPieces: computerPieces)
        if move[0]!.row != (magicNumber + 1) {
            moveComputerPiece(initialPosition: move[0]!, finalPosition: move[1]!)
        }
        
        if !gameOver {
            relocationMove = getComputerRelocation(movePerformed: move)
            relocateComputerPiece(initialPosition: relocationMove[0]!, finalPosition: relocationMove[1]!)
        }
        
        
        player = .player1
        turnPhase = .move
    }
    
    func getAllComputerMoves(compPieces: [GamePiece]) -> [Position?] {
        var emptySquares : [Position] = []
        var oppositeColorSquares : [Position] = []
        var attackSquares : [Position] = []
        var initialPosition : Position? = nil
        var endPosition : Position? = nil
        
        var emptySquareCounter = 0
        var emptySquareMap : [Int : Position] = [:]
        var attackSquareCounter = 0
        var attackSquareMap : [Int : Position] = [:]
        var oppositeSquareCounter = 0
        var oppositeSquareMap : [Int : Position] = [:]
        
        for piece in compPieces {
            let position = piece.location
            
            let rowVal = position.row
            let colVal = position.column
            
            let firstRow = rowVal == 0
            let lastRow = rowVal == magicNumber
            let firstCol = colVal == 0
            let lastCol = colVal == magicNumber
            
            if !firstRow {
                if (!board[Position(row: rowVal - 1, column: colVal)]!.containsPiece) {
                    if rowVal - 1 == magicNumber && colVal == magicNumber {
                        initialPosition = Position(row: rowVal, column: colVal)
                        endPosition = Position(row: rowVal - 1, column: colVal)
                        return [initialPosition, endPosition]
                    } else if board[Position(row: rowVal - 1, column: colVal)]!.color == "blue" {
                        oppositeColorSquares.append(Position(row: rowVal - 1, column: colVal))
                        oppositeSquareMap[oppositeSquareCounter] = position
                        oppositeSquareCounter += 1
                    } else if board[Position(row: rowVal - 1, column: colVal)]!.color == "white" {
                        emptySquares.append(Position(row: rowVal - 1, column: colVal))
                        emptySquareMap[emptySquareCounter] = position
                        emptySquareCounter += 1
                    }
                } else if board[Position(row: rowVal - 1, column: colVal)]!.containsPiece && ((pieces[Position(row: rowVal - 1, column: colVal)]!.owner == .player2 && player == .player1) || (pieces[Position(row: rowVal - 1, column: colVal)]!.owner == .player1 && player == .player2)) {
                    attackSquares.append(Position(row: rowVal - 1, column: colVal))
                    attackSquareMap[attackSquareCounter] = position
                    attackSquareCounter += 1
                }
            }
            if !lastRow {
                if (!board[Position(row: rowVal + 1, column: colVal)]!.containsPiece) {
                    if rowVal + 1 == magicNumber && colVal == magicNumber {
                        initialPosition = Position(row: rowVal, column: colVal)
                        endPosition = Position(row: rowVal + 1, column: colVal)
                        return [initialPosition, endPosition]
                    } else if board[Position(row: rowVal + 1, column: colVal)]!.color == "blue" {
                        oppositeColorSquares.append(Position(row: rowVal + 1, column: colVal))
                        oppositeSquareMap[oppositeSquareCounter] = position
                        oppositeSquareCounter += 1
                    } else if board[Position(row: rowVal + 1, column: colVal)]!.color == "white" {
                        emptySquares.append(Position(row: rowVal + 1, column: colVal))
                        emptySquareMap[emptySquareCounter] = position
                        emptySquareCounter += 1
                    }
                } else if board[Position(row: rowVal + 1, column: colVal)]!.containsPiece && ((pieces[Position(row: rowVal + 1, column: colVal)]!.owner == .player2 && player == .player1) || (pieces[Position(row: rowVal + 1, column: colVal)]!.owner == .player1 && player == .player2)) {
                    attackSquares.append(Position(row: rowVal + 1, column: colVal))
                    attackSquareMap[attackSquareCounter] = position
                    attackSquareCounter += 1
                }
            }
            if !firstCol {
                if (!board[Position(row: rowVal, column: colVal - 1)]!.containsPiece) {
                    if rowVal == magicNumber && colVal - 1 == magicNumber {
                        initialPosition = Position(row: rowVal, column: colVal)
                        endPosition = Position(row: rowVal, column: colVal - 1)
                        return [initialPosition, endPosition]
                    } else if board[Position(row: rowVal, column: colVal - 1)]!.color == "blue" {
                        oppositeColorSquares.append(Position(row: rowVal, column: colVal - 1))
                        oppositeSquareMap[oppositeSquareCounter] = position
                        oppositeSquareCounter += 1
                    } else if board[Position(row: rowVal, column: colVal - 1)]!.color == "white" {
                        emptySquares.append(Position(row: rowVal, column: colVal - 1))
                        emptySquareMap[emptySquareCounter] = position
                        emptySquareCounter += 1
                    }
                } else if board[Position(row: rowVal, column: colVal - 1)]!.containsPiece && ((pieces[Position(row: rowVal, column: colVal - 1)]!.owner == .player2 && player == .player1) || (pieces[Position(row: rowVal, column: colVal - 1)]!.owner == .player1 && player == .player2)) {
                    attackSquares.append(Position(row: rowVal, column: colVal - 1))
                    attackSquareMap[attackSquareCounter] = position
                    attackSquareCounter += 1
                }
            }
            if !lastCol {
                if (!board[Position(row: rowVal, column: colVal + 1)]!.containsPiece) {
                    if rowVal == magicNumber && colVal + 1 == magicNumber {
                        initialPosition = Position(row: rowVal, column: colVal)
                        endPosition = Position(row: rowVal, column: colVal + 1)
                        return [initialPosition, endPosition]
                    } else if board[Position(row: rowVal, column: colVal + 1)]!.color == "blue" {
                        oppositeColorSquares.append(Position(row: rowVal, column: colVal + 1))
                        oppositeSquareMap[oppositeSquareCounter] = position
                        oppositeSquareCounter += 1
                    } else if board[Position(row: rowVal, column: colVal + 1)]!.color == "white" {
                        emptySquares.append(Position(row: rowVal, column: colVal + 1))
                        emptySquareMap[emptySquareCounter] = position
                        emptySquareCounter += 1
                    }
                } else if board[Position(row: rowVal, column: colVal + 1)]!.containsPiece && ((pieces[Position(row: rowVal, column: colVal + 1)]!.owner == .player2 && player == .player1) || (pieces[Position(row: rowVal, column: colVal + 1)]!.owner == .player1 && player == .player2)) {
                    attackSquares.append(Position(row: rowVal, column: colVal + 1))
                    attackSquareMap[attackSquareCounter] = position
                    attackSquareCounter += 1
                }
            }
            if !firstRow && !firstCol {
                if (!board[Position(row: rowVal - 1, column: colVal - 1)]!.containsPiece) {
                    if rowVal - 1 == magicNumber && colVal - 1 == magicNumber {
                        initialPosition = Position(row: rowVal, column: colVal)
                        endPosition = Position(row: rowVal - 1, column: colVal - 1)
                        return [initialPosition, endPosition]
                    } else if board[Position(row: rowVal - 1, column: colVal - 1)]!.color == "blue" {
                        oppositeColorSquares.append(Position(row: rowVal - 1, column: colVal - 1))
                        oppositeSquareMap[oppositeSquareCounter] = position
                        oppositeSquareCounter += 1
                    } else if board[Position(row: rowVal - 1, column: colVal - 1)]!.color == "white" {
                        emptySquares.append(Position(row: rowVal - 1, column: colVal - 1))
                        emptySquareMap[emptySquareCounter] = position
                        emptySquareCounter += 1
                    }
                } else if board[Position(row: rowVal - 1, column: colVal - 1)]!.containsPiece && ((pieces[Position(row: rowVal - 1, column: colVal - 1)]!.owner == .player2 && player == .player1) || (pieces[Position(row: rowVal - 1, column: colVal - 1)]!.owner == .player1 && player == .player2)) {
                    attackSquares.append(Position(row: rowVal - 1, column: colVal - 1))
                    attackSquareMap[attackSquareCounter] = position
                    attackSquareCounter += 1
                }
            }
            if !firstRow && !lastCol {
                if (!board[Position(row: rowVal - 1, column: colVal + 1)]!.containsPiece) {
                    if rowVal - 1 == magicNumber && colVal + 1 == magicNumber {
                        initialPosition = Position(row: rowVal, column: colVal)
                        endPosition = Position(row: rowVal - 1, column: colVal + 1)
                        return [initialPosition, endPosition]
                    } else if board[Position(row: rowVal - 1, column: colVal + 1)]!.color == "blue" {
                        oppositeColorSquares.append(Position(row: rowVal - 1, column: colVal + 1))
                        oppositeSquareMap[oppositeSquareCounter] = position
                        oppositeSquareCounter += 1
                    } else if board[Position(row: rowVal - 1, column: colVal + 1)]!.color == "white" {
                        emptySquares.append(Position(row: rowVal - 1, column: colVal + 1))
                        emptySquareMap[emptySquareCounter] = position
                        emptySquareCounter += 1
                    }
                } else if board[Position(row: rowVal - 1, column: colVal + 1)]!.containsPiece && ((pieces[Position(row: rowVal - 1, column: colVal + 1)]!.owner == .player2 && player == .player1) || (pieces[Position(row: rowVal - 1, column: colVal + 1)]!.owner == .player1 && player == .player2)) {
                    attackSquares.append(Position(row: rowVal - 1, column: colVal + 1))
                    attackSquareMap[attackSquareCounter] = position
                    attackSquareCounter += 1
                }
            }
            if !lastRow && !lastCol {
                if (!board[Position(row: rowVal + 1, column: colVal + 1)]!.containsPiece) {
                    if rowVal + 1 == magicNumber && colVal + 1 == magicNumber {
                        initialPosition = Position(row: rowVal, column: colVal)
                        endPosition = Position(row: rowVal + 1, column: colVal + 1)
                        return [initialPosition, endPosition]
                    } else if board[Position(row: rowVal + 1, column: colVal + 1)]!.color == "blue" {
                        oppositeColorSquares.append(Position(row: rowVal + 1, column: colVal + 1))
                        oppositeSquareMap[oppositeSquareCounter] = position
                        oppositeSquareCounter += 1
                    } else if board[Position(row: rowVal + 1, column: colVal + 1)]!.color == "white" {
                        emptySquares.append(Position(row: rowVal + 1, column: colVal + 1))
                        emptySquareMap[emptySquareCounter] = position
                        emptySquareCounter += 1
                    }
                } else if board[Position(row: rowVal + 1, column: colVal + 1)]!.containsPiece && ((pieces[Position(row: rowVal + 1, column: colVal + 1)]!.owner == .player2 && player == .player1) || (pieces[Position(row: rowVal + 1, column: colVal + 1)]!.owner == .player1 && player == .player2)) {
                    attackSquares.append(Position(row: rowVal + 1, column: colVal + 1))
                    attackSquareMap[attackSquareCounter] = position
                    attackSquareCounter += 1
                }
            }
            if !lastRow && !firstCol {
                if (!board[Position(row: rowVal + 1, column: colVal - 1)]!.containsPiece) {
                    if rowVal + 1 == magicNumber && colVal - 1 == magicNumber {
                        initialPosition = Position(row: rowVal, column: colVal)
                        endPosition = Position(row: rowVal + 1, column: colVal - 1)
                        return [initialPosition, endPosition]
                    } else if board[Position(row: rowVal + 1, column: colVal - 1)]!.color == "blue" {
                        oppositeColorSquares.append(Position(row: rowVal + 1, column: colVal - 1))
                        oppositeSquareMap[oppositeSquareCounter] = position
                        oppositeSquareCounter += 1
                    } else if board[Position(row: rowVal + 1, column: colVal - 1)]!.color == "white" {
                        emptySquares.append(Position(row: rowVal + 1, column: colVal - 1))
                        emptySquareMap[emptySquareCounter] = position
                        emptySquareCounter += 1
                    }
                } else if board[Position(row: rowVal + 1, column: colVal - 1)]!.containsPiece && ((pieces[Position(row: rowVal + 1, column: colVal - 1)]!.owner == .player2 && player == .player1) || (pieces[Position(row: rowVal + 1, column: colVal - 1)]!.owner == .player1 && player == .player2)) {
                    attackSquares.append(Position(row: rowVal + 1, column: colVal - 1))
                    attackSquareMap[attackSquareCounter] = position
                    attackSquareCounter += 1
                }
            }
        }
        
        
        if attackSquares.count > 0 {
            var goodAttacks : [[Position]] = []
            
            for index in 0..<attackSquares.count {
                let goodAttack = checkIfGoodAttack(initialPosition: attackSquareMap[index]!, finalPosition: attackSquares[index])
                if goodAttack {
                    goodAttacks.append([attackSquareMap[index]!, attackSquares[index]])
                }
            }
            
            if goodAttacks.count > 0 {
                let index = Int.random(in: 0..<goodAttacks.count)
                return goodAttacks[index]
            }
        }
        
        if oppositeColorSquares.count > 0 {
            let index = Int.random(in: 0..<oppositeColorSquares.count)
            return [oppositeSquareMap[index], oppositeColorSquares[index]]
        } else if emptySquares.count > 0 {
            let index = Int.random(in: 0..<emptySquares.count)
            return [emptySquareMap[index], emptySquares[index]]
        } else {
            return [Position(row: magicNumber + 1, column: magicNumber + 1), Position(row: magicNumber + 1, column: magicNumber + 1)]
        }
    }
    
    func checkIfGoodAttack(initialPosition: Position, finalPosition: Position) -> Bool {
        let pieceOne = pieces[initialPosition]
        let pieceTwo = pieces[finalPosition]
        if (pieceOne?.pieceType == .tank || pieceOne?.pieceType == .soldier) && pieceTwo?.pieceType == .plane {
            return true
        } else if pieceOne?.pieceType == pieceTwo?.pieceType {
            return true
        }
        return false
    }
    
    func moveComputerPiece(initialPosition : Position, finalPosition: Position) {
        var living = true
        var battled = false
        if board[finalPosition]?.containsPiece != nil && board[finalPosition]?.containsPiece != false {
            battled = true
            let pieceOne : GamePiece = pieces[finalPosition]!
            let pieceTwo : GamePiece = pieces[initialPosition]!
            living = pieceBattle(pieceOne: pieceOne, pieceTwo: pieceTwo)
        }
        if living {
            if battled {
                deadPieces.append(pieces[finalPosition]!)
            }
            let piece = pieces[initialPosition]
            
            var updatedPiece = piece
            updatedPiece?.location = finalPosition
            pieces[initialPosition] = nil
            pieces[finalPosition] = updatedPiece
            if player == .player1 {
                board[finalPosition]?.color = "blue"
                if finalPosition == Position(row: 0, column: 0) {
                    gameOver = true
                    blueWon = true
                }
            } else {
                board[finalPosition]?.color = "red"
                if finalPosition == Position(row: magicNumber, column: magicNumber) {
                    gameOver = true
                    redWon = true
                }
            }
            board[initialPosition]?.containsPiece = false
            board[finalPosition]?.containsPiece = true
            gameOver = !checkWinner()
        } else {
            deadPieces.append(pieces[initialPosition]!)
            pieces[initialPosition] = nil
            board[initialPosition]?.containsPiece = false
            gameOver = !checkWinner()
        }
        resetBoard()
        endTurnPhase()
        
        if gameOver {
            blueWon = didBlueWin()
            redWon = !blueWon
        }
    }
    
    func getComputerRelocation(movePerformed: [Position?]) -> [Position] {
        var decision : [Position] = []
        var relocationMoves : [[Position]] = []
        
        for key in pieces.keys {
            if pieces[key]!.owner == .player2 {
                for move in getAllRelocateMoves(position: pieces[key]!.location) {
                    if !(pieces[key]!.location == movePerformed[0] && move == movePerformed[1]) {
                        relocationMoves.append([pieces[key]!.location, move])
                    }
                }
            }
        }
        
        let index = Int.random(in: 0..<relocationMoves.count)
        decision = relocationMoves[index]
        
        return decision
    }
    
    func relocateComputerPiece(initialPosition : Position, finalPosition : Position) {
        let piece = pieces[initialPosition]
        var updatedPiece = piece
        updatedPiece?.location = finalPosition
        pieces[finalPosition] = updatedPiece
        pieces[initialPosition] = nil
        board[initialPosition]?.containsPiece = false
        board[finalPosition]?.containsPiece = true
        resetBoard()
        endRelocatePhase()
    }
    
    func hardResetGame() {
        blueWon = false
        redWon = false
        gameOver = false
        
        playerOneUnits = 0
        playerTwoUnits = 0
        
        for key in board.keys {
            board[key] = SquareState(
                color: "white",
                containsPiece: false,
                isHighlighted: false,
                possibleMove: false
            )
        }
        
        board[Position(row: 0, column: 0)] = SquareState(color: "red", containsPiece: true, isHighlighted: false, possibleMove: false)
        board[Position(row: 0, column: 1)] = SquareState(color: "red", containsPiece: true, isHighlighted: false, possibleMove: false)
        board[Position(row: magicNumber, column: magicNumber)] = SquareState(color: "blue", containsPiece: true, isHighlighted: false, possibleMove: false)
        board[Position(row: magicNumber, column: magicNumber - 1)] = SquareState(color: "blue", containsPiece: true, isHighlighted: false, possibleMove: false)
        
        
        
        var piecesToAppend: [GamePiece] = []
            for piece in pieces.values {
                piecesToAppend.append(piece)
            }
            
            pieces = [:]
            for var piece in piecesToAppend {
                if piece.owner == .player1 {
                    let position = playerOneUnits == 0 ? Position(row: magicNumber, column: magicNumber) : Position(row: magicNumber, column: magicNumber - 1)
                    piece.location = position
                    pieces[position] = piece
                    playerOneUnits += 1
                } else {
                    let position = playerTwoUnits == 0 ? Position(row: 0, column: 0) : Position(row: 0, column: 1)
                    piece.location = position
                    pieces[position] = piece
                    playerTwoUnits += 1
                }
            }
            // Reset dead pieces
            for var piece in deadPieces {
                if piece.owner == .player1 {
                    let position = playerOneUnits == 0 ? Position(row: magicNumber, column: magicNumber) : Position(row: magicNumber, column: magicNumber - 1)
                    piece.location = position
                    pieces[position] = piece
                    playerOneUnits += 1
                } else {
                    let position = playerTwoUnits == 0 ? Position(row: 0, column: 0) : Position(row: 0, column: 1)
                    piece.location = position
                    pieces[position] = piece
                    playerTwoUnits += 1
                }
            }
        
        
        turn = turnMagicNumber
        player = .player1
        turnPhase = .move
        
        
        deadPieces = []
        
    }
}
