//
//  IntroView.swift
//  Tetris
//
//  Created by Jonathan French on 30.11.25.
//


import SwiftUI
import Combine

struct IntroView: View {
    static var starttextSize:CGFloat = 14
    static var helptextSize:CGFloat = 9
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
                Spacer()
                Image("Logo2")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                Spacer()
                SmoothCarousel(pages: [
                    AnyView(Intro1View()),
                    AnyView(Intro2View()),
                    AnyView(Intro3View())
                ])
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
