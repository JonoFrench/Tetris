//
//  GameView.swift
//  Tetris
//
//  Created by Jonathan French on 29.11.25.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var manager: GameManager
    var backgroundImage: String {
        "background\(manager.level % GameConstants.Game.backgrounds)"
    }
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
        }.onReceive(NotificationCenter.default.publisher(
            for: UIScene.willEnterForegroundNotification)) { _ in
                manager.gameState = .paused
            }
        .background {
                ZStack {
                    ForEach(1...GameConstants.Game.backgrounds, id: \.self) { index in
                        Image("background\(index)")
                            .resizable()
                            .scaledToFit()
                            .opacity(backgroundImage == "background\(index)" ? 1 : 0)
                            .frame(maxWidth: .infinity)
                    }
                }
                .animation(.easeInOut(duration: 1.2), value: backgroundImage)
                .clipped()
            }
    }
}

#Preview {
    GameView()
}
