//
//  TetroidView.swift
//  Tetris
//
//  Created by Jonathan French on 18.07.26.
//

import SwiftUI

struct TetroidView: View {
    @EnvironmentObject var manager: GameManager
    var message: String
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text(message)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(manager.grad)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.5)) {
                            scale = 3.0
                            opacity = 0.2
                        }
                    }
                Spacer()
            }
        }
    }
}

#Preview {
    TetroidView(message: "test")
}
