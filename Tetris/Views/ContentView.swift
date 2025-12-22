//
//  ContentView.swift
//  Tetris
//
//  Created by Jonathan French on 28.11.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var manager: GameManager
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.black)
            VStack(spacing: 0) {
                TopView()
                    .frame(width: UIScreen.main.bounds.width,height: 60, alignment: .center)
                    .zIndex(0.1)
                    .background(.black)
                if manager.gameState == .intro {
                    IntroView().background(.black)
                } else {
                    GameView()
                }
                if manager.gameState != .intro {
                    ButtonView()
                        .frame(width: UIScreen.main.bounds.width,height: 120, alignment: .center)
                        .zIndex(0.1)
                        .background(.black)
                } else {
                    ZStack {
                        Spacer()
                        Text("Tap to Play")
                            .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize))
                            .foregroundStyle(.orange)
                            .frame(width: UIScreen.main.bounds.width,height: 120, alignment: .center)
                            .zIndex(0.1)
                            .background(.black)
                            .onTapGesture {
                                if manager.gameState == .intro {
                                    manager.startGame()
                                }
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    let previewEnvObject = GameManager()
    return ContentView()
        .modelContainer(for: GameScore.self, inMemory: true)
        .environmentObject(previewEnvObject)
}
