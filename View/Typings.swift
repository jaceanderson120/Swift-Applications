//
//  Typings.swift
//  Pokedex
//
//  Created by Jace Anderson on 10/26/24.
//

import SwiftUI

struct Typings: View {
    var pokemon : Pokemon
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Types")
                .bold()
                .padding(.leading)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(pokemon.types, id: \.self) {type in
                        ZStack {
                            LinearGradient(gradient: Gradient(colors: [Color(pokemonType: type)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .frame(height: 40)
                            Text("\(type)")
                                .bold()
                                .padding()
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    @Previewable @State var manager = PokemonManager()
    Typings(pokemon: manager.pokemon[0])
}
