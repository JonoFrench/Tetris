//
//  ContentView.swift
//  Tetris
//
//  Created by Jonathan French on 28.11.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var manager: GameManager
    @Environment(\.modelContext) private var context
    func startGame() {
        if manager.gameState == .intro {
            manager.startGame()
        }
    }
    var body: some View {
        ZStack(alignment: .top) {
//            Color(.black).ignoresSafeArea() ///back2black
            LinearGradient(
                colors: [Color.black,Color.blue.opacity(0.8)],
                startPoint: .bottom,
                endPoint: .top
            ).ignoresSafeArea()

                .statusBar(hidden: true)
            VStack(spacing: 0) {
                Spacer()
                TopView()
                    .frame(width: UIScreen.main.bounds.width,height: manager.topHeight, alignment: .center)
                    .zIndex(0.1)
                    .background(manager.gameState == .intro ? .clear : .clear)
                if manager.gameState == .intro {
                    IntroView().background(.clear)
                } else {
                    GameView()
//                        .background(.blue)
                        .clipped()
                        .overlay() {
                            //background(.blue)
                            if manager.gameState == .paused {
                                OverlayView()
                            } else if manager.gameState == .gameover {
                                GameOverView()
                                    .onTapGesture {
                                        manager.gameState = .intro
                                    }
                            }  else if manager.gameState == .highscore {
                                NewHighScoreView()
                                    .background(.clear)
                                    .zIndex(1.0)
                            }
                        }
                }
                if manager.gameState != .intro {
                    ButtonView()
                        .frame(width: UIScreen.main.bounds.width,height: manager.buttonHeight, alignment: .center)
                        .zIndex(0.1)
                        .background(.clear)
                } else {
                    Spacer()
                    PlayButton(btnTxt: "TAP TO PLAY") {
                        if manager.gameState == .intro {
                            manager.startGame()
                        }
                    }
                    Spacer()
                }
            }
        }.onAppear{
            manager.context = context
        }
    }
}

#Preview {
    let previewEnvObject = GameManager()
    return ContentView()
        .modelContainer(for: GameScore.self, inMemory: true)
        .environmentObject(previewEnvObject)
}
