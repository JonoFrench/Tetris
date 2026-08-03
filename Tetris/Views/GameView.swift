//
//  GameView.swift
//  Tetris
//
//  Created by Jonathan French on 29.11.25.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var manager: GameManager
    var body: some View {
        ZStack(alignment: .center) {
//            ZStack(alignment: .center) {
                ScreenView()
                    .frame(width: manager.assetDimension * 10,height: manager.assetDimension * 20)
                    .onTapGesture(count: 3) {
                        if manager.gameState == .playing {
                            manager.gameState = .paused
                        }
                    }
                //                    .border(.red)
                
                if let currentTetrominio = manager.currentTetrominio {
                    if manager.gameState == .playing {
                        ZStack {
                            TetrominoView(tetromino: currentTetrominio)
                                .zIndex(0.1)
                        }
                    }
                }
//            }
        }.onReceive(NotificationCenter.default.publisher(
            for: UIScene.willEnterForegroundNotification)) { _ in
                manager.gameState = .paused
        }
    }
}

#Preview {
    GameView()
}
