//
//  ChooseSoldierMult.swift
//  GridBattle
//
//  Created by Jace Anderson on 12/11/24.
//

import SwiftUI

struct ChooseSoldierMult: View {
    @Binding var player : Players
    var boardOne : Bool
    @Binding var gameManagerTwo : MultiplayerGameManagerBoardTwo
    @Binding var multiplayerManager : MultiplayerGameManager
    
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
                    if !multiplayerManager.connected {
                        Text("Warning! Multiplayer disconnected. Please go back to setup connection.")
                            .bold()
                            .foregroundStyle(Color.red)
                            .font(.system(size: 35))
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
                        gameManagerTwo.resetBoard()
                        gameManagerTwo.setupBoard()
                        gameManagerTwo.addPlanes(airOne: blueSpeedCount, curplayer: player)
                        gameManagerTwo.addTanks(tankOne: blueAttackCount, curplayer: player)
                        gameManagerTwo.addSoldiers(soldierOne: blueDefenseCount, curplayer: player)
                        gameManagerTwo.gameType = gameType
                        multiplayerManager.sendBoardAndPieces()
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
                    .disabled(!multiplayerManager.connected)
                }
            }
        }
        .navigationDestination(isPresented: $navigateBoardTwo) {
            if !boardOne {
                MultiplayerBoardTwo(multmanager: $multiplayerManager, manager: $gameManagerTwo, player: $player, magicNumber: 7)
            } else {
                MultiplayerBoardTwo(multmanager: $multiplayerManager, manager: $gameManagerTwo, player: $player, magicNumber: 3)
            }
        }
    }
}

#Preview {
    @Previewable @State var manager = MultiplayerGameManagerBoardTwo()
    @Previewable @State var multManager = MultiplayerGameManager()
    @Previewable @State var player : Players = .player1
    ChooseSoldierMult(player: $player, boardOne: false, gameManagerTwo: $manager, multiplayerManager: $multManager, gameType: .multiplayer)
}
