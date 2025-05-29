//
//  Grid.swift
//  Pentominoes
//
//  Created by Jace Anderson on 9/22/24.
//

import SwiftUI

struct Grid: Shape {
    var rows : Int
    var columns : Int
    
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let rowHeight = rect.height / CGFloat(rows)
        let colWidth = rect.width / CGFloat(columns)
        
        for row in 0...rows {
            let y = rect.minY + (rowHeight * CGFloat(row))
            path.move(to: CGPoint(x: rect.minX, y: y))
            path.addLine(to: CGPoint(x: rect.maxX, y: y))
        }
        
        for column in 0...columns {
            let x = rect.minX + (colWidth * CGFloat(column))
            path.move(to: CGPoint(x: x, y: rect.minY))
            path.addLine(to: CGPoint(x: x, y: rect.maxY))
        }
        
        return path
    }
}

#Preview {
    Grid(rows: 2, columns: 4)
        .stroke(Color.black, lineWidth: 2)
}
