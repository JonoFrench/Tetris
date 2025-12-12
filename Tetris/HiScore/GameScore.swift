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
    var rows: Int
    var score: Int
    var level: Int
    var name: String
    
    init(timestamp: Date = .now, rows: Int, score: Int, level: Int, name: String) {
        self.timestamp = timestamp
        self.rows = rows
        self.score = score
        self.level = level
        self.name = name
    }
}
