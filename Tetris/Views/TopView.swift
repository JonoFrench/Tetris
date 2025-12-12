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
            VStack {
                Color(.clear)
                Text("Score:\(String(format: "%07d", manager.score))")
                    .font(.custom("DonkeyKongClassicsNESExtended", size: 14))
                    .foregroundStyle(.white)
                Spacer()
                Text("Level:\(String(format: "%03d", manager.level)) Lines:\(String(format: "%04d", manager.lines))")
                    .font(.custom("DonkeyKongClassicsNESExtended", size: 14))
                    .foregroundStyle(.white)
                Spacer()
            }
        }
    }
}

#Preview {
    TopView()
}
