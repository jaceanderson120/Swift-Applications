//
//  HeightWeight.swift
//  Pokedex
//
//  Created by Jace Anderson on 10/26/24.
//

import SwiftUI

struct HeightWeight: View {
    var pokemon : Pokemon
    var body: some View {
        HStack {
            VStack {
                Text("Height")
                    .padding()
                Text(String(format: "%.2f m", pokemon.height))
                    .bold()
            }
            .padding()
            VStack {
                Text("Weight")
                    .padding()
                Text(String(format: "%.2f kg", pokemon.weight))
                    .bold()
            }
            .padding()
        }
    }
}

#Preview {
    @Previewable @State var manager = PokemonManager()
    HeightWeight(pokemon: manager.pokemon[0])
}
