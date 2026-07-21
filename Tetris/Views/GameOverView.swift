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
                    .font(.custom("HelveticaNeue", size: 40 * manager.deviceMulti).bold())
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color.red,
                                Color.pink,
                                Color.orange,
                                Color.yellow,
                                Color.green,
                                Color.blue
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Spacer()
                Text("Tap to")
                    .font(.custom("HelveticaNeue", size: 32 * manager.deviceMulti ).bold())
                    .foregroundStyle(manager.gradOtoY)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                Text("Continue")
                    .font(.custom("HelveticaNeue", size: 32 * manager.deviceMulti).bold())
                    .foregroundStyle(manager.gradOtoY)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()
            }
        }.zIndex(1.0)
    }}

#Preview {
    GameOverView()
}
