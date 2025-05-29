//
//  SquareState.swift
//  GridBattle
//
//  Created by Jace Anderson on 11/20/24.
//

import Foundation
import SwiftUI

struct SquareState: Codable {
    var color: String
    var containsPiece : Bool
    var isHighlighted: Bool
    var possibleMove : Bool
}
