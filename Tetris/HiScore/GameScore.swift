//
//  GameScore.swift
//  Tetris
//
//  Created by Jonathan French on 28.11.25.
//

import Foundation
import SwiftData

@Model
final class GameScore {
    var timestamp: Date
    var rows: Int = 0
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
