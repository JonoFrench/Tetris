//
//  TetrominoView.swift
//  Tetris
//
//  Created by Jonathan French on 2.12.25.
//

import SwiftUI

struct TetrominoView: View {
    @EnvironmentObject var manager: GameManager
    @ObservedObject var tetromino: Tetromino
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ForEach(0..<4) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<4) { col in
                            let col = tetromino.tetrominioArray[row][col]
                            ZStack {
                                if let col {
                                    Rectangle()
                                        .fill(col)
                                        .border(.black)
                                }
                            }
                            .frame(width: manager.assetDimension, height: manager.assetDimension)
                        }
                    }
                }
            }.position(x:tetromino.position.x,y: tetromino.position.y)
        }.zIndex(0.1)
    }
}

//#Preview {
//    TetrominoView()
//}
