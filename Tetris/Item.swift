//
//  Item.swift
//  Tetris
//
//  Created by Jonathan French on 28.11.25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
