//
//  PokemonLink.swift
//  Pokedex
//
//  Created by Jace Anderson on 10/26/24.
//

import SwiftUI

struct PokemonLink: View {
    @State var manager : PokemonManager
    @Binding var pokemon : Pokemon
    @State private var isCaptured: Bool
        
    init(manager: State<PokemonManager>, pokemon: Binding<Pokemon>) {
        self._manager = manager
        self._pokemon = pokemon
        self._isCaptured = State(initialValue: pokemon.wrappedValue.captured!)
    }
    
    var body: some View {
        let formattedName = String(format: "%03d", pokemon.id)
        let colors = manager.getColor(types: pokemon.types)
    
        NavigationStack {
            VStack {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(width: 300, height: 300)
                    Image(formattedName)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .padding()
                }
                Text("\(pokemon.name) \(String(format: "%03d", pokemon.id))")
                    .bold()
                    .padding()
                HeightWeight(pokemon: pokemon)
                Typings(pokemon: pokemon)
                Weaknesses(pokemon: pokemon)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isCaptured.toggle()
                        pokemon.captured!.toggle()
                    }) {
                        isCaptured ? Image(systemName: "c.circle.fill") : Image(systemName: "c.circle")
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var manager = PokemonManager()
    PokemonLink(manager: _manager, pokemon: $manager.pokemon[0])
}
