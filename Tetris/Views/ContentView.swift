//
//  ContentView.swift
//  Tetris
//
//  Created by Jonathan French on 28.11.25.
//

import SwiftUI
import SwiftData
import StoreKit

struct ContentView: View {
    @EnvironmentObject var manager: GameManager
    @Environment(\.modelContext) private var context

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color.black],
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea()
            
            if manager.gameState == .intro {
                IntroView()
            } else {
                VStack {
                    TopView()
                        .frame(maxWidth: .infinity)
                        .frame(height: manager.topHeight)
                        .background(.clear)
                    GameView()
                        .clipped()
                        .overlay {
                            overlayView
                        }
                    ButtonView()
                        .frame(maxWidth: .infinity)
                        .frame(height: manager.buttonHeight)
                        .background(.clear)
                }
            }
        }
        .statusBar(hidden: true)
        .onAppear {
            manager.context = context
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        /// 4 Lines removed show Tetroid!
                if manager.showTetroid {
                    TetroidView(message: "Tetroid!")
                }
        /// All Lines removed show Tetroid!
                if manager.showEmpty {
                    TetroidView(message: "Clear Grid! \n100000")
                }
        switch manager.gameState {
        case .playing:
            StarBurstView(trigger: 0)
                .zIndex(0.1)
            StarBurstView(trigger: 0)
                .zIndex(0.1)
            StarBurstView(trigger: 0)
                .zIndex(0.1)
        case .gameending:
            RoundedRectangle(cornerRadius: 10.0)
                .fill(.clear)

            TetroidView(message: "Game Over")
        case .paused:
            OverlayView()
        case .gameover:
            GameOverView()
                .onTapGesture {
                    manager.gameState = .intro
                }
        case .highscore:
            NewHighScoreView()
        default:
            EmptyView()
        }
    }
}

#Preview {
    let previewEnvObject = GameManager()
    return ContentView()
        .modelContainer(for: GameScore.self, inMemory: true)
        .environmentObject(previewEnvObject)
}
