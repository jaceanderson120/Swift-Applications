//
//  PokemonCard.swift
//  Pokedex
//
//  Created by Jace Anderson on 10/31/24.
//

import SwiftUI

struct PokemonCard: View {
    @Binding var entry: Pokemon
    @State var manager: PokemonManager
        
    var body: some View {
        NavigationLink(destination: PokemonLink(manager: _manager, pokemon: $entry)) {
            let formattedId = String(format: "%03d", entry.id)
            let colors = manager.getColor(types: entry.types)
            
            HStack {
                Text("\(entry.id)")
                Text("  \(entry.name)")
                Spacer()
                ZStack {
                    LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(width: 60, height: 60)
                    Image(formattedId)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                }
                if entry.captured == true {
                    Image(systemName: "star.fill") // Captured indicator
                        .foregroundColor(.yellow)
                        .padding(.trailing, 5)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
            .padding(.horizontal, 5)
        }
    }
}

#Preview {
    @Previewable @State var manager = PokemonManager()
    PokemonCard(entry: $manager.pokemon[0], manager: manager)
}
