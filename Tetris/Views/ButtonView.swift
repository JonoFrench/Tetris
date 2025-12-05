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
                Circle()
                    .fill(
                        RadialGradient(gradient: Gradient(colors: [.blue,.yellow, .red]), center: .center, startRadius: 5, endRadius: 50)
                    )
                    .stroke(.red, lineWidth: 2)
                    .frame(width: 100, height: 100)
                    .onTapGesture {
                        if manager.gameState == .playing {
                            print("Single tap - move")
                            manager.currentTetrominio?.moveLeft()
                        }
                    }
                    .onTapGesture(count: 2, perform: {
                        print("Double tap - rotate")
                        if manager.gameState == .playing {
                            manager.currentTetrominio?.rotateL()
                        }
                    })
                    .onLongPressGesture(minimumDuration: 0.1){
                        if manager.gameState == .intro {
                            manager.startGame()
                        } else if manager.gameState == .playing {
                            //                            manager.throwBall()
                        } else if manager.gameState == .highscore {
                            //                            manager.hiScores.nextLetter()
                        }
                    }
                Spacer()
                if let nextTetrominio = manager.nextTetrominio?.tetrominioArray {
                    NextView(shape:nextTetrominio )
                }
                Spacer()
                Circle()
                    .fill(
                        RadialGradient(gradient: Gradient(colors: [.blue,.yellow, .red]), center: .center, startRadius: 5, endRadius: 50)
                    )
                    .stroke(.red, lineWidth: 2)
                    .frame(width: 100, height: 100)
                    .onTapGesture {
                        if manager.gameState == .playing {
                            print("Single tap - move")
                            manager.currentTetrominio?.moveRight()
                        }
                    }
                    .onTapGesture(count: 2, perform: {
                        print("Double tap - rotate")
                        if manager.gameState == .playing {
                            manager.currentTetrominio?.rotateR()
                        }
                    })
                    .onLongPressGesture(minimumDuration: 0.1){
                        if manager.gameState == .intro {
                            manager.startGame()
                        } else if manager.gameState == .playing {
                            //                            manager.throwBall()
                        } else if manager.gameState == .highscore {
                            //                            manager.hiScores.nextLetter()
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
