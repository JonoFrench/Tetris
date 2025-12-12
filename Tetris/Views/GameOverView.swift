//
//  GameOverView.swift
//  Tetris
//
//  Created by Jonathan French on 11.12.25.
//

import SwiftUI

struct GameOverView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
            VStack {
                Spacer()
                Text("Game Over")
                    .font(.custom("DonkeyKongClassicsNESExtended", size: 18))
                    .foregroundStyle(.white)
                Spacer()
                Text("Tap to Continue")
                    .font(.custom("DonkeyKongClassicsNESExtended", size: 18))
                    .foregroundStyle(.white)
                Spacer()
            }
        }.zIndex(1.0)
    }}

#Preview {
    GameOverView()
}
