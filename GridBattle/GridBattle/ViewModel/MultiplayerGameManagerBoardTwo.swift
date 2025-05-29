//
//  MultiplayerGameManagerBoardTwo.swift
//  GridBattle
//
//  Created by Jace Anderson on 12/11/24.
//

import Foundation
import SwiftUI


@Observable
class MultiplayerGameManagerBoardTwo {
    var turnPhase : TurnPhase = .move
    
    var player : Players = .player1
    var playerTurn : Players = .player1
    
    var gameType : GameType = .multiplayer
    
    var turn : Int = 25
    
    var magicNumber : Int = 7
    var turnMagicNumber : Int = 25
    
    var gameOver : Bool = false
    var blueWon : Bool = false
    var redWon : Bool = false
    
    var playerUnits : Int = 0
    
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
        playerUnits = 0
        pieces = [:]
        turnPhase = .move
    }
    
    func addPlanes(airOne: Int, curplayer: Players) {
        player = curplayer
        if curplayer == .player1 {
            for _ in 0..<airOne {
                if (playerUnits == 0) {
                    pieces[Position(row: magicNumber, column: magicNumber)] = GamePiece(location: Position(row: magicNumber, column: magicNumber), pieceType: .plane, owner: .player1, state: .alive)
                } else {
                    pieces[Position(row: magicNumber, column: (magicNumber - 1))] = GamePiece(location: Position(row: magicNumber, column: (magicNumber - 1)), pieceType: .plane, owner: .player1, state: .alive)
                }
                playerUnits += 1
            }
        } else {
            for _ in 0..<airOne {
                if (playerUnits == 0) {
                    pieces[Position(row: 0, column: 0)] = GamePiece(location: Position(row: 0, column: 0), pieceType: .plane, owner: .player2, state: .alive)
                } else {
                    pieces[Position(row: 0, column: 1)] = GamePiece(location: Position(row: 0, column: 1), pieceType: .plane, owner: .player2, state: .alive)
                }
                playerUnits += 1
            }
        }
    }
    
    func addTanks(tankOne: Int, curplayer: Players) {
        player = curplayer
        if curplayer == .player1 {
            for _ in 0..<tankOne {
                if playerUnits == 0 {
                    pieces[Position(row: magicNumber, column: magicNumber)] = GamePiece(location: Position(row: magicNumber, column: magicNumber), pieceType: .tank, owner: .player1, state: .alive)
                } else {
                    pieces[Position(row: magicNumber, column: magicNumber - 1)] = GamePiece(location: Position(row: magicNumber - 1, column: magicNumber - 1), pieceType: .tank, owner: .player1, state: .alive)
                }
                playerUnits += 1
            }
        } else {
            for _ in 0..<tankOne {
                if playerUnits == 0 {
                    pieces[Position(row: 0, column: 0)] = GamePiece(location: Position(row: 0, column: 0), pieceType: .tank, owner: .player2, state: .alive)
                } else {
                    pieces[Position(row: 0, column: 1)] = GamePiece(location: Position(row: 0, column: 1), pieceType: .tank, owner: .player2, state: .alive)
                }
                playerUnits += 1
            }
        }
    }
    
    func addSoldiers(soldierOne: Int, curplayer: Players) {
        player = curplayer
        if curplayer == .player1 {
            for _ in 0..<soldierOne {
                if playerUnits == 0 {
                    pieces[Position(row: magicNumber, column: magicNumber)] = GamePiece(location: Position(row: magicNumber, column: magicNumber), pieceType: .soldier, owner: .player1, state: .alive)
                } else {
                    pieces[Position(row: magicNumber, column: magicNumber - 1)] = GamePiece(location: Position(row: magicNumber, column: magicNumber - 1), pieceType: .soldier, owner: .player1, state: .alive)
                }
                playerUnits += 1
            }
        } else {
            for _ in 0..<soldierOne {
                if playerUnits == 0 {
                    pieces[Position(row: 0, column: 0)] = GamePiece(location: Position(row: 0, column: 0), pieceType: .soldier, owner: .player2, state: .alive)
                } else {
                    pieces[Position(row: 0, column: 1)] = GamePiece(location: Position(row: 0, column: 1), pieceType: .soldier, owner: .player2, state: .alive)
                }
                playerUnits += 1
            }
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
            board[startPosition!]?.containsPiece = false
            board[position]?.containsPiece = true
            if player == .player1 {
                board[position]?.color = "blue"
            } else {
                board[position]?.color = "red"
            }
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
    
    func endRelocatePhase() {
        turnPhase = .move
        if playerTurn == .player1 {
            playerTurn = .player2
        } else {
            playerTurn = .player1
        }
        if player == .player2 {
            turn -= 1
        }
    }
    
    func skipPhase() {
        if turnPhase == .move {
            endTurnPhase()
        } else {
            endRelocatePhase()
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
        endRelocatePhase()
        resetBoard()
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
        
        
        if board[Position(row: 0, column: 0)]!.color == "blue" {
            return true
        } else if board[Position(row: magicNumber, column: magicNumber)]!.color == "red" {
            return false
        }
        
        
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
        if !attackerWins {
            playerUnits -= 1
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
    
    func hardResetGame() {
        blueWon = false
        redWon = false
        gameOver = false
        
        playerUnits = 0
        turnPhase = .move
        playerTurn = .player1
        turn = turnMagicNumber
        
        var otherPlayerUnits = 0
        
        
        
        var piecesToAppend: [GamePiece] = []
            for piece in pieces.values {
                piecesToAppend.append(piece)
            }
        for piece in deadPieces {
            piecesToAppend.append(piece)
        }
            
            pieces = [:]
            for var piece in piecesToAppend {
                if piece.owner == .player1 && player == .player1 {
                    let position = playerUnits == 0 ? Position(row: magicNumber, column: magicNumber) : Position(row: magicNumber, column: magicNumber - 1)
                    piece.location = position
                    pieces[position] = piece
                    playerUnits += 1
                } else if piece.owner == .player1 && player != .player1 {
                    let position = otherPlayerUnits == 0 ? Position(row: magicNumber, column: magicNumber) : Position(row: magicNumber, column: magicNumber - 1)
                    piece.location = position
                    pieces[position] = piece
                    otherPlayerUnits += 1
                } else if piece.owner == .player2 && player == .player2 {
                    let position = playerUnits == 0 ? Position(row: 0, column: 0) : Position(row: 0, column: 1)
                    piece.location = position
                    pieces[position] = piece
                    playerUnits += 1
                } else {
                    let position = otherPlayerUnits == 0 ? Position(row: 0, column: 0) : Position(row: 0, column: 1)
                    piece.location = position
                    pieces[position] = piece
                    otherPlayerUnits += 1
                }
            }
            
        
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
        
        
        deadPieces = []
        
    }
}
