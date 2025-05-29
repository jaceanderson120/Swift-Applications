//
//  ChooseBoard.swift
//  GridBattle
//
//  Created by Jace Anderson on 11/3/24.
//

import SwiftUI

struct ChooseBoard: View {
    var gameType : GameType
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    if gameType != .multiplayer {
                        HStack {
                            Image("airplane")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                            Image("airplane")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                        }
                        Text("Choose a Board To Play On")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 50))
                            .bold()
                        NavigationLink(destination: ChooseSoldiers(boardOne: true, gameType: gameType)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(height: 75)
                                    .foregroundStyle(Color.blue)
                                Text("Board One: 4x4")
                                    .foregroundStyle(Color.white)
                                    .bold()
                                    .font(.system(size: 40))
                            }
                        }
                        NavigationLink(destination: ChooseSoldiers(boardOne: false, gameType: gameType)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(height: 75)
                                    .foregroundStyle(Color.blue)
                                Text("Board Two: 8x8")
                                    .foregroundStyle(Color.white)
                                    .bold()
                                    .font(.system(size: 40))
                            }
                        }
                    } else {
                        HStack {
                            Image("airplane")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                            Image("airplane")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                        }
                        Text("Choose a Board To Play On")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 50))
                            .bold()
                        NavigationLink(destination: MultiplayerConnect(boardOne: true, gameType: gameType)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(height: 75)
                                    .foregroundStyle(Color.blue)
                                Text("Board One: 4x4")
                                    .foregroundStyle(Color.white)
                                    .bold()
                                    .font(.system(size: 40))
                            }
                        }
                        NavigationLink(destination: MultiplayerConnect(boardOne: false, gameType: gameType)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(height: 75)
                                    .foregroundStyle(Color.blue)
                                Text("Board Two: 8x8")
                                    .foregroundStyle(Color.white)
                                    .bold()
                                    .font(.system(size: 40))
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ChooseBoard(gameType: .local)
}
