//
//  Pentomino.swift
//  Pentominoes
//
//  Created by Jace Anderson on 9/22/24.
//

import SwiftUI

struct Pentomino: Shape {
    var pentominos : PentominoOutline
    var actualWidth : CGFloat
    var actualHeight : CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let height = actualHeight / CGFloat(pentominos.size.height)
        let width = actualWidth / CGFloat(pentominos.size.width)
        var value = 0
        
        for point in pentominos.outline {
            let xVal = CGFloat(point.x) * width
            let yVal = CGFloat(point.y) * height
            if (value == 0) {
                path.move(to: CGPoint(x: xVal, y: yVal))
                value = 1
            } else {
                path.addLine(to: CGPoint(x: xVal, y: yVal))
            }
        }
        
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    let point = Point(x: 3, y: 5)
    let size = Size(width: 3, height: 3)
    let pento = PentominoOutline(name: "pento", size: size, outline: [point])
    Pentomino(pentominos: pento, actualWidth: CGFloat(400) / CGFloat(14) * CGFloat(size.width), actualHeight: CGFloat(400) / CGFloat(14) * CGFloat(size.height))
        .stroke(Color.black, lineWidth: 2)
}
