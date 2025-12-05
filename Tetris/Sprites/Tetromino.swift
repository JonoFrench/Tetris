//
//  Tetromino.swift
//  Tetris
//
//  Created by Jonathan French on 1.12.25.
//

import Foundation
import SwiftUI
import Combine

protocol TetrominoProtocol:ObservableObject {
    func move()
    func checkBoard() -> Bool
    func addBoard()
    func rotateL()
    func rotateR()
    func drop()
    func draw()
}

class Tetromino: TetrominoProtocol {
    
    var xPos:Int = 0
    var yPos:Int = 0
    var xBoard:Int = 0
    var yBoard:Int = 0

    var manager: GameManager
    var tetrominioArray: [[Color?]]
    var moveDistance = 0.0
    var speedCounter: Int = 0
    var stopmove = false
    
    @Published
    var position = CGPoint()

    var blocks:[Block] = []
    
    init(xPos: Int, yPos: Int, manager:GameManager,tetrominioArray:[[Color?]]) {
        self.manager = manager
        self.xPos = xPos
        self.yPos = yPos
        self.xBoard = xPos - 2
        self.yBoard = yPos + 7
        self.tetrominioArray = tetrominioArray
        self.position = CGPoint(x: Double(xPos) * manager.assetDimension + 13, y: Double(yPos) * manager.assetDimension)
        self.moveDistance = manager.assetDimension / 16.0
    }
    
    func move() {
        guard !stopmove else {
            return
        }
        self.speedCounter += 1
        self.position.y += moveDistance
        if self.speedCounter == 16 {
            print("yPos: \(yPos)")
            self.speedCounter = 0
            if yPos < 18 {
                if checkBoard() { stopTetromino() } else {
                    yPos += 1
                    yBoard += 1
                }
            } else {
                stopTetromino()
            }
        }
    }
    
    func stopTetromino() {
        stopmove = true
        addBoard()
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1))
            NotificationCenter.default.post(name: .notificationNextTetromino, object: nil)
            stopmove = false
            speedCounter = 0
            
        }
    }
    
    func checkBoard() -> Bool {
        let poses = manager.positionsWithNilBelow(in: manager.currentTetrominio!.tetrominioArray)
        for po in poses {
            if yBoard + po.y >= manager.screenData.endIndex { return true }
            if po.x < 0 || po.x >= 10 { continue }
            print("frame poses at \(po) \(manager.screenData[yBoard + po.y][xBoard + po.x]?.description)")
            if manager.screenData[yBoard + po.y][xBoard + po.x] != nil {
                return true
            }
        }
        return false
    }
    
    func addBoard() {
        manager.placeTetromino(large: &manager.screenData, block: manager.currentTetrominio!.tetrominioArray, atX:xBoard, y: manager.currentTetrominio!.yBoard) //7
    }
    
    func rotateL() {
        manager.rotateTetrominoL(&tetrominioArray)
    }
    
    func rotateR() {
        manager.rotateTetrominoR(&tetrominioArray)
        
    }
    
    func moveLeft() {
        xPos -= 1
        xBoard -= 1
        self.position.x -= manager.assetDimension
    }
    
    func moveRight() {
        xPos += 1
        xBoard += 1
        self.position.x += manager.assetDimension
    }
    
    func drop() {
        
    }
    
    func draw() {
        
    }

}

