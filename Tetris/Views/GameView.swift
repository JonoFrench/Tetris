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
        var irot = manager.iTetrominio
        var srot = manager.sTetrominio
        var zrot = manager.zTetrominio
        var trot = manager.tTetrominio
        let _ = manager.rotateTetrominoL(&irot)
        let _ = manager.rotateTetrominoL(&srot)
        let _ = manager.rotateTetrominoL(&zrot)
        let _ = manager.rotateTetrominoL(&trot)

        ZStack(alignment: .center) {
            HStack(alignment: .center) {
                ScreenView()
                VStack(alignment: .center) {
                    
                }.background(.black)
                    .frame(width: 2,height: 300)
                    .zIndex(0.1)
                VStack(alignment: .center) {
                    Text("Stats")
                        .font(.custom("DonkeyKongClassicsNESExtended", size: 10))
                        .foregroundStyle(.white)

                    CountView(counter: manager.iCount, shape: irot)
                        .frame(width:80,height: 80)
                    CountView(counter: manager.oCount, shape: manager.oTetrominio)
                        .frame(width:80,height: 80)
                    CountView(counter: manager.sCount, shape: srot)
                        .frame(width:80,height: 80)
                    CountView(counter: manager.zCount, shape: zrot)
                        .frame(width:80,height: 80)
                    CountView(counter: manager.tCount, shape: trot)
                        .frame(width:80,height: 80)
                    CountView(counter: manager.jCount, shape: manager.jTetrominio)
                        .frame(width:80,height: 80)
                    CountView(counter: manager.lCount, shape: manager.lTetrominio)
                        .frame(width:80,height: 80)
                }.background(.black)
                    .frame(width: 60,height: 300).zIndex(10)
                    .zIndex(0.1)
            }.zIndex(0.1)
            if let currentTetrominio = manager.currentTetrominio {
                TetrominoView(manager: _manager, tetromino: currentTetrominio)
                    .zIndex(2.0)
            }
        }//.zIndex(0.1).background(.black.gradient)
         //   .position(x: UIScreen.main.bounds.width / 2, y:284)
    }
}

#Preview {
    GameView()
}
