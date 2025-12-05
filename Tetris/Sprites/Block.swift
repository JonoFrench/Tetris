//
//  Block.swift
//  Tetris
//
//  Created by Jonathan French on 29.11.25.
//

import Foundation
import SwiftUI
import Combine

final class Block:ObservableObject, Identifiable {
//    var xPos = 0
//    var yPos = 0
    var position = CGPoint()
    var frameSize: CGSize = CGSize()
    @Published
    var currentFrame:ImageResource = ImageResource(name: "", bundle: .main)
    @Published
    var currentImage:Image

    init(image:Image,dimention:Double, position: CGPoint) {
        self.currentImage = image
        self.frameSize = CGSize(width: dimention, height: dimention)
        self.position = position
    }
}
