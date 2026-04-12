//
//  TopView.swift
//  Tetris
//
//  Created by Jonathan French on 29.11.25.
//

import SwiftUI

struct TopView: View {
    @EnvironmentObject var manager: GameManager
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center, spacing: 2) {
                Color(.clear)
                Text("Score:\(String(format: "%07d", manager.score))")
                    .font(.custom("HelveticaNeue", size: 20 * manager.deviceMulti))
                    .foregroundStyle(manager.gameState != .intro ? .white : .clear)
                    .frame(maxWidth: .infinity,maxHeight: 40)
                    .multilineTextAlignment(.center)
                Spacer()
                Text("Level:\(String(format: "%02d", manager.level)) Lines:\(String(format: "%03d", manager.lines))")
                    .font(.custom("HelveticaNeue", size: 20 * manager.deviceMulti))
                    .foregroundStyle(manager.gameState != .intro ? .white : .clear)
                    .frame(maxWidth: .infinity,maxHeight: 40)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            
        }.background(.clear)
    }
}

#Preview {
    TopView()
}
