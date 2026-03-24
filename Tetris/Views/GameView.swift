//
//  GameView.swift
//  Tetris
//
//  Created by Jonathan French on 29.11.25.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var manager: GameManager
    var body: some View {
        ZStack(alignment: .center) {
            HStack(alignment: .center) {
                    ScreenView()
                    .overlay() {
                        if manager.gameState == .paused {
                            OverlayView()
                                .onTapGesture {
                                    manager.gameState = .playing
                                }
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

                    }.onTapGesture {
                        if manager.gameState == .playing {
                            manager.gameState = .paused
                        }
                    }
                    VStack(alignment: .center,spacing: 2) {
                        Text("Stats")
                            .font(.custom("DonkeyKongClassicsNESExtended", size: 8 * manager.deviceMulti))
                            .foregroundStyle(.white)
                        CountView(counter: manager.tetroCounters[0], img: ImageResource(name: "Itetromino", bundle: .main))
                        CountView(counter: manager.tetroCounters[1], img: ImageResource(name: "Otetromino", bundle: .main))
                        CountView(counter: manager.tetroCounters[2], img: ImageResource(name: "Stetromino", bundle: .main))
                        CountView(counter: manager.tetroCounters[3], img: ImageResource(name: "Ztetromino", bundle: .main))
                        CountView(counter: manager.tetroCounters[4], img: ImageResource(name: "Ttetromino", bundle: .main))
                        CountView(counter: manager.tetroCounters[5], img: ImageResource(name: "Jtetromino", bundle: .main))
                        CountView(counter: manager.tetroCounters[6], img: ImageResource(name: "Ltetromino", bundle: .main))
                    }.frame(width: manager.deviceType == .iPad ? 100 : 80 * manager.deviceMulti)
                }
                            if let currentTetrominio = manager.currentTetrominio {
                                TetrominoView(manager: _manager, tetromino: currentTetrominio)
                                    .zIndex(0.5)
                            }
            }
        }
}

#Preview {
    GameView()
}
