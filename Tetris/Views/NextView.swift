//
//  NextView.swift
//  Tetris
//
//  Created by Jonathan French on 5.12.25.
//

import SwiftUI

struct NextView: View {
    @EnvironmentObject var manager: GameManager
    @State private var displayedImage: ImageResource?
    @State private var scale: CGFloat = 1.0
    var next:ImageResource?
    var body: some View {
        VStack {
            Spacer()
            Text("NEXT")
                .font(.custom("HelveticaNeue", size: 20 * manager.deviceMulti))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity,maxHeight: 20)
                .multilineTextAlignment(.center)
            if let displayedImage {
                Image(displayedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80 * manager.deviceMulti, height: 80 * manager.deviceMulti)
                    .scaleEffect(scale)
            }
        }
        .onAppear {
            displayedImage = next
        }
        .onChange(of: next) { _, newValue in
            Task {
                await animateImageChange(to: newValue)
            }
        }
        .onTapGesture {
            /// dont drop if we're too close
            if let currentTetrominio = manager.currentTetrominio {
                if (currentTetrominio.checkBoard()) {
                    manager.currentTetrominio?.dropMove = true
                }
            }
        }
    }
    
    @MainActor
    private func animateImageChange(to newImage: ImageResource?) async {
        withAnimation(.easeIn(duration: 0.2)) {
            scale = 0.0
        }
        try? await Task.sleep(nanoseconds: 200_000_000)
        displayedImage = newImage
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            scale = 1.0
        }
    }
}
