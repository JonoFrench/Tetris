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
            HStack(alignment: .center) {
                ScreenView()
                    .frame(width: manager.assetDimension * 10,height: manager.assetDimension * 20)
                    .onTapGesture(count: 2) {
                        if manager.gameState == .playing {
                            manager.gameState = .paused
                        }
                    }
            }
            if let currentTetrominio = manager.currentTetrominio {
                TetrominoView(tetromino: currentTetrominio)
                    .zIndex(0.1)
            }
        }
    }
}

#Preview {
    GameView()
}
