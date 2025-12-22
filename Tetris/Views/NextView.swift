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
            Text("NEXT")
                .font(.custom("DonkeyKongClassicsNESExtended", size: 12))
                .foregroundStyle(.white)
            if let displayedImage {
                Image(displayedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
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
            manager.currentTetrominio?.dropMove = true
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
