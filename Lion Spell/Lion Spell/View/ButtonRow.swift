//
//  ButtonRow.swift
//  Lion Spell
//
//  Created by Jace Anderson on 8/31/24.
//

import SwiftUI

struct ButtonRow: View {
    var buttons : ButtonManager
    @Binding var showingPref : Bool
    @Binding var showingHints : Bool
    
    var body: some View {
        HStack {
            ForEach(buttons.buttons, id: \.id) { button in
                Button(action: {
                    if (button.imageString == "slider.horizontal.3") {
                        showingPref.toggle()
                    }
                    else if (button.imageString == "questionmark.circle.fill") {
                        showingHints.toggle()
                    }
                    else {
                        button.action()
                    }
                }) {
                    Image(systemName: button.imageString)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.blue)
                        .padding()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: 50)
    }
}

#Preview {
    @Previewable @State var var1 = false
    @Previewable @State var var2 = false
    let buttons = ButtonManager()
    return ButtonRow(buttons: buttons, showingPref: $var1, showingHints: $var2)
}
