//
//  Diamond.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/14/24.
//

import SwiftUI

struct Diamond: View {
    var letter : String
    var body: some View {
        ZStack {
            DiamondShape()
            Text(letter)
                .font(.largeTitle)
                .scaledToFit()
                .foregroundColor(.white)
        }
    }
}

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let length = min(rect.width, rect.height)
        path.move(to: CGPoint(x: rect.midX, y: rect.midY - length / 2))
        path.addLine(to: CGPoint(x: rect.midX + length / 2, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY + length / 2))
        path.addLine(to: CGPoint(x: rect.midX - length / 2, y: rect.midY))
        return path
    }
}

#Preview {
    Diamond(letter: "s")
}
