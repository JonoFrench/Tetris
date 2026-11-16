//
//  IntroBackView.swift
//  Tetris
//
//  Created by Jonathan French on 15.11.26.
//

import SwiftUI


struct IntroBackView: View {

    @AppStorage("introBackgroundNumber") private var backgroundNumber = 0

    var backgroundImage: String {
        "background\(backgroundNumber)"
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Image(backgroundImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: proxy.size.width * 0.75)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .id(backgroundNumber)
                    .transition(.opacity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.easeInOut(duration: 1.2), value: backgroundNumber)
            .onAppear {
                backgroundNumber = (backgroundNumber % GameConstants.Game.backgrounds) + 1
            }
        }
    }
}

#Preview {
    IntroBackView()
}

