//
//  ButtonView.swift
//  Tetris
//
//  Created by Jonathan French on 4.12.25.
//

import SwiftUI
import SwiftData

struct ButtonView: View {
    @EnvironmentObject var manager: GameManager
    @Environment(\.modelContext) private var context
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.red)
                        .frame(width: 100 * manager.deviceMulti, height: 50 * manager.deviceMulti)
                        .overlay(content: {
                            Image("LeftArrow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50 * manager.deviceMulti)
                        })
                        .onTapGesture {
                            if manager.gameState == .playing {
                                print("Single tap - move")
                                manager.currentTetrominio?.moveLeft()
                            } else if manager.gameState == .highscore {
                                manager.letterDown()
                            }
                        }
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.yellow)
                        .frame(width: 100 * manager.deviceMulti, height: 50 * manager.deviceMulti)
                        .overlay(content: {
                            Image("RotateL")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30 * manager.deviceMulti)
                        })
                        .onTapGesture {
                            if manager.gameState == .playing {
                                print("Single tap - rotate")
                                manager.rotateL()
                            }
                        }
                }
                Spacer()
                if manager.gameState == .highscore {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.red)
                        .frame(width: 100 * manager.deviceMulti, height: 50 * manager.deviceMulti)
                        .overlay(content: {
                            Text("NEXT")
                                .font(.custom("DonkeyKongClassicsNESExtended", size: 12 * manager.deviceMulti))
                                .foregroundStyle(.white)
                        })
                        .onTapGesture {
                            nextLetter()
                        }
                    
                } else if let nextTetrominio = manager.nextTetrominio {
                    let nextResource = ImageResource(name: "\(nextTetrominio.kind)tetromino", bundle: .main)
                    NextView(next:nextResource)
                }
                
                Spacer()
                VStack {
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.red)
                        .frame(width: 100 * manager.deviceMulti, height: 50 * manager.deviceMulti)
                        .overlay(content: {
                            Image("RightArrow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50 * manager.deviceMulti)
                        })
                        .onTapGesture {
                            if manager.gameState == .playing {
                                print("Single tap - move")
                                manager.currentTetrominio?.moveRight()
                            } else if manager.gameState == .highscore {
                                manager.letterUp()
                            }
                        }
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.yellow)
                        .frame(width: 100 * manager.deviceMulti, height: 50 * manager.deviceMulti)
                        .overlay(content: {
                            Image("RotateR")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30 * manager.deviceMulti)
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
    
    func nextLetter() {
        manager.letterIndex += 1
        manager.selectedLetter = 0
        /// Final letter and store it
        if manager.letterIndex == 3 {
            let score = GameScore(
                timestamp: .now,
                rows: manager.lines,
                score: manager.score,
                level: manager.level,
                name:String(manager.letterArray)
            )
            context.insert(score)
            try? context.save()
            manager.gameState = .intro
        }
    }
}

#Preview {
    ButtonView()
}
