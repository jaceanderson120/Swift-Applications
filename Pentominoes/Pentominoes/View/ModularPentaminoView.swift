//
//  ModularPentaminoView.swift
//  Pentominoes
//
//  Created by Jace Anderson on 9/27/24.
//

import SwiftUI

struct ModularPentaminoView: View {
    @State private var offset : CGSize = .zero
    @State private var currentOffset : CGSize = .zero
    @State private var dragging : Bool = false
    @State var rotation : Angle = .degrees(0)
    
    let puzzles : PuzzlePieces
    let index : Int
    @Binding var resetSignal : Bool
    @Binding var solveSignal : Bool
    @State var isResetting = false
    
    @State var minX : CGFloat = 0
    @State var maxX : CGFloat = 0
    @State var minY : CGFloat = 0
    @State var maxY : CGFloat = 0
    
    @State var scaleEffX: CGFloat = 1
    @State var scaleEffY: CGFloat = 1
    @State var scaleEff : Int = 1
    
    @State var solved : Bool = false
    
    var xVal: CGFloat {
        CGFloat(puzzles.getSolution(name: puzzles.pentominoPieces[index].outline.name)?.x ?? 0)
    }
        
    var yVal: CGFloat {
        CGFloat(puzzles.getSolution(name: puzzles.pentominoPieces[index].outline.name)?.y ?? 0)
    }
    
    var orientation : Orientation {
        if let solution = puzzles.getSolution(name: puzzles.pentominoPieces[index].outline.name) {
                return Orientation(rawValue: solution.orientation.rawValue) ?? .up
        } else {
            return .up
        }
    }
    
    var targetOffset: CGSize {
        let gridLeft = 210.0
        let gridTop = 142.0
        let gridSize: CGFloat = 28.57
        
        let globalX = gridLeft + (xVal * gridSize)
        let globalY = gridTop + (yVal * gridSize)
        
        return CGSize(width: globalX, height: globalY)
    }
    
