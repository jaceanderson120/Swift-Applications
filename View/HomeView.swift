//
//  HomeView.swift
//  Pokedex
//
//  Created by Jace Anderson on 10/31/24.
//

import SwiftUI

struct HomeView: View {
    @State var manager: PokemonManager
    @State var showAllPokemon: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Captured Pokémon Section
                    if capturedPokemon().count > 0 {
                        CapturedPokemonRow(manager: manager, capturedPokemon: capturedPokemon())
                    }
                    Spacer()
                    
                    // Rows for Each PokemonType
                    ForEach(PokemonType.allCases, id: \.self) { type in
                        if (type != .all && type != .captured) {
                            PokemonTypeRow(type: type, manager: manager, pokemonOfType: pokemon(ofType: type))
                        }
                    }
                    
                    // Button to View Full List
                    Button("See Full Pokedex") {
                        showAllPokemon = true
                    }
                    .padding()
                }
            }
            .navigationTitle("Pokedex")
            .sheet(isPresented: $showAllPokemon) {
                PokedexList(manager: manager)
            }
        }
    }
    
    private func capturedPokemon() -> [Binding<Pokemon>] {
        return $manager.pokemon.filter { $0.captured.wrappedValue == true }
    }
    
    private func pokemon(ofType type: PokemonType) -> [Binding<Pokemon>] {
        return $manager.pokemon.filter { $0.types.wrappedValue.contains(type) }
    }
}

struct CapturedPokemonRow: View {
    var manager: PokemonManager
    var capturedPokemon: [Binding<Pokemon>]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Captured Pokémon")
                .font(.headline)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(capturedPokemon, id: \.id) { entry in
                        PokemonCard(entry: entry, manager: manager)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct PokemonTypeRow: View {
    var type: PokemonType
    var manager: PokemonManager
    var pokemonOfType: [Binding<Pokemon>]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(type.rawValue.capitalized)")
                .font(.headline)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(pokemonOfType, id: \.id) { entry in
                        PokemonCard(entry: entry, manager: manager)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    @Previewable @State var manager = PokemonManager()
    HomeView(manager: manager)
}
