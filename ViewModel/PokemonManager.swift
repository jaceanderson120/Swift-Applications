//
//  PokemonManager.swift
//  Pokedex
//
//  Created by Jace Anderson on 10/26/24.
//

import Foundation
import SwiftUI

@Observable
class PokemonManager {
    var pokemon : [Pokemon] = []
    
    let pokemonManager : PokemonStorage = PokemonStorage<[Pokemon]>()
    
    init() {
        if let modelData = pokemonManager.modelData {
            for var pokedex in modelData {
                if pokedex.captured == nil {
                    pokedex.captured = false
                }
                pokemon.append(pokedex)
            }
        } else {
            pokemon = []
        }
    }
    
    func getColor(types: [PokemonType]) -> [Color] {
        var colors : [Color] = []
        for type in types {
            colors.append(Color(pokemonType: type))
        }
        return colors
    }
    
    func save() {
        pokemonManager.save(components: pokemon)
    }
}
