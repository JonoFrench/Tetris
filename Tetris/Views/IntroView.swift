//
//  IntroView.swift
//  Tetris
//
//  Created by Jonathan French on 30.11.25.
//


import SwiftUI
import Combine

struct IntroView: View {
    static var starttextSize:CGFloat = 28
    static var helptextSize:CGFloat = 14
    @EnvironmentObject var manager: GameManager
//    @State private var currentIndex = 0
    private let numberOfViews = 1
    private let pages:[AnyView] = [
        AnyView(Intro1View()),
        AnyView(Intro2View()),
        AnyView(Intro3View())
    ]
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
//                Spacer()
                Image("LogoTetroids")
                    .resizable()
                    .scaledToFit()
                    .frame(width: (proxy.size.width / 4) * 3)
//                Spacer()
                SmoothCarousel(pages: [
                    AnyView(Intro1View()),
                    AnyView(Intro2View()),
                    AnyView(Intro3View())
                ])
                Spacer()
                PlayButton(btnTxt: "TAP TO PLAY") {
                    if manager.gameState == .intro {
                        manager.startGame()
                    }
                }
                Spacer()
            }.onTapGesture {
                if manager.gameState == .intro {
                    manager.startGame()
                }
            }
            .onAppear {
                print("game size \(proxy.size)")
                manager.gameSize = proxy.size
                manager.setInit()
            }.background(.clear)
                .frame(maxWidth: .infinity)
        }
    }
}
