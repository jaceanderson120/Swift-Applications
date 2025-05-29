//
//  ContentView.swift
//  Lion Spell
//
//  Created by Jace Anderson on 8/31/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ViewStateHolder()
    }
}

#Preview {
    ContentView()
        .environment(LetterManager())
        .environment(WordManager())
}
