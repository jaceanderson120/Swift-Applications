//
//  ContentView.swift
//  Pokedex
//
//  Created by Jace Anderson on 10/26/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(PokemonManager.self) var manager : PokemonManager
    
    var body: some View {
        HomeView(manager: manager)
    }
}

#Preview {
    ContentView()
        .environment(PokemonManager())
}
