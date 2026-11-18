//
//  GameView.swift
//  Tetris
//
//  Created by Jonathan French on 29.11.25.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var manager: GameManager
    @State private var currentBackground = "background1"
    @State private var previousBackground: String?
//    var backgroundImage: String {
//        "background\(manager.level % GameConstants.Game.backgrounds)"
//    }
    var body: some View {
        ZStack(alignment: .center) {
            ScreenView()
                .frame(width: manager.assetDimension * 10,height: manager.assetDimension * 20)
            if let currentTetrominio = manager.currentTetrominio {
                if manager.gameState == .playing {
                    ZStack {
                        TetrominoView(tetromino: currentTetrominio)
                            .zIndex(0.1)
                    }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 1.0)
                            .fill(.clear)
                    }
                }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 1.0)
                        .fill(.clear)
                }
            }
        }.background {
            ZStack {
                if let previousBackground {
                    Image(previousBackground)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }

                Image(currentBackground)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
            .clipped()
        }
        .onChange(of: manager.level) { oldValue, newValue in
            changeBackground(to: (newValue % GameConstants.Game.backgrounds) + 1)
        }
        .onReceive(NotificationCenter.default.publisher(
            for: UIScene.willEnterForegroundNotification)) { _ in
                manager.gameState = .paused
            }
    }
    
    func changeBackground(to number: Int) {
        let newBackground = "background\(number)"

        previousBackground = currentBackground

        withAnimation(.easeInOut(duration: 1.2)) {
            currentBackground = newBackground
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            previousBackground = nil
        }
    }
}

#Preview {
    GameView()
}
