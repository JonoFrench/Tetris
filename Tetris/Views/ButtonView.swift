//
//  ButtonView.swift
//  Tetris
//
//  Created by Jonathan French on 4.12.25.
//

import SwiftUI

struct ButtonView: View {
    @EnvironmentObject var manager: GameManager
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    
                    RoundedRectangle(cornerRadius: 25)
                          .fill(.red)
                          .frame(width: 100, height: 50)
                          .overlay(content: {
                              Image("LeftArrow")
                                  .resizable()
                                  .scaledToFit()
                                  .frame(width: 50)
                          })

                          .onTapGesture {
                              if manager.gameState == .playing {
                                  print("Single tap - move")
                                  manager.currentTetrominio?.moveLeft()
                              }
                          }
                    RoundedRectangle(cornerRadius: 25)
                          .fill(.yellow)
                          .frame(width: 100, height: 50)
                          .overlay(content: {
                              Image("RotateL")
                                  .resizable()
                                  .scaledToFit()
                                  .frame(width: 30)
                          })
                          .onTapGesture {
                              if manager.gameState == .playing {
                                  print("Single tap - rotate")
                                  manager.rotateL()
                              }
                          }

//                    Circle()
//                        .fill(
//                            RadialGradient(gradient: Gradient(colors: [.blue,.yellow, .red]), center: .center, startRadius: 5, endRadius: 50)
//                        )
//                        .stroke(.red, lineWidth: 2)
//                        .frame(width: 100, height: 100)
//                        .onTapGesture {
//                            if manager.gameState == .playing {
//                                print("Single tap - move")
//                                manager.currentTetrominio?.moveLeft()
//                            }
//                        }
//                        .onTapGesture(count: 2, perform: {
//                            print("Double tap - rotate")
//                            if manager.gameState == .playing {
//                                manager.rotateL()
//                            }
//                        })
//                        .onLongPressGesture(minimumDuration: 0.1){
//                            if manager.gameState == .intro {
//                                manager.startGame()
//                            } else if manager.gameState == .playing {
//                                //                            manager.throwBall()
//                            } else if manager.gameState == .highscore {
//                                //                            manager.hiScores.nextLetter()
//                            }
//                        }
                }
                Spacer()
                if let nextTetrominio = manager.nextTetrominio?.tetrominioArray {
                    NextView(shape:nextTetrominio )
                }
                Spacer()
                VStack {
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.red)
                        .frame(width: 100, height: 50)
                        .overlay(content: {
                            Image("RightArrow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                        })
                        .onTapGesture {
                            if manager.gameState == .playing {
                                print("Single tap - move")
                                manager.currentTetrominio?.moveRight()
                            }
                        }
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.yellow)
                        .frame(width: 100, height: 50)
                        .overlay(content: {
                            Image("RotateR")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                        })
                        .onTapGesture {
                            if manager.gameState == .playing {
                                print("Single tap - rotate")
                                manager.rotateR()
                            }
                        }
                }
//                Circle()
//                    .fill(
//                        RadialGradient(gradient: Gradient(colors: [.blue,.yellow, .red]), center: .center, startRadius: 5, endRadius: 50)
//                    )
//                    .stroke(.red, lineWidth: 2)
//                    .frame(width: 100, height: 100)
//                    .onTapGesture {
//                        if manager.gameState == .playing {
//                            print("Single tap - move")
//                            manager.currentTetrominio?.moveRight()
//                        }
//                    }
//                    .onTapGesture(count: 2, perform: {
//                        print("Double tap - rotate")
//                        if manager.gameState == .playing {
//                            manager.rotateR()
//                        }
//                    })
//                    .onLongPressGesture(minimumDuration: 0.1){
//                        if manager.gameState == .intro {
//                            manager.startGame()
//                        } else if manager.gameState == .playing {
//                            //                            manager.throwBall()
//                        } else if manager.gameState == .highscore {
//                            //                            manager.hiScores.nextLetter()
//                        }
//                    }
                Spacer()
                
            }
        }.background(.black)
    }
}

#Preview {
    ButtonView()
}
