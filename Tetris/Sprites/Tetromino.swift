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
    func drop()
}

enum Kind: Int { case I = 0, O = 1, J = 2, L = 3, S = 4, T = 5, Z = 6 }
enum RotationDirection { case cw, ccw }

class Tetromino: TetrominoProtocol {
    
    var xPos:Int = 0
    var yPos:Int = 0
    var kind: Kind
    var rotation: Int = 0
    
    var manager: GameManager
    var tetrominioArray: ColorArray
    var moveDistance = 0.0
    var currentSpeed = 20.0
    var speedCounter: Int = 0
    var stopmove = false
    var dropMove = false
    
    @Published
    var position = CGPoint()
    
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
    
    init(xPos: Int, yPos: Int, manager:GameManager,tetrominioArray:ColorArray,kind:Kind) {
        self.manager = manager
        self.xPos = xPos
        self.yPos = yPos
        self.tetrominioArray = tetrominioArray
        self.position = CGPoint(x: Double(xPos + 2) * manager.assetDimension + 8, y: Double(yPos-3) * manager.assetDimension)
        self.moveDistance = manager.assetDimension / currentSpeed
        self.kind = kind
    }
    
    func move() {
        guard !stopmove else {
            return
        }
        if dropMove {
            let dropDiff = Int(currentSpeed) - self.speedCounter
            dropMove = false
            self.position.y += Double(dropDiff) * moveDistance
            self.speedCounter = 0
            moveDistance = manager.assetDimension
            currentSpeed = 1
            yPos += 1
        } else {
            self.speedCounter += 1
            self.position.y += moveDistance
            if self.speedCounter == Int(currentSpeed) {
                self.speedCounter = 0
                if !checkBoard() {
                    print("!checkBoard() stopTetromino")
                    stopTetromino()
                } else {
                    yPos += 1
                }
            }
        }
    }
    
    func stopTetromino() {
        stopmove = true
        manager.addBoard()
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1))
            NotificationCenter.default.post(name: .notificationNextTetromino, object: nil)
            stopmove = false
            speedCounter = 0
        }
    }
    
    func checkBoard() -> Bool {
        if manager.canMove(tetromino: self, dx: 0, dy: +1, board: manager.screenData) {
            return true
        }
        return false
    }
    
    func moveLeft() {
        if manager.canMove(tetromino: self, dx: -1, dy: 0, board: manager.screenData) {
            xPos -= 1
            self.position.x -= manager.assetDimension
            print("moveLeft yes")
        }
    }
    
    func moveRight() {
        if manager.canMove(tetromino: self, dx: +1, dy: 0, board: manager.screenData) {
            xPos += 1
            self.position.x += manager.assetDimension
            print("moveRight yes")
        }
    }

    func drop() {
        self.moveDistance = manager.assetDimension / 20.0
    }
        
    func rotateTetromino(tet: inout Tetromino,grid: ColorArray,direction: RotationDirection) {
        // 1. Compute new rotation value
        let oldRot = tet.rotation
        let newRot = direction == .cw ? (oldRot + 1) % 4 : (oldRot + 3) % 4
        
        // 2. Rotate the shape itself
        let newShape = direction == .cw
        ? rotateCW(tet.tetrominioArray)
        : rotateCCW(tet.tetrominioArray)
        
        // 3. Choose kick table
        //        let kickTable: [Int:(dx: Int, dy: Int)]
        
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
            let testTet = tet
            testTet.xPos += dx
            testTet.yPos += dy
            //            testTet.xBoard += dx
            //            testTet.yBoard += dy
            
            if !isCollision(grid: grid, tet: testTet, shape: newShape) {
                // Successful rotation
                tet.xPos = testTet.xPos
                tet.yPos = testTet.yPos
                //                tet.xBoard = testTet.xBoard
                //                tet.yBoard = testTet.yBoard
                
                tet.tetrominioArray = newShape
                tet.rotation = newRot
                return
            }
        }
        
        // 5. All kicks failed -> rotation is blocked
    }
    func rotateCW(_ m: ColorArray) -> ColorArray {
        var out = Array(repeating: Array(repeating: Color?.none, count: 4), count: 4)
        for y in 0..<4 {
            for x in 0..<4 {
                out[x][3 - y] = m[y][x]
            }
        }
        return out
    }
    
    func rotateCCW(_ m: ColorArray) -> ColorArray {
        var out = Array(repeating: Array(repeating: Color?.none, count: 4), count: 4)
        for y in 0..<4 {
            for x in 0..<4 {
                out[3 - x][y] = m[y][x]
            }
        }
        return out
    }
    
    func isCollision(grid: ColorArray, tet: Tetromino, shape: ColorArray) -> Bool {
        for y in 0..<4 {
            for x in 0..<4 {
                guard let color = shape[y][x] else { continue }
                
                let gx = self.xPos + x
                let gy = self.yPos + y
                print("isCollision xpos \(xPos) gx \(gx) x \(x)")
                
                // Outside grid
                if gy < 0 || gy > grid.count { return true }
                if gx < 0 || gx > grid[0].count {
                    print("outside grid left ")
                    return true }
                
                // Collides with existing block
                if gx < grid[0].count {
                    if grid[gy][gx] != nil { return true }
                }
            }
        }
        return false
    }
}

