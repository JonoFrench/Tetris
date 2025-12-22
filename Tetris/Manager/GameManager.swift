//
//  GameManager.swift
//  Tetris
//
//  Created by Jonathan French on 28.11.25.
//

import Foundation
import QuartzCore
import SwiftUI
import Combine
import SwiftData
import UIKit

enum Device { case iPhone, iPad }

typealias ColorArray = [[Color?]]

@MainActor
final class GameManager: ObservableObject {
    @Environment(\.modelContext) private var context
    // MARK: - Published Properties
    @Published var gameState: GameState = .intro
    @Published var score = 0
    @Published var lines = 0
    @Published var level = 0
    var topScore = 0
    
    let soundFX:SoundFX = SoundFX()
    @Published
    var screenData:ColorArray = [[]]
    @Published
    var clearingRows: Set<Int> = []
    
    var blockImages:[Image] = []
    let screenDimensionX = 10
    let screenDimensionY = 20.0
    let arrayDimentionY = 24 // bigger than visible to allow us to position blocks off screen
    let arrayDimentionX = 10
    var assetDimension = 0.0
    var assetDimensionStep = 0.0
    var yPosOffset = 0.0
    var gameSize = CGSize()
    var screenSize = CGSize()
    @Published
    var currentTetrominio: Tetromino?
    var nextTetrominio: Tetromino?
    let gridColours:[Color] = [.red,.blue,.green,.yellow,.cyan,.purple,.orange,.white]
    var tetroCounters:[Int] = [0,0,0,0,0,0,0]
    
    let oTetrominio:ColorArray = [[nil,nil,nil,nil],
                                  [nil,.red,.red,nil],
                                  [nil,.red,.red,nil],
                                  [nil,nil,nil,nil]]
    let iTetrominio:ColorArray = [[nil,.blue,nil,nil],
                                  [nil,.blue,nil,nil],
                                  [nil,.blue,nil,nil],
                                  [nil,.blue,nil,nil]]
    let sTetrominio:ColorArray = [[nil,nil,nil,nil],
                                  [nil,.yellow,.yellow,nil],
                                  [.yellow,.yellow,nil,nil],
                                  [nil,nil,nil,nil]]
    let zTetrominio:ColorArray = [[nil,nil,nil,nil],
                                  [nil,.green,.green,nil],
                                  [nil,nil,.green,.green],
                                  [nil,nil,nil,nil]]
    let lTetrominio:ColorArray = [[nil,.purple,nil,nil],
                                  [nil,.purple,nil,nil],
                                  [nil,.purple,.purple,nil],
                                  [nil,nil,nil,nil]]
    let jTetrominio:ColorArray = [[nil,nil,.cyan,nil],
                                  [nil,nil,.cyan,nil],
                                  [nil,.cyan,.cyan,nil],
                                  [nil,nil,nil,nil]]
    let tTetrominio:ColorArray = [[nil,nil,nil,nil],
                                  [nil,.orange,.orange,.orange],
                                  [nil,nil,.orange,nil],
                                  [nil,nil,nil,nil]]
    
    var tetroPick:[ColorArray] = []
    var tetroKind:[Kind] = []
    var deviceType:Device = .iPhone
    
    init() {
        tetroPick = [oTetrominio,iTetrominio,sTetrominio,zTetrominio,lTetrominio,jTetrominio,tTetrominio]
        tetroKind = [Kind.O,Kind.I,Kind.S,Kind.Z,Kind.L,Kind.J,Kind.T]
        setupDisplayLink()
        setNotificationObservers()
    }
    
