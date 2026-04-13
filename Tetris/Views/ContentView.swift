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
    @Environment(\.modelContext) private var context

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color.blue.opacity(0.8)],
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea()

            if manager.gameState == .intro {
                IntroView()
            } else {
                GameView()
                    .clipped()
                    .overlay {
                        overlayView
                    }
                    .safeAreaInset(edge: .top, spacing: 0) {
                        TopView()
                            .frame(maxWidth: .infinity)
                            .frame(height: manager.topHeight)
                            .background(.clear)
                    }
                    .safeAreaInset(edge: .bottom, spacing: 0) {
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
        switch manager.gameState {
        case .paused:
            OverlayView()

        case .gameover:
            GameOverView()
                .onTapGesture {
                    manager.gameState = .intro
                }

        case .highscore:
            NewHighScoreView()
                .background(.clear)

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
