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
                    
                    Image("btn_left")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 100 * manager.deviceMulti,
                            height: 50 * manager.deviceMulti
                        ).onTapGesture {
                            if manager.gameState == .playing {
                                print("Single tap - move")
                                manager.currentTetrominio?.moveLeft()
                            } else if manager.gameState == .highscore {
                                manager.letterDown()
                            }
                        }
                    
                    Image("btn_rotate_left")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 100 * manager.deviceMulti,
                            height: 50 * manager.deviceMulti
                        ).onTapGesture {
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
                        .stroke(.white, lineWidth: 2)
                        .frame(width: 100 * manager.deviceMulti, height: 50 * manager.deviceMulti)
                        .overlay(content: {
                            Text("NEXT")
                                .font(.custom("HelveticaNeue", size: 12 * manager.deviceMulti))
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
                    
                    Image("btn_right")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 100 * manager.deviceMulti,
                            height: 50 * manager.deviceMulti
                        ).onTapGesture {
                            if manager.gameState == .playing {
                                print("Single tap - move")
                                manager.currentTetrominio?.moveRight()
                            } else if manager.gameState == .highscore {
                                manager.letterUp()
                            }
                        }
                    Image("btn_rotate_right")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 100 * manager.deviceMulti,
                            height: 50 * manager.deviceMulti
                        ).onTapGesture {
                            if manager.gameState == .playing {
                                print("Single tap - rotate")
                                manager.rotateR()
                            }
                        }
                }
                Spacer()
            }
        }.background(.clear)
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