    private func setupDisplayLink() {
        let displayLink = CADisplayLink(target: self, selector: #selector(refreshModel))
        displayLink.add(to: .main, forMode: .common)
    }
    
    func setInit() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            deviceType = .iPad
        } else {
            deviceType = .iPhone
        }
        assetDimension = gameSize.height / screenDimensionY
        assetDimensionStep = assetDimension / GameConstants.Speed.tileSteps
        
    }
    
    func startGame() {
        setScreenData()
        gameState = .playing
        soundFX.backgroundSound()
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.5))
            setTetronimo()
        }
    }
    
    @objc func nextTetromino(notification: Notification) {
        //compactRows(in: &screenData)
        self.setTetronimo()
        clearFullRows()
    }
    
    @objc func gameOver(notification: Notification) {
        //        gameState = .gameover
    }
    
    /// Main loop of game. Tied to screen refresh.
    @objc func refreshModel() {
        
        if gameState == .playing {
            if let currentTetrominio {
                currentTetrominio.move()
            }
        }
    }
    
    func setTetronimo() {
        let n = Int.random(in: 0...6)
        //            n = 1
        let posX = Int.random(in: 0...6)
        self.currentTetrominio = nextTetrominio
        nextTetrominio = Tetromino(xPos: posX, yPos: 0, manager: self, tetrominioArray: tetroPick[n], kind: tetroKind[n])
        tetroCounters[currentTetrominio!.kind.rawValue] += 1
    }
    
    func setScreenData() {
        screenData.removeAll()
        screenData = Array(
            repeating: Array(repeating: nil, count: arrayDimentionX),
            count: arrayDimentionY
        )
        tetroCounters = [0,0,0,0,0,0,0]
        let n = Int.random(in: 0...6)
        //            n = 1
        let posX = Int.random(in: 0...6)
        nextTetrominio = Tetromino(xPos: posX, yPos: 0, manager: self, tetrominioArray: tetroPick[n], kind: tetroKind[n])
        //        screenData[23][0] = .red
        //        screenData[23][1] = .red
        //        screenData[23][2] = .red
        //        screenData[23][3] = .red
        //        screenData[23][4] = .orange
        //        screenData[23][6] = .orange
        //        screenData[23][7] = .red
        //        screenData[23][8] = .red
        //        screenData[23][9] = .red
        //
        //        screenData[22][0] = .red
        //        screenData[22][1] = .red
        //        screenData[22][2] = .red
        //        screenData[22][3] = .red
        //        screenData[22][4] = .red
        //        screenData[22][6] = .red
        //        screenData[22][7] = .red
        //        screenData[22][8] = .red
        //        screenData[22][9] = .red
        //
        //        screenData[21][0] = .red
        //        screenData[20][0] = .red
        //        screenData[19][0] = .red
        //        screenData[18][0] = .red
        //        screenData[17][0] = .red
        //        screenData[16][0] = .red
        //        screenData[15][0] = .red
        //        screenData[14][0] = .red
        //        screenData[13][0] = .red
        //        screenData[12][0] = .red
        //        screenData[11][0] = .red
        //        screenData[10][0] = .red
        //        screenData[9][0] = .red
        //        screenData[8][0] = .red
        //        screenData[7][0] = .red
        //        screenData[6][0] = .red
        //        screenData[5][0] = .red
        //        screenData[4][0] = .purple
        //        screenData[3][0] = .green
        //        screenData[2][0] = .blue
        //        screenData[1][0] = .yellow
        //        screenData[0][0] = .yellow
        
        
        //        screenData[27][9] = .blue
        //        screenData[8][0] = .yellow
        //        screenData[8][9] = .green
        //
        //        placeTetromino(large: &screenData, block: oTetrominio, atX: 6, y: 8)
        //        placeTetromino(large: &screenData, block: iTetrominio, atX: 1, y: 13)
        //        placeTetromino(large: &screenData, block: sTetrominio, atX: 3, y: 16)
        //        placeTetromino(large: &screenData, block: zTetrominio, atX: 4, y: 18)
        //        placeTetromino(large: &screenData, block: lTetrominio, atX: 5, y: 5)
        //        placeTetromino(large: &screenData, block: jTetrominio, atX: 6, y: 12)
        //        placeTetromino(large: &screenData, block: tTetrominio, atX: 0, y: 10)
        
    }
    
    /// Places a block into a larger 2D array at (x, y),
    /// skipping out-of-bounds writes and skipping nils in the block.
    func placeTetromino(large: inout ColorArray,block: ColorArray,atX x: Int,y: Int) {
        print("placeTetromino at x\(x) y \(y)")
        ///If we are placing tetromino at pos less than 4 then thats offscreen, so game over.
        if y < 4  {
            gameState = .gameover
            print("placeTetromino game over")
        }
        
        for row in 0..<block.count {
            for col in 0..<block[row].count {
                
                // Only write non-nil color values
                guard let color = block[row][col] else { continue }
                
                let r = y + row
                let c = x + col
                
                // Skip out-of-bounds indices
                if r >= 0, r < large.count,
                   c >= 0, c < large[r].count
                {
                    large[r][c] = color
                }
            }
        }
    }
    
    func addBoard() {
        if let currentTetrominio {
            placeTetromino(large: &screenData, block: currentTetrominio.tetrominioArray, atX:currentTetrominio.xPos, y: currentTetrominio.yPos) //7
            self.currentTetrominio = nil
        }
    }
    
    func rotateL() {
        if let currentTetrominio {
            currentTetrominio.rotateTetromino(tet: &self.currentTetrominio!, grid: screenData, direction: .ccw)
        }
    }
    
    func rotateR() {
        if let currentTetrominio {
            currentTetrominio.rotateTetromino(tet: &self.currentTetrominio!, grid: screenData, direction: .cw)
        }
    }
    
    func canMove(tetromino: Tetromino,dx: Int,dy: Int,board: ColorArray) -> Bool {
        
        let boardHeight = board.count
        let boardWidth = board.first?.count ?? 0
        
        for row in 0..<4 {
            for col in 0..<4 {
                
                // Ignore empty tetromino cells
                guard tetromino.tetrominioArray[row][col] != nil else {
                    continue
                }
                let newX = tetromino.xPos + col + dx
                let newY = tetromino.yPos + row + dy
                //print("newy \(newY) ypos \(tetromino.yPos)")
                // Bounds check
                if newX < 0 || newX >= boardWidth ||
                    newY < 0 || newY >= boardHeight {
                    print("Bounds check false at Y \(newY) X \(newX)")
                    print("Bounds check false at col \(col) X \(row)")
                    print("Bounds check false at dy \(dy) dx \(dx)")
                    return false
                }
                
                // Collision check
                if board[newY][newX] != nil {
                    print("Collision check false at Y \(newY) X \(newX)")
                    print("Collision check false at col \(col) X \(row)")
                    print("Collision check false at dy \(dy) dx \(dx)")
                    return false
                }
            }
        }
        
        return true
    }
    
    func compactRows(in grid: inout ColorArray) {
        guard !grid.isEmpty else { return }
        
        let width = grid[0].count
        let emptyRow = Array<Color?>(repeating: nil, count: width)
        
        // 1. Filter out full rows (i.e., no nil anywhere)
        let nonFullRows = grid.filter { row in
            row.contains(where: { $0 == nil })  // keep rows that are NOT full
        }
        
        // 2. Count how many full rows were removed
        let removedCount = grid.count - nonFullRows.count
        
        // 3. Build the new grid:
        //    - Start with empty rows at the top
        //    - Append the kept (non-full) rows below
        grid = Array(repeating: emptyRow, count: removedCount) + nonFullRows
    }
    
     private func clearFullRows() {
        let rowsToClear = detectFullRows(in: self.screenData)
        withAnimation {
            clearingRows = Set(rowsToClear)
            if !clearingRows.isEmpty {
                self.soundFX.clearRowSound()
            }
        }
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.15))
            withAnimation {
                self.compactRows(in: &self.screenData)
            }
            self.clearingRows.removeAll()
        }
    }
    
    private func detectFullRows(in grid: ColorArray) -> [Int] {
        var result: [Int] = []
        for (rowIndex, row) in grid.enumerated() {
            /// A full row has NO nil values
            let isFull = !row.contains(where: { $0 == nil })
            if isFull {
                result.append(rowIndex)
            }
        }
        lines += result.count
        return result
    }
    
    func addScore(rows: Int, score: Int, level: Int, name: String) {
        let gameScore = GameScore(timestamp: Date(), rows:rows,score: score,level: level,name: "")
        gameScore.rows = rows
        gameScore.score = score
        gameScore.level = level
        gameScore.name = name
        
        context.insert(gameScore)
        
        do {
            try context.save()
        } catch {
            print("Failed to save: \(error)")
        }
    }
    
    func fetchTopScores(context: ModelContext) -> [GameScore] {
        var descriptor = FetchDescriptor<GameScore>(
            sortBy: [SortDescriptor(\.score, order: .reverse)])
        
        descriptor.fetchLimit = 10
        
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Fetch failed: \(error)")
            return []
        }
    }
}

extension Notification.Name {
    static let notificationNextTetromino = Notification.Name("NotificationNextTetromino")
    static let notificationGameOver = Notification.Name("NotificationGameOver")
}


extension GameManager {
    
    func setNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.nextTetromino(notification:)), name: .notificationNextTetromino, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.gameOver(notification:)), name: .notificationGameOver, object: nil)
        
    }
    
    
    
}
