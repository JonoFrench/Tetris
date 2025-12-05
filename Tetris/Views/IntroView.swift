//
//  IntroView.swift
//  Tetris
//
//  Created by Jonathan French on 30.11.25.
//


import SwiftUI

struct IntroView: View {
    static var starttextSize:CGFloat = 14
    @EnvironmentObject var manager: GameManager
    @State private var currentIndex = 0
    private let numberOfViews = 1
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                Spacer()
                Image("Logo2")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                //Text("Tetris").font(.largeTitle) .foregroundStyle(.white.gradient)
                Spacer()
                Text("iOS SwiftUI Version")
                    .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize))
                    .foregroundStyle(.white)
                Spacer()
                Text("Jonathan French 2025")
                    .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize))
                    .foregroundStyle(.white)
                Spacer()
                Text("Tap to Play")
                    .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize))
                    .foregroundStyle(.white)
                    .onTapGesture {
                        if manager.gameState == .intro {
                            manager.startGame()
                        }
                    }
                Spacer()
            }
            .onAppear {
                print("tetris game size \(proxy.size)")
                manager.gameSize = proxy.size
                manager.setInit()
            }.background(.clear)
                .frame(maxWidth: .infinity)

        }
    }
}
