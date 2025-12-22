//
//  SmoothCarousel.swift
//  Tetris
//
//  Created by Jonathan French on 12.12.25.
//

import SwiftUI
import Combine

struct SmoothCarousel: View {
    let pages: [AnyView]
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            pages[currentIndex]
                .transition(.opacity)
                .id(currentIndex)
        }
        .animation(.easeInOut(duration: 1.0), value: currentIndex)
        .onReceive(
            Timer.publish(every: 4.0, on: .main, in: .common).autoconnect()
        ) { _ in
            currentIndex = (currentIndex + 1) % pages.count
        }
    }
}
