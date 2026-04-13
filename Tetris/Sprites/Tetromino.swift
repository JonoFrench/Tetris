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
    private var _xPos: Int = 0
    var xPos: Int {
        get { _xPos }
        set {
            print("xPos changing from \(_xPos) to \(newValue)")
            _xPos = newValue
            if _xPos == -3 {
                print("xPos is -3")

            }
        }
    }
    //var xPos:Int = 0
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
    var deviceOffset = 8
    var deviceAssetDimension = 2
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
        self._xPos = xPos
        self.manager = manager
        self.yPos = yPos
        self.tetrominioArray = tetrominioArray
        if manager.deviceType == .iPad {
            deviceAssetDimension = 6
            deviceOffset = 42 //24
        } else {
            deviceAssetDimension = 2
            //8
            deviceOffset = Int(24 + manager.assetDimension)
        }
        self.position = CGPoint(x: Double(xPos + deviceAssetDimension) * manager.assetDimension + Double(deviceOffset), y: Double(yPos-3) * manager.assetDimension)
        self.moveDistance = manager.assetDimension / currentSpeed
        self.kind = kind
        self.xPos = xPos
    }
    
    func move() {
        guard !stopmove else {
            return
        }
        if dropMove {
            let dropDiff = Int(currentSpeed) - self.speedCounter
            self.dropMove = false
            self.position.y += Double(dropDiff) * self.moveDistance
            self.speedCounter = 0
            self.moveDistance = manager.assetDimension
            self.currentSpeed = 1
            self.yPos += 1
        } else {
            self.speedCounter += 1
           self.position.y += moveDistance
            if self.speedCounter == Int(currentSpeed) {
                self.speedCounter = 0
                if !checkBoard() {
                    print("!checkBoard() stopTetromino X\(xPos) Y \(yPos)")
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
        print("rotate \(direction)")
       // 1. Compute new rotation value
        let oldRot = tet.rotation
        let newRot = direction == .cw ? (oldRot + 1) % 4 : (oldRot + 3) % 4
        
        // 2. Rotate the shape itself
        let newShape = direction == .cw
        ? rotateCW(tet.tetrominioArray)
        : rotateCCW(tet.tetrominioArray)
        
        // 3. Choose kick table
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
            let testX = tet.xPos + dx
            let testY = tet.yPos + dy

            if !isCollisionAt(grid: grid, x: testX, y: testY, shape: newShape) {
                tet.position.x += CGFloat(dx) * manager.assetDimension
                tet.xPos = testX
                tet.yPos = testY
                tet.tetrominioArray = newShape
                tet.rotation = newRot
                return
            }
        }
        // 5. All kicks failed -> rotation is blocked
        print("rotate failed")
    }
    func rotateCW(_ m: ColorArray) -> ColorArray {
        print("rotate rotateCW")
        var out = Array(repeating: Array(repeating: Color?.none, count: 4), count: 4)
        for y in 0..<4 {
            for x in 0..<4 {
                out[x][3 - y] = m[y][x]
            }
        }
        return out
    }
    
    func rotateCCW(_ m: ColorArray) -> ColorArray {
        print("rotate rotateCCW")
        var out = Array(repeating: Array(repeating: Color?.none, count: 4), count: 4)
        for y in 0..<4 {
            for x in 0..<4 {
                out[3 - x][y] = m[y][x]
            }
        }
        return out
    }
    
    func isCollisionAt(grid: ColorArray, x: Int, y: Int, shape: ColorArray) -> Bool {
        for sy in 0..<4 {
            for sx in 0..<4 {
                guard shape[sy][sx] != nil else { continue }
                
                let gx = x + sx
                let gy = y + sy
                
                if gy < 0 || gy >= grid.count { return true }
                if gx < 0 || gx >= grid[0].count { return true }
                
                if grid[gy][gx] != nil { return true }
            }
        }
        return false
    }
}

