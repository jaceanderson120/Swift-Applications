//
//  ChooseSoldiers.swift
//  GridBattle
//
//  Created by Jace Anderson on 11/3/24.
//

import SwiftUI

struct ChooseSoldiers: View {
    var boardOne : Bool
    @State var gameManagerTwo = GameManagerBoardTwo()
    
    @State var navigateBoardTwo = false
    
    @State private var selectedColor: String = "Blue"
    @State var numberOfRed = 2
    @State var numberOfBlue = 2

    @State var redDefenseCount = 0
    @State var redSpeedCount = 0
    @State var redAttackCount = 0
    @State var blueDefenseCount = 0
    @State var blueSpeedCount = 0
    @State var blueAttackCount = 0

    var gameType: GameType

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    if gameType == .local {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue.opacity(0.6))
                                .frame(height: 50)
                            Picker("Color", selection: $selectedColor) {
                                Text("Blue").tag("Blue")
                                Text("Red").tag("Red")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                        }
                        .padding()
                    }

                    Text("Remaining Picks: \(selectedColor == "Blue" ? numberOfBlue : numberOfRed)")
                        .bold()
                        .foregroundStyle(Color.white)
                        .font(.system(size: 60))

                    HStack {
                        VStack {
                            Image("soldier")
                                .resizable()
                                .scaledToFit()
                            Text("\(selectedColor == "Blue" ? blueDefenseCount : redDefenseCount)")
                                .bold()
                                .foregroundStyle(Color.white)
                                .font(.system(size: 60))
                            Text("Defense")
                                .bold()
                                .foregroundStyle(Color.white)
                                .font(.system(size: 60))
                            HStack {
                                Button(action: {
                                    if selectedColor == "Blue" && numberOfBlue > 0 {
                                        blueDefenseCount += 1
                                        numberOfBlue -= 1
                                    } else if selectedColor == "Red" && numberOfRed > 0 {
                                        redDefenseCount += 1
                                        numberOfRed -= 1
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(Color.green)
                                }
                                Button(action: {
                                    if selectedColor == "Blue" && blueDefenseCount > 0 {
                                        blueDefenseCount -= 1
                                        numberOfBlue += 1
                                    } else if selectedColor == "Red" && redDefenseCount > 0 {
                                        redDefenseCount -= 1
                                        numberOfRed += 1
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(Color.red)
                                }
                            }
                        }

                        VStack {
                            Image("airplane")
                                .resizable()
                                .scaledToFit()
                            Text("\(selectedColor == "Blue" ? blueSpeedCount : redSpeedCount)")
                                .bold()
                                .foregroundStyle(Color.white)
                                .font(.system(size: 60))
                            Text("Speed")
                                .bold()
                                .foregroundStyle(Color.white)
                                .font(.system(size: 60))
                            HStack {
                                Button(action: {
                                    if selectedColor == "Blue" && numberOfBlue > 0 {
                                        blueSpeedCount += 1
                                        numberOfBlue -= 1
                                    } else if selectedColor == "Red" && numberOfRed > 0 {
                                        redSpeedCount += 1
                                        numberOfRed -= 1
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(Color.green)
                                }
                                Button(action: {
                                    if selectedColor == "Blue" && blueSpeedCount > 0 {
                                        blueSpeedCount -= 1
                                        numberOfBlue += 1
                                    } else if selectedColor == "Red" && redSpeedCount > 0 {
                                        redSpeedCount -= 1
                                        numberOfRed += 1
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(Color.red)
                                }
                            }
                        }

                        VStack {
                            Image("tank")
                                .resizable()
                                .scaledToFit()
                            Text("\(selectedColor == "Blue" ? blueAttackCount : redAttackCount)")
                                .bold()
                                .foregroundStyle(Color.white)
                                .font(.system(size: 60))
                            Text("Attack")
                                .bold()
                                .foregroundStyle(Color.white)
                                .font(.system(size: 60))
                            HStack {
                                Button(action: {
                                    if selectedColor == "Blue" && numberOfBlue > 0 {
                                        blueAttackCount += 1
                                        numberOfBlue -= 1
                                    } else if selectedColor == "Red" && numberOfRed > 0 {
                                        redAttackCount += 1
                                        numberOfRed -= 1
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(Color.green)
                                }
                                Button(action: {
                                    if selectedColor == "Blue" && blueAttackCount > 0 {
                                        blueAttackCount -= 1
                                        numberOfBlue += 1
                                    } else if selectedColor == "Red" && redAttackCount > 0 {
                                        redAttackCount -= 1
                                        numberOfRed += 1
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(Color.red)
                                }
                            }
                        }
                    }
                Button(action: {
                    if boardOne {
                        gameManagerTwo.magicNumber = 3
                        gameManagerTwo.turn = 15
                        gameManagerTwo.turnMagicNumber = 15
                    } else {
                        gameManagerTwo.magicNumber = 7
                        gameManagerTwo.turn = 25
                        gameManagerTwo.turnMagicNumber = 25
                    }
                    gameManagerTwo.resetBoard()
                    gameManagerTwo.setupBoard()
                    gameManagerTwo.resetPieces()
                    gameManagerTwo.addPlanes(airOne: blueSpeedCount, airTwo: redSpeedCount)
                    gameManagerTwo.addTanks(tankOne: blueAttackCount, tankTwo: redAttackCount)
                    gameManagerTwo.addSoldiers(soldierOne: blueDefenseCount, soldierTwo: redDefenseCount)
                    gameManagerTwo.gameType = gameType
                    if gameType == .computer {
                        gameManagerTwo.addComputerPieces()
                    }
                    navigateBoardTwo = true
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(height: 75)
                            .foregroundStyle(Color.blue)
                        Text("Submit")
                            .foregroundStyle(Color.white)
                            .bold()
                            .font(.system(size: 40))
                    }
                }
                .padding()
                .disabled(!((gameType == .local && numberOfRed == 0 && numberOfBlue == 0) || (gameType != .local && numberOfBlue == 0)))
                }
            }
        }
        .navigationDestination(isPresented: $navigateBoardTwo) {
            if boardOne {
                BoardTwo(manager: $gameManagerTwo, magicNumber: 3)
            } else {
                BoardTwo(manager: $gameManagerTwo, magicNumber: 7)
            }
        }
    }
}

#Preview {
    ChooseSoldiers(boardOne: true, gameType: .local)
}
