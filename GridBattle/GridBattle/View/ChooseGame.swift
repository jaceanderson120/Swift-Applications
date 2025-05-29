//
//  ChooseGame.swift
//  GridBattle
//
//  Created by Jace Anderson on 11/3/24.
//

import SwiftUI

struct ChooseGame: View {
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
                    NavigationLink(destination: ChooseBoard(gameType: .computer)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(height: 75)
                                .foregroundStyle(Color.blue)
                            Text("Player Vs Computer")
                                .foregroundStyle(Color.white)
                                .bold()
                                .font(.system(size: 40))
                        }
                    }
                    .padding()
                    NavigationLink(destination: ChooseBoard(gameType: .local)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(height: 75)
                                .foregroundStyle(Color.blue)
                            Text("Player Vs Player (Same Device)")
                                .foregroundStyle(Color.white)
                                .bold()
                                .font(.system(size: 40))
                        }
                    }
                    .padding()
                    NavigationLink(destination: ChooseBoard(gameType: .multiplayer)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(height: 75)
                                .foregroundStyle(Color.blue)
                            Text("Player Vs Player (Local Network)")
                                .foregroundStyle(Color.white)
                                .bold()
                                .font(.system(size: 40))
                        }
                    }
                    .padding()
                    Image("tank")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
}

#Preview {
    ChooseGame()
}
