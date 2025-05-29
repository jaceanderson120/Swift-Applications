//
//  Pentagon.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/14/24.
//

import SwiftUI

struct Pentagon: View {
    var letter : String
    var color : Color = .black
    var rotation : Angle
    var body: some View {
        ZStack {
            PentagonShape()
                .rotationEffect(rotation)
                .foregroundColor(color)
                .frame(width: 100)
            Text(letter)
                .font(.largeTitle)
                .scaledToFit()
                .foregroundColor(.white)
        }
    }
}

struct PentagonShape : Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let angle = (2 * .pi) / 5.0
        
        let length = min(rect.width, rect.height) / 2
        
        let rotation = -(Double.pi / 2)
        
        path.move(to: CGPoint(x: rect.midX + length * CGFloat(cos(rotation)), y: rect.midY + length * CGFloat(sin(rotation))))
        
        for i in 1..<5 {
            path.addLine(to: CGPoint(x: rect.midX + length * cos(rotation + angle * Double(i)), y: rect.midY + length * sin(rotation + angle * Double(i))))
        }
        
        return path
    }
}

#Preview {
    Pentagon(letter: "t", rotation: Angle(degrees: 0))
}
