//
//  GameOverView.swift
//  Tetris
//
//  Created by Jonathan French on 11.12.25.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var manager: GameManager
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
            VStack(alignment: .center) {
                Spacer()
                Text("Game Over")
                    .font(.custom("HelveticaNeue", size: 36 * manager.deviceMulti))
                    .foregroundStyle(.red)
                Spacer()
                Text("Tap to")
                    .font(.custom("HelveticaNeue", size: 28 * manager.deviceMulti ))
                    .foregroundStyle(.white)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                Text("Continue")
                    .font(.custom("HelveticaNeue", size: 28 * manager.deviceMulti))
                    .foregroundStyle(.white)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()
            }
        }.zIndex(1.0)
    }}

#Preview {
    GameOverView()
}
