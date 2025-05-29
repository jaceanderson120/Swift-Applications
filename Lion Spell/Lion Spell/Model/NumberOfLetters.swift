//
//  NumberOfLetters.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/14/24.
//

import Foundation

enum NumberOfLetters: Int, CaseIterable, Identifiable {
    case five = 5
    case six = 6
    case seven = 7
    var id: RawValue{rawValue}
}
