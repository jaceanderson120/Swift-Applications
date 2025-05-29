//
//  MultiplayerConnect.swift
//  GridBattle
//
//  Created by Jace Anderson on 12/6/24.
//

import SwiftUI

struct MultiplayerConnect: View {
    @State var multiplayerBoardTwo = MultiplayerGameManager()
    @State var gameManagerBoardTwo = MultiplayerGameManagerBoardTwo()
    @State var navigateBoardTwo = false
    var boardOne : Bool
    @State var player : Players = .player1
    var gameType : GameType
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Image("soldier")
                            .resizable()
                            .scaledToFit()
                        Text("Grid Battle")
                            .font(.system(size: 50))
                            .bold()
                            .padding()
                            .foregroundStyle(Color.white)
                        Image("soldier")
                            .resizable()
                            .scaledToFit()
                    }
                    Text("Setup Multiplayer Connection")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 50))
                        .bold()
                    if (multiplayerBoardTwo.connected) {
                        Text("Connected and Ready to Play")
                            .foregroundStyle(Color.green)
                            .font(.system(size: 50))
                            .bold()
                    }
                    Button(action: {
                        player = .player1
                        gameManagerBoardTwo.player = .player1
                        multiplayerBoardTwo.advertise()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(height: 75)
                                .foregroundStyle(Color.blue)
                            Text("Host Game")
                                .foregroundStyle(Color.white)
                                .bold()
                                .font(.system(size: 40))
                        }
                    }
                    Button (action: {
                        player = .player2
                        gameManagerBoardTwo.player = .player2
                        multiplayerBoardTwo.browse()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(height: 75)
                                .foregroundStyle(Color.blue)
                            Text("Join Game")
                                .foregroundStyle(Color.white)
                                .bold()
                                .font(.system(size: 40))
                        }
                    }
                    Text("Available Devices")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 30))
                        .padding(.top)
                    
                    List(multiplayerBoardTwo.availablePlayers, id: \.self) { peer in
                        HStack {
                            Text(peer.displayName)
                                .foregroundColor(.white)
                            Spacer()
                            Button("Connect") {
                                print("Inviting \(peer.displayName)...")
                                multiplayerBoardTwo.nearbyBrowser?.invitePeer(
                                    peer,
                                    to: multiplayerBoardTwo.session,
                                    withContext: nil,
                                    timeout: 10
                                )
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.white)
                        }
                        .padding()
                        .listRowBackground(Color.blue)
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.black)
                    .scrollContentBackground(.hidden)
                    Button(action: {
                        if !boardOne {
                            gameManagerBoardTwo.magicNumber = 7
                            gameManagerBoardTwo.turn = 25
                            gameManagerBoardTwo.turnMagicNumber = 25
                            multiplayerBoardTwo.setupGame(game: gameManagerBoardTwo)
                            navigateBoardTwo = true
                        } else {
                            gameManagerBoardTwo.magicNumber = 3
                            gameManagerBoardTwo.turn = 15
                            gameManagerBoardTwo.turnMagicNumber = 15
                            multiplayerBoardTwo.setupGame(game: gameManagerBoardTwo)
                            navigateBoardTwo = true
                        }
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
                    .disabled(!multiplayerBoardTwo.connected)
                    Image("tank")
                        .resizable()
                        .scaledToFit()
                }
            }
            .onDisappear {
                multiplayerBoardTwo.stopAdvertise()
                multiplayerBoardTwo.stopBrowse()
            }
        }
        .navigationDestination(isPresented: $navigateBoardTwo) {
            ChooseSoldierMult(player: $player, boardOne: boardOne, gameManagerTwo: $gameManagerBoardTwo, multiplayerManager: $multiplayerBoardTwo, gameType: .multiplayer)
        }
    }
}

#Preview {
    MultiplayerConnect(boardOne: false, gameType: .multiplayer)
}
