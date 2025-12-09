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
    func drop()
    func draw()
}

enum Kind { case I, O, J, L, S, T, Z }

class Tetromino: TetrominoProtocol {
    
    var xPos:Int = 0
    var yPos:Int = 0
    var xBoard:Int = 0
    var yBoard:Int = 0
    var kind: Kind
    var rotation: Int = 0
    
    var manager: GameManager
    var tetrominioArray: [[Color?]]
    var moveDistance = 0.0
    var speedCounter: Int = 0
    var stopmove = false
    
    @Published
    var position = CGPoint()

    var blocks:[Block] = []
    
    let JLSTZ_KICKS: [Int: [(dx: Int, dy: Int)]] = [
        // rotationState → list of kicks when rotating CW from that state
        0: [(0,0), (-1,0), (-1,+1), (0,-2), (-1,-2)],
        1: [(0,0), (+1,0), (+1,-1), (0,+2), (+1,+2)],
        2: [(0,0), (+1,0), (+1,+1), (0,-2), (+1,-2)],
        3: [(0,0), (-1,0), (-1,-1), (0,+2), (-1,+2)]
    ]

    let I_KICKS: [Int: [(dx: Int, dy: Int)]] = [
        0: [(0,0), (-2,0), (+1,0), (-2,-1), (+1,+2)],
        1: [(0,0), (-1,0), (+2,0), (-1,+2), (+2,-1)],
        2: [(0,0), (+2,0), (-1,0), (+2,+1), (-1,-2)],
        3: [(0,0), (+1,0), (-2,0), (+1,-2), (-2,+1)]
    ]

    let O_KICKS = [(0,0)]

    init(xPos: Int, yPos: Int, manager:GameManager,tetrominioArray:[[Color?]],kind:Kind) {
        self.manager = manager
        self.xPos = xPos
        self.yPos = yPos
        self.xBoard = xPos - 2
        self.yBoard = yPos + 7
        self.tetrominioArray = tetrominioArray
        self.position = CGPoint(x: Double(xPos) * manager.assetDimension + 13, y: Double(yPos) * manager.assetDimension)
        self.moveDistance = manager.assetDimension / 20.0
        self.kind = kind
    }
    
    func move() {
        guard !stopmove else {
            return
        }
        self.speedCounter += 1
        self.position.y += moveDistance
        if self.speedCounter == 20 {
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
            if po.x < 1 || po.x >= 8 { continue }
//            print("frame poses at \(po) \(manager.screenData[yBoard + po.y][xBoard + po.x]?.description)")
            if manager.screenData[yBoard + po.y][xBoard + po.x] != nil {
                return true
            }
        }
        return false
    }
    
    func addBoard() {
        manager.placeTetromino(large: &manager.screenData, block: manager.currentTetrominio!.tetrominioArray, atX:xBoard, y: manager.currentTetrominio!.yBoard) //7
        manager.currentTetrominio = nil
    }
    
//    func rotateL() {
//        
//        manager.rotateTetrominoL(&tetrominioArray)
//    }
//    
//    func rotateR() {
//        manager.rotateTetrominoR(&tetrominioArray)
//        
//    }
    
    func moveLeft() {
        if !isCollision(grid: manager.screenData, tet: self, shape: self.tetrominioArray) {
            xPos -= 1
            xBoard -= 1
            self.position.x -= manager.assetDimension
        }
    }
        
    func moveRight() {
        if !isCollision(grid: manager.screenData, tet: self, shape: self.tetrominioArray) {
            xPos += 1
            xBoard += 1
            self.position.x += manager.assetDimension
        }
    }
    
    func drop() {
        
    }
    
    func draw() {
        
    }

    enum RotationDirection { case cw, ccw }

    func rotateTetromino(
        tet: inout Tetromino,
        grid: [[Color?]],
        direction: RotationDirection
    ) {
        // 1. Compute new rotation value
        let oldRot = tet.rotation
        let newRot = direction == .cw ? (oldRot + 1) % 4 : (oldRot + 3) % 4

        // 2. Rotate the shape itself
        let newShape = direction == .cw
            ? rotateCW(tet.tetrominioArray)
            : rotateCCW(tet.tetrominioArray)

        // 3. Choose kick table
        let kickTable: [Int:(dx: Int, dy: Int)]

        let kicks: [(dx: Int, dy: Int)]
        switch tet.kind {
        case .O:
            kicks = O_KICKS
        case .I:
            // special I-piece table
            kicks = I_KICKS[oldRot]!
        default:
            kicks = JLSTZ_KICKS[oldRot]!
        }

        // 4. Try each kick
        for (dx, dy) in kicks {
            var testTet = tet
            testTet.xPos += dx
            testTet.yPos += dy

            if !isCollision(grid: grid, tet: testTet, shape: newShape) {
                // Successful rotation
                tet.xPos = testTet.xPos
                tet.yPos = testTet.yPos
                tet.tetrominioArray = newShape
                tet.rotation = newRot
                return
            }
        }

        // 5. All kicks failed -> rotation is blocked
    }
    func rotateCW(_ m: [[Color?]]) -> [[Color?]] {
        var out = Array(repeating: Array(repeating: Color?.none, count: 4), count: 4)
        for y in 0..<4 {
            for x in 0..<4 {
                out[x][3 - y] = m[y][x]
            }
        }
        return out
    }
    
    func rotateCCW(_ m: [[Color?]]) -> [[Color?]] {
        var out = Array(repeating: Array(repeating: Color?.none, count: 4), count: 4)
        for y in 0..<4 {
            for x in 0..<4 {
                out[3 - x][y] = m[y][x]
            }
        }
        return out
    }
    
    func isCollision(grid: [[Color?]], tet: Tetromino, shape: [[Color?]]) -> Bool {
        for y in 0..<4 {
            for x in 0..<4 {
                guard let color = shape[y][x] else { continue }

                let gx = self.xPos + x
                let gy = self.yPos + y

                // Outside grid
                if gy < 0 || gy >= grid.count { return true }
                if gx < 0 || gx >= grid[0].count { return true }

                // Collides with existing block
                if grid[gy][gx] != nil { return true }
            }
        }
        return false
    }

    
    
}

