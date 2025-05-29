//
//  Hexagon.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/14/24.
//

import SwiftUI

struct Hexagon: View {
    var letter : String
    var body: some View {
        ZStack {
            HexagonShape()
            Text(letter)
                .font(.largeTitle)
                .scaledToFit()
                .foregroundColor(.white)
        }
    }
}

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let angle = (2 * .pi) / 6.0
        
        let length = min(rect.width, rect.height) / 2
        
        path.move(to: CGPoint(x: rect.midX + length * cos(0), y: rect.midY + length * sin(0)))
        path.addLine(to: CGPoint(x: rect.midX + length * cos(angle * 1), y: rect.midY + length * sin(angle * 1)))
        path.addLine(to: CGPoint(x: rect.midX + length * cos(angle * 2), y: rect.midY + length * sin(angle * 2)))
        path.addLine(to: CGPoint(x: rect.midX + length * cos(angle * 3), y: rect.midY + length * sin(angle * 3)))
        path.addLine(to: CGPoint(x: rect.midX + length * cos(angle * 4), y: rect.midY + length * sin(angle * 4)))
        path.addLine(to: CGPoint(x: rect.midX + length * cos(angle * 5), y: rect.midY + length * sin(angle * 5)))
        return path
    }
}

#Preview {
    Hexagon(letter: "s")
}
