//
//  CountView.swift
//  Tetris
//
//  Created by Jonathan French on 5.12.25.
//

import SwiftUI

struct CountView: View {
    var counter:Int
    var img:ImageResource?
    var body: some View {
        VStack {
            if let img {
                Image(img)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
            }

            Text("\(String(format: "%04d", counter))")
                .font(.custom("DonkeyKongClassicsNESExtended", size: 8))
                .foregroundStyle(.white)
        }
    }
}
