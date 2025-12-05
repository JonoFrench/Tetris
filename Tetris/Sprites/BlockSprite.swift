//
//  BlockSprite.swift
//  Tetris
//
//  Created by Jonathan French on 29.11.25.
//

import SwiftUI

struct BlockSprite: View {
    var id = UUID()
    var block:Block
    var body: some View {
        ZStack {
            block.currentImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: block.frameSize.width, height: block.frameSize.height)
                .background(.clear)
        }.background(.clear)
            .position(block.position)
    }
}
//#Preview {
//    let previewBlock = Block()
//
//    BlockSprite(block:previewBlock )
//}
