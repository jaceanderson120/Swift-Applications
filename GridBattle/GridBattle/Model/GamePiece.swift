//
//  GamePiece.swift
//  GridBattle
//
//  Created by Jace Anderson on 11/17/24.
//

import Foundation

struct GamePiece : Hashable, Codable {
    var location : Position
    var pieceType : PieceType
    var owner : Players
    var state : PieceState
}
