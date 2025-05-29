//
//  ContentView.swift
//  StateCollegeMap
//
//  Created by Jace Anderson on 10/3/24.
//

import SwiftUI


struct ContentView: View {
    @Environment(Manager.self) var manager : Manager
    
    var body: some View {
        MapView(manager: manager)
    }
}

#Preview {
    ContentView()
        .environment(Manager())
}
