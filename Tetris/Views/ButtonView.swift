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
                }
                Spacer()
                if let nextTetrominio = manager.nextTetrominio {
                    let nextResource = ImageResource(name: "\(nextTetrominio.kind)tetromino", bundle: .main)
                    NextView(next:nextResource)
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
                Spacer()
            }
        }.background(.black)
    }
}

#Preview {
    ButtonView()
}
