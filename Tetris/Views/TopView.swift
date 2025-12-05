//
//  TopView.swift
//  Tetris
//
//  Created by Jonathan French on 29.11.25.
//

import SwiftUI

struct TopView: View {
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Color(.clear)
                Text("Score:\(String(format: "%07d", 7)) Top:\(String(format: "%07d", 0))")
                    .font(.custom("DonkeyKongClassicsNESExtended", size: 14))
                    .foregroundStyle(.white)
                Spacer()
                Text("Level:\(String(format: "%03d", 0)) Lines:\(String(format: "%04d", 4))")
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
