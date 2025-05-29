//
//  MultiplayerBoardTwo.swift
//  GridBattle
//
//  Created by Jace Anderson on 12/11/24.
//

import SwiftUI
import AVFoundation

struct MultiplayerBoardTwo: View {
    @Binding var multmanager : MultiplayerGameManager
    @Binding var manager : MultiplayerGameManagerBoardTwo
    @Binding var player : Players
    @State private var audioPlayer: AVAudioPlayer?
    @State var isSoundOn = false
    var magicNumber : Int = 7
    
    func getColor(row: Int, column: Int) -> Color {
        if (row == 0 && column == 0) {
            return Color.red
        } else if (row == magicNumber && column == magicNumber) {
            return Color.blue
        } else {
            return Color.white
        }
    }
    
    func setupAudioPlayer() {
        guard let audioURL = Bundle.main.url(forResource: "grid-battle-audio", withExtension: "mp3") else {
            print("Audio file not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error setting up audio player: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        if !multmanager.connected {
                            Text("Disconnect. Game Over.")
                                .bold()
                                .font(.system(size: 40))
                                .foregroundStyle(Color.red)
                        }
                        if manager.gameOver && manager.blueWon {
                            Text("Game Over. Blue Won!")
                                .bold()
                                .font(.system(size: 40))
                                .foregroundStyle(Color.white)
                        } else if manager.gameOver && manager.redWon {
                            Text("Game Over. Red Won!")
                                .bold()
                                .font(.system(size: 40))
                                .foregroundStyle(Color.white)
                        }
                        if !manager.gameOver && multmanager.connected {
                            if manager.playerTurn == .player1 && manager.turnPhase == .move {
                                Text("Blue Move Phase")
                                    .bold()
                                    .font(.system(size: 40))
                                    .foregroundStyle(Color.white)
                            } else if manager.playerTurn == .player1 && manager.turnPhase == .relocate {
                                Text("Blue Relocate Phase")
                                    .bold()
                                    .font(.system(size: 40))
                                    .foregroundStyle(Color.white)
                            } else if manager.playerTurn == .player2 && manager.turnPhase == .move {
                                Text("Red Move Phase")
                                    .bold()
                                    .font(.system(size: 40))
                                    .foregroundStyle(Color.white)
                            } else if manager.playerTurn == .player2 && manager.turnPhase == .relocate {
                                Text("Red Relocate Phase")
                                    .bold()
                                    .font(.system(size: 40))
                                    .foregroundStyle(Color.white)
                            }
                        }
                        HStack {
                            Text("Red Score: \(manager.redSquareCount)")
                                .bold()
                                .font(.system(size: 40))
                                .foregroundStyle(Color.white)
                                .padding()
                            Spacer()
                            Text("Turns Left: \(manager.turn)")
                                .bold()
                                .font(.system(size: 40))
                                .foregroundStyle(Color.white)
                            Spacer()
                            Text("Blue Score: \(manager.blueSquareCount)")
                                .bold()
                                .font(.system(size: 40))
                                .foregroundStyle(Color.white)
                                .padding()
                        }
                    }
                    HStack {
                        Image("soldier")
                            .resizable()
                            .scaledToFit()
                            .padding()
                        VStack {
                            ForEach(0..<(magicNumber + 1), id:\.self) { row in
                                HStack {
                                    ForEach(0..<(magicNumber + 1), id: \.self) { column in
                                        BoardSquareMult(multmanager: $multmanager, manager: $manager, position: Position(row: row, column: column))
                                    }
                                }
                            }
                        }
                        VStack {
                            Image("soldier")
                                .resizable()
                                .scaledToFit()
                                .padding()
                            Button(action: {
                                if manager.playerTurn == manager.player && !manager.gameOver && multmanager.connected {
                                    manager.resetBoard()
                                    manager.skipPhase()
                                    multmanager.sendBoardAndPieces()
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(height: 70)
                                        .foregroundStyle(Color.blue)
                                    Text("Skip Phase")
                                        .foregroundStyle(Color.white)
                                        .bold()
                                        .font(.system(size: 40))
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    isSoundOn.toggle()
                    if isSoundOn {
                        audioPlayer?.play()
                    } else {
                        audioPlayer?.pause()
                    }
                }) {
                    Image(systemName: isSoundOn ? "speaker.wave.3.fill" : "speaker.slash.fill")
                }
                .padding(.trailing, 10)
                Button(action: {
                    manager.hardResetGame()
                    multmanager.sendBoardAndPieces()
                }) {
                    HStack {
                        Image(systemName: "shuffle")
                        Text("Reset Game")
                            .bold()
                            .font(.system(size: 40))
                    }
                }
            })
            .onAppear {
                setupAudioPlayer()
                if isSoundOn {
                    audioPlayer?.play()
                }
            }
            .onDisappear {
                multmanager.disconnect()
            }
        }
    }
}

#Preview {
    @Previewable @State var multmanager = MultiplayerGameManager()
    @Previewable @State var manager = MultiplayerGameManagerBoardTwo()
    @Previewable @State var player : Players = .player1
    MultiplayerBoardTwo(multmanager: $multmanager, manager: $manager, player: $player)
}
