//
//  NextView.swift
//  Tetris
//
//  Created by Jonathan French on 5.12.25.
//


import SwiftUI

struct NextView: View {
    @EnvironmentObject var manager: GameManager
    var shape:[[Color?]]
    
    var body: some View {
        VStack {
            Text("NEXT")
                .font(.custom("DonkeyKongClassicsNESExtended", size: 12))
                .foregroundStyle(.white)
            ZStack {
                VStack(spacing: 0) {
                    ForEach(0..<4) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<4) { col in
                                let col = shape[row][col]
                                ZStack {
                                    if let col {
                                        Rectangle()
                                            .fill(col)
                                            .border(.black)
                                            .frame(width: 20, height: 20)
                                    } else {
                                        Rectangle()
                                            .fill(.clear)
                                            .frame(width: 20, height: 20)
                                    }
                                }
                            }
                        }
                    }
                    
                }.border(.white)
            }
        }.onTapGesture {
            print("diving down")
            manager.currentTetrominio?.dropMove = true
        }
        
    }
}
