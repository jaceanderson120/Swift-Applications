//
//  PokedexList.swift
//  Pokedex
//
//  Created by Jace Anderson on 10/26/24.
//

import SwiftUI


struct PokedexList: View {
    @State var manager : PokemonManager
    @Environment(\.dismiss) var dismiss
    @State var filter : PokemonType = .all
    
    var body: some View {
        NavigationStack {
            Picker("Pokemon Type", selection: $filter) {
                ForEach(PokemonType.allCases, id: \.self) { item in
                    Text("\(item.rawValue)").tag(item)
                }
            }
            .pickerStyle(DefaultPickerStyle())
            .padding()
            List {
                ForEach($manager.pokemon, id: \.self) { entry in
                    if (filter == .captured && entry.captured.wrappedValue == true) {
                        NavigationLink(destination: PokemonLink(manager: _manager, pokemon: entry)) {
                            let formattedId = String(format: "%03d", entry.id)
                            let colors = manager.getColor(types: entry.types.wrappedValue)
                            HStack {
                                Text("\(entry.id)")
                                Text("  \(entry.name.wrappedValue)")
                                Spacer()
                                ZStack {
                                    LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
                                        .frame(width: 60, height: 60)
                                    Image(formattedId)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .padding()
                                }
                            }
                        }
                        .padding()
                    }
                    else if (filter == .all || entry.types.wrappedValue.contains(filter)) {
                        NavigationLink(destination: PokemonLink(manager: _manager, pokemon: entry)) {
                            let formattedId = String(format: "%03d", entry.id)
                            let colors = manager.getColor(types: entry.types.wrappedValue)
                            HStack {
                                Text("\(entry.id)")
                                Text("  \(entry.name.wrappedValue)")
                                Spacer()
                                ZStack {
                                    LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
                                        .frame(width: 60, height: 60)
                                    Image(formattedId)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .padding()
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Pokedex")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing)  {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var manager = PokemonManager()
    PokedexList(manager: manager)
}
