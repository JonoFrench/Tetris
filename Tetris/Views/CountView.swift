//
//  CountView.swift
//  Tetris
//
//  Created by Jonathan French on 5.12.25.
//

import SwiftUI

struct CountView: View {
    var counter:Int
    var shape:[[Color?]]
    
    var body: some View {
        VStack {
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
                                            .frame(width: 16, height: 16)
                                    } else {
                                        Rectangle()
                                            .fill(.clear)
                                            .frame(width: 16, height: 16)
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
            Text("\(String(format: "%04d", counter))")
                .font(.custom("DonkeyKongClassicsNESExtended", size: 10))
                .foregroundStyle(.white)
        }
        
    }
}
