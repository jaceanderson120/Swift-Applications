//
//  ContentView.swift
//  ActivityIndicator
//
//  Created by Jace Anderson on 10/15/24.
//

import SwiftUI
import UIKit

@Observable
class Manager {
    var isAnimating : Bool = false
}

struct ActivityIndicator : UIViewRepresentable {
    @Environment(Manager.self) var manager
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let uiView = UIActivityIndicatorView(style: .large)
        uiView.startAnimating()
        return uiView
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        manager.isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct ContentView: View {
    @Environment(Manager.self) var manager
    var body: some View {
        VStack {
            ActivityIndicator()
            Button("Press Me") {
                manager.isAnimating.toggle()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environment(Manager())
}