    var body: some View {
        let outline = puzzles.pentominoPieces[index].outline
        let pentaminoWidth = CGFloat(400) / CGFloat(14) * CGFloat(outline.size.width)
        let pentaminoHeight = CGFloat(400) / CGFloat(14) * CGFloat(outline.size.height)
        let gridSize = max(outline.size.width, outline.size.height)
        
        let centerX = outline.size.width / 2
        let centerY = outline.size.height / 2
        let anchor = UnitPoint(
            x: CGFloat(centerX / outline.size.width),
            y: CGFloat(centerY / outline.size.height)
        )
        
            ZStack(alignment: .bottomLeading) {
                GeometryReader { geometry in
                    var globalPosition = geometry.frame(in: .global)
                    Pentomino(pentominos: puzzles.pentominoPieces[index].outline, actualWidth: pentaminoWidth, actualHeight: pentaminoHeight)
                        .fill(getColors(index: index))
                        .frame(width: pentaminoWidth, height: pentaminoHeight)
                        .onChange(of: currentOffset.width) {
                            if !isResetting {
                                minX = geometry.frame(in: .global).minX
                                maxX = geometry.frame(in: .global).maxX
                                if (minX >= 210 && maxX <= 610) {
                                    let gridSize: CGFloat = 28.57
                                    let gridLeft = 210.0
                                    
                                    let leftRemainder = (minX - gridLeft).truncatingRemainder(dividingBy: gridSize)
                                    let rightRemainder = gridSize - leftRemainder
                                    

                                    if leftRemainder < rightRemainder {
                                        currentOffset.width -= leftRemainder
                                    } else {
                                        currentOffset.width += rightRemainder
                                    }
                                }
                            }
                        }
                        .onChange(of: currentOffset.height) {
                            if !isResetting {
                                minY = geometry.frame(in: .global).minY
                                maxY = geometry.frame(in: .global).maxY
                                if (minY >= 142 && maxY <= 542) {
                                    let gridSize: CGFloat = 28.57
                                    let gridTop = 142.0
                                    
                                    let topRemainder = (minY - gridTop).truncatingRemainder(dividingBy: gridSize)
                                    let bottomRemainder = gridSize - topRemainder
                                    
                                    if topRemainder < bottomRemainder {
                                        currentOffset.height -= topRemainder
                                    } else {
                                        currentOffset.height += bottomRemainder
                                    }
                                }
                            }
                        }
                        .onChange(of: solveSignal) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isResetting = true
                                solved = true
                                alterOrientation(orientation: orientation)
                                globalPosition = geometry.frame(in: .global)
                                moveFromCurrToTarget(currentPosition: globalPosition)
                            }
                        }
                }
                .frame(width: pentaminoWidth, height: pentaminoHeight)
                Grid(rows: Int(gridSize), columns: Int(gridSize))
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: (CGFloat(400) / CGFloat(14)) * CGFloat(gridSize), height: (CGFloat(400) / CGFloat(14)) * CGFloat(gridSize))
                    .mask(alignment: .bottomLeading) {
                        Pentomino(pentominos: puzzles.pentominoPieces[index].outline, actualWidth: pentaminoWidth, actualHeight: pentaminoHeight)
                            .frame(width: pentaminoWidth, height: pentaminoHeight)
                    }
            }
            .frame(width: pentaminoWidth, height: pentaminoHeight)
            .scaleEffect(x: dragging ? 1.2 * scaleEffX : 1.0 * scaleEffX,
                         y: dragging ? 1.2 * scaleEffY : 1.0 * scaleEffY,
                         anchor: anchor)
            .padding()
            .rotationEffect(rotation)
            .offset(x: offset.width + currentOffset.width, y: offset.height + currentOffset.height)
            .gesture(
                DragGesture()
                    .onChanged { coordinate in
                        offset = coordinate.translation
                        solved = false
                        dragging = true
                    }
                    .onEnded { coordinate in
                        isResetting = false
                        currentOffset.width += coordinate.translation.width
                        currentOffset.height += coordinate.translation.height
                        offset = .zero
                        dragging = false
                        solved = false
                    }
            )
        .onChange(of: resetSignal) {
            withAnimation(.easeInOut(duration: 0.3)) {
                isResetting = true
                currentOffset = .zero
                offset = .zero
                rotation = .degrees(0)
                scaleEff = 1
                scaleEffX = 1
                scaleEffY = 1
                solved = false
            }
        }
        .onTapGesture {
            withAnimation {
                if !dragging {
                    solved = false
                    rotation += .degrees(90)
                }
            }
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5)
                .onEnded { value in
                    withAnimation {
                        if !dragging {
                            solved = false
                            rotation += .degrees(180)
                        }
                    }
                }
        )
        .opacity(solved ? 0.5 : 1)
    }
    
    func moveFromCurrToTarget(currentPosition: CGRect) {
        let currentX = currentPosition.minX
        let currentY = currentPosition.minY
        
        let targetX = targetOffset.width
        let targetY = targetOffset.height
        
        currentOffset = CGSize(width: (targetX - currentX), height: (targetY - currentY))
    }
    
    func alterOrientation(orientation : Orientation) {
        switch orientation {
        case .up:
            rotation = Angle(degrees: 0)
            scaleEffX = 1
            scaleEffY = 1
        case .left:
            rotation = Angle(degrees: 270)
            scaleEffX = 1
            scaleEffY = 1
        case .down:
            rotation = Angle(degrees: 180)
            scaleEffX = 1
            scaleEffY = 1
        case .right:
            rotation = Angle(degrees: 90)
            scaleEffX = 1
            scaleEffY = 1
        case .upMirrored:
            rotation = Angle(degrees: 0)
            scaleEffX = -1
            scaleEffY = 1
        case .leftMirrored:
            rotation = Angle(degrees: 270)
            scaleEffX = -1
            scaleEffY = 1
        case .downMirrored:
            rotation = Angle(degrees: 180)
            scaleEffX = -1
            scaleEffY = 1
        case .rightMirrored:
            rotation = Angle(degrees: 90)
            scaleEffX = -1
            scaleEffY = 1
        }
    }
    
}



#Preview {
    @Previewable @State var reset : Bool = false
    @Previewable @State var solve : Bool = false
    let index = 2
    let puzzle = PuzzlePieces()
    return ModularPentaminoView(puzzles: puzzle, index: index, resetSignal: $reset, solveSignal: $solve)
}
