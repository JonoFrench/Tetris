//
//  CountView.swift
//  Tetris
//
//  Created by Jonathan French on 5.12.25.
//

import SwiftUI

struct CountView: View {
    @EnvironmentObject var manager: GameManager
    var counter:Int
    var img:ImageResource?
    var body: some View {
        VStack(alignment: .center,spacing: 4) {
            if let img {
                Image(img)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50 * manager.deviceMulti, height: 50 * manager.deviceMulti)
            }
            Text("\(String(format: "%03d", counter))")
                .font(.custom("DonkeyKongClassicsNESExtended", size: 8 * manager.deviceMulti))
                .foregroundStyle(.white)
        }.frame(width:70 * manager.deviceMulti)
    }
}
