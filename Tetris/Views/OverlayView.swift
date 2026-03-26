//
//  OverlayView.swift
//  Tetris
//
//  Created by Jonathan French on 5.12.25.
//

import SwiftUI

struct OverlayView: View {
    @EnvironmentObject var manager: GameManager
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
            VStack {
                Spacer()
                PlayButton(btnTxt: "Quit") {
                    manager.gameState = .gameending
                    manager.currentTetrominio = nil
                    Task { @MainActor in
                        try? await Task.sleep(for: .seconds(1.0))
                        manager.soundFX.stopBackgroundSound()
                        manager.gameState = .gameover
                        manager.clearScreen()
                    }
                }
                Spacer()
                Text("Paused")
                    .font(.custom("DonkeyKongClassicsNESExtended", size: 18))
                    .foregroundStyle(.white)
                Spacer()
                PlayButton(btnTxt: "Resume") {
                    manager.gameState = .playing
                }
                Spacer()
            }
        }.zIndex(1.0)
    }
}
#Preview {
    OverlayView()
}
