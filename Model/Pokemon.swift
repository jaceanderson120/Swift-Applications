//
//  Pokemon.swift
//  Pokedex
//
//  Created by Jace Anderson on 10/26/24.
//

import Foundation

struct Pokemon : Identifiable, Codable, Hashable {
    var id : Int
    var name : String
    var height : Double
    var weight : Double
    var types : [PokemonType]
    var weaknesses : [PokemonType]
    var prev_evolution : [Int]?
    var next_evolution : [Int]?
    var captured : Bool?
}
