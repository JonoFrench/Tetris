//
//  PlayButton.swift
//  Tetris
//
//  Created by Jonathan French on 23.03.26.
//


import SwiftUI

struct PlayButton: View {
    @EnvironmentObject var manager: GameManager
    @State private var isPressed = false
    var btnTxt:String
    var action: () -> Void
    var body: some View {
        Button(action:
                {
            print(btnTxt)
            action()
//            if manager.gameState == .intro {
//                manager.startGame()
//            }
        }) {
            Text(btnTxt)
                .font(.custom("HelveticaNeue", size: IntroView.starttextSize * manager.deviceMulti))
                //.font(.system(size: 28, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .padding(.vertical, 18)
                .padding(.horizontal, 40)
                .background(
                    LinearGradient(
                        colors: [
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
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.8), lineWidth: 3)
                )
                .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 6)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}
