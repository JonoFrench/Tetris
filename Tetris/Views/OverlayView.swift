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
                 PlayButton(btnTxt: "Resume") {
                    manager.gameState = .playing
                }
                Spacer()
 
                Text("Paused")
                    .font(.custom("DonkeyKongClassicsNESExtended", size: 18))
                    .foregroundStyle(.white)
                Spacer()
                PlayButton(btnTxt: "Quit") {
                    manager.currentTetrominio = nil
                   manager.gameState = .gameover
               }
               Spacer()

            }
        }.zIndex(1.0)
    }
}
#Preview {
    OverlayView()
}
