//
//  LionSpellHeader.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/2/24.
//

import SwiftUI

struct LionSpellHeader: View {
    var body: some View {
        HStack {
            Text("Lion")
                .bold()
                .padding(.top)
                .foregroundStyle(Color.white)
                .font(.system(size: 40))
            Text("Spell")
                .bold()
                .padding(.top)
                .foregroundStyle(Color.blue)
                .font(.system(size: 40))
        }
        .frame(maxWidth: .infinity, alignment: .top)
        Spacer()
    }
}

#Preview {
    LionSpellHeader()
}
