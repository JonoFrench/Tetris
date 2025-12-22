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
 //               ZStack(alignment: .center) {
                    ScreenView().overlay() {
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
                        }
                    }.onTapGesture {
                        if manager.gameState == .playing {
                            manager.gameState = .paused
                        }
                    }
                    //                VStack(alignment: .center) {
                    //                }.frame(width: 2)
                    VStack(alignment: .center) {
                        Text("Stats")
                            .font(.custom("DonkeyKongClassicsNESExtended", size: 8))
                            .foregroundStyle(.white)
                        CountView(counter: manager.tetroCounters[0], img: ImageResource(name: "Itetromino", bundle: .main))
                            .frame(width:70,height: 70)
                        CountView(counter: manager.tetroCounters[1], img: ImageResource(name: "Otetromino", bundle: .main))
                            .frame(width:70,height: 70)
                        CountView(counter: manager.tetroCounters[2], img: ImageResource(name: "Stetromino", bundle: .main))
                            .frame(width:70,height: 70)
                        CountView(counter: manager.tetroCounters[3], img: ImageResource(name: "Ztetromino", bundle: .main))
                            .frame(width:70,height: 70)
                        CountView(counter: manager.tetroCounters[4], img: ImageResource(name: "Ttetromino", bundle: .main))
                            .frame(width:70,height: 70)
                        CountView(counter: manager.tetroCounters[5], img: ImageResource(name: "Jtetromino", bundle: .main))
                            .frame(width:70,height: 70)
                        CountView(counter: manager.tetroCounters[6], img: ImageResource(name: "Ltetromino", bundle: .main))
                            .frame(width:70,height: 70)
                        
                        //                    CountView(counter: manager.tetroCounters[0], shape: manager.irot)
                        //                        .frame(width:80,height: 70)
                        //                    CountView(counter: manager.tetroCounters[1], shape: manager.oTetrominio)
                        //                        .frame(width:80,height: 70)
                        //                    CountView(counter: manager.tetroCounters[2], shape: manager.srot)
                        //                        .frame(width:80,height: 70)
                        //                    CountView(counter: manager.tetroCounters[3], shape: manager.zrot)
                        //                        .frame(width:80,height: 70)
                        //                    CountView(counter: manager.tetroCounters[4], shape: manager.trot)
                        //                        .frame(width:80,height: 70)
                        //                    CountView(counter: manager.tetroCounters[5], shape: manager.jTetrominio)
                        //                        .frame(width:80,height: 70)
                        //                    CountView(counter: manager.tetroCounters[6], shape: manager.lTetrominio)
                        //                        .frame(width:80,height: 70)
                    }.background(.black)
                        .frame(width: 80)
                }
                            if let currentTetrominio = manager.currentTetrominio {
                                TetrominoView(manager: _manager, tetromino: currentTetrominio)
                                    .zIndex(0.5)
                            }
            }//.zIndex(0.1).background(.black.gradient)
            //   .position(x: UIScreen.main.bounds.width / 2, y:284)
        }
 //   }
}

#Preview {
    GameView()
}
