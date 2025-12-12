//
//  OverlayView.swift
//  Tetris
//
//  Created by Jonathan French on 5.12.25.
//

import SwiftUI

struct OverlayView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
            Text("Paused")
                .font(.custom("DonkeyKongClassicsNESExtended", size: 18))
                .foregroundStyle(.white)
            
        }.zIndex(1.0)
    }
}
#Preview {
    OverlayView()
}
