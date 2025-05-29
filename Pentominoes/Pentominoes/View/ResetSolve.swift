//
//  ResetSolve.swift
//  Pentominoes
//
//  Created by Jace Anderson on 9/22/24.
//

import SwiftUI

struct ResetSolve: View {
    @Binding var resetSignal : Bool
    @Binding var solveSignal : Bool
    
    var body: some View {
        HStack {
            Button(action: {
                resetSignal.toggle()
            }) {
                Text("Reset")
                    .foregroundStyle(Color.red)
            }
            .padding()
            Button(action: {
                solveSignal.toggle()
            }) {
                Text("Solve")
                    .foregroundStyle(Color.red)
            }
            .padding()
        }
    }
}

#Preview {
    @Previewable @State var resetSignal : Bool = false
    @Previewable @State var solve : Bool = false
    ResetSolve(resetSignal: $resetSignal, solveSignal: $solve)
}
