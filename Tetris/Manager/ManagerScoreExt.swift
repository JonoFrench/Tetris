//
//  ManagerScoreExt.swift
//  Tetris
//
//  Created by Jonathan French on 23.03.26.
//

import Foundation
import SwiftData

extension GameManager {
    ///Hi Score handling from the ControlsView

    func addLetter(){
        letterArray[letterIndex] = highScoreLetters[selectedLetter]
    }
    
    func letterUp() {
        selectedLetter += 1
        if selectedLetter == 26 {
            selectedLetter = 0
        }
        letterArray[letterIndex] = highScoreLetters[selectedLetter]
    }
    
    func letterDown() {
        selectedLetter -= 1
        if selectedLetter == -1 {
            selectedLetter = 25
        }
        letterArray[letterIndex] = highScoreLetters[selectedLetter]
    }
    
//    func nextLetter(context:ModelContext) {
//        letterIndex += 1
//        selectedLetter = 0
//        /// Final letter and store it
//        if letterIndex == 3 {
//            let score = GameScore(
//                timestamp: .now,
//                rows: lines,
//                score: score,
//                level: level,
//                name:String(letterArray)
//            )
//            context.insert(score)
//            try? context.save()
//            gameState = .intro
//        }
//    }
}
