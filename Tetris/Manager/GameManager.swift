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
    var screenData:[[Color?]] = [[]]
    @Published
    var clearingRows: Set<Int> = []

    var blockImages:[Image] = []
    let screenDimensionX = 10
    let screenDimensionY = 20.0
    let arrayDimentionY = 28 // bigger than visible to allowus to position blocks off screen
    let arrayDimentionX = 10
    var assetDimension = 0.0
    var assetDimensionStep = 0.0
    var yPosOffset = 0.0
    var gameSize = CGSize()
    var screenSize = CGSize()
    @Published
    var currentTetrominio: Tetromino?
    var nextTetrominio: Tetromino?
    var gridImages:[Image?] = []
    let gridColours:[Color] = [.red,.blue,.green,.yellow,.cyan,.purple,.orange,.white]
    var nextTetrominioArray: [[Color?]] = [[]]
    var tetroCounters:[Int] = [0,0,0,0,0,0,0]

    let oTetrominio:[[Color?]] = [[nil,nil,nil,nil],
                                  [nil,.red,.red,nil],
                                  [nil,.red,.red,nil],
                                  [nil,nil,nil,nil]]
    let iTetrominio:[[Color?]] = [[nil,.blue,nil,nil],
                                  [nil,.blue,nil,nil],
                                  [nil,.blue,nil,nil],
                                  [nil,.blue,nil,nil]]
    let sTetrominio:[[Color?]] = [[nil,nil,nil,nil],
                                  [nil,.yellow,.yellow,nil],
                                  [.yellow,.yellow,nil,nil],
                                  [nil,nil,nil,nil]]
    let zTetrominio:[[Color?]] = [[nil,nil,nil,nil],
                                  [nil,.green,.green,nil],
                                  [nil,nil,.green,.green],
                                  [nil,nil,nil,nil]]
    let lTetrominio:[[Color?]] = [[nil,.purple,nil,nil],
                                  [nil,.purple,nil,nil],
                                  [nil,.purple,.purple,nil],
                                  [nil,nil,nil,nil]]
    let jTetrominio:[[Color?]] = [[nil,nil,.cyan,nil],
                                  [nil,nil,.cyan,nil],
                                  [nil,.cyan,.cyan,nil],
                                  [nil,nil,nil,nil]]
    let tTetrominio:[[Color?]] = [[nil,nil,nil,nil],
                                  [nil,.orange,.orange,.orange],
                                  [nil,nil,.orange,nil],
                                  [nil,nil,nil,nil]]

    var tetroPick:[[[Color?]]] = []
    var tetroKind:[Kind] = []
    let leftOffset =  [1,1,2,1,1,1,1]
    let rightOffset = [9,10,9,8,9,9,8]
    
    var irot:[[Color?]] = [[]]
    var srot:[[Color?]] = [[]]
    var zrot:[[Color?]] = [[]]
    var trot:[[Color?]] = [[]]

    
    
    init() {
        tetroPick = [oTetrominio,iTetrominio,sTetrominio,zTetrominio,lTetrominio,jTetrominio,tTetrominio]
        tetroKind = [Kind.O,Kind.I,Kind.S,Kind.Z,Kind.L,Kind.J,Kind.T]
        setupSharedServices()
        setupDisplayLink()
        setNotificationObservers()
    }
    
    /// Share these instances so they are available from the other Sprites
    private func setupSharedServices() {
//        ServiceLocator.shared.register(service: screenData)
    }
    
    private func setupDisplayLink() {
        let displayLink = CADisplayLink(target: self, selector: #selector(refreshModel))
        displayLink.add(to: .main, forMode: .common)
    }
    
    func setInit() {
#if os(iOS)
        assetDimension = gameSize.height / screenDimensionY
#elseif os(tvOS)
        screenData.assetDimension = screenData.gameSize.height / 14 //Double(screenData.screenDimensionX + 3)
#endif
        assetDimensionStep = assetDimension / GameConstants.Speed.tileSteps
//        setIntroScreenData()
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
        gameState = .gameover
    }
    
    /// Main loop of game. Tied to screen refresh.
    @objc func refreshModel() {
        
        if gameState == .playing {
            if let currentTetrominio {
                currentTetrominio.move()
            }
        }
    }

    func checkFull() -> Bool {
        print("game over check \(screenData[4])")
        return screenData[4].allSatisfy{ $0 == nil }
    }
    

    
    func setTetronimo() {
        if !checkFull() {
            gameState = .gameover
            print("game over")
            return
        }
        let n = Int.random(in: 0...6)
//            n = 1
        let posX = Int.random(in: leftOffset[n]...rightOffset[n])

        self.currentTetrominio = nextTetrominio
        //print("setTetronimo currentTetrominio \(currentTetrominio?.kind) dropping from \(posX)")
        nextTetrominio = Tetromino(xPos: posX, yPos: -3, manager: self, tetrominioArray: tetroPick[n], kind: tetroKind[n])
        //print("setTetronimo nextTetrominio \(nextTetrominio?.kind)")
        //print("frame \(n.description) dropping from \(posX)")
        tetroCounters[currentTetrominio!.kind.rawValue] += 1
    }
    
    func setScreenData() {

        screenData.removeAll()
        screenData = Array(
            repeating: Array(repeating: nil, count: arrayDimentionX),
            count: arrayDimentionY
        )
        tetroCounters = [0,0,0,0,0,0,0]
        irot = iTetrominio
        srot = sTetrominio
        zrot = zTetrominio
        trot = tTetrominio

        let _ = self.rotateTetrominoL(&irot)
        let _ = self.rotateTetrominoL(&srot)
        let _ = self.rotateTetrominoL(&zrot)
        let _ = self.rotateTetrominoL(&trot)

        let n = Int.random(in: 0...6)
//            n = 1
        let posX = Int.random(in: leftOffset[n]...rightOffset[n])
        nextTetrominio = Tetromino(xPos: posX, yPos: -3, manager: self, tetrominioArray: tetroPick[n], kind: tetroKind[n])
        screenData[27][0] = .red
        screenData[27][1] = .red
        screenData[27][2] = .red
        screenData[27][3] = .red
        screenData[27][4] = .red
        screenData[27][6] = .red
        screenData[27][7] = .red
        screenData[27][8] = .red
        screenData[27][9] = .red

        screenData[26][0] = .red
        screenData[26][1] = .red
        screenData[26][2] = .red
        screenData[26][3] = .red
        screenData[26][4] = .red
        screenData[26][6] = .red
        screenData[26][7] = .red
        screenData[26][8] = .red
        screenData[26][9] = .red

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
    func placeTetromino(
        large: inout [[Color?]],
        block: [[Color?]],
        atX x: Int,
        y: Int
    ) {
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

    func rotateL() {
        if let currentTetrominio {
            currentTetrominio.rotateTetromino(tet: &self.currentTetrominio!, grid: screenData, direction: .ccw)
        }
        

        //manager.rotateTetrominoL(&tetrominioArray)
    }
    
    func rotateR() {
        if let currentTetrominio {
            currentTetrominio.rotateTetromino(tet: &self.currentTetrominio!, grid: screenData, direction: .cw)
        }
        
        //manager.rotateTetrominoR(&tetrominioArray)
        
    }
    
    func rotateTetrominoR(_ block: inout [[Color?]]) {
        precondition(block.count == 4 && block.allSatisfy { $0.count == 4 })

        let n = 4
        for layer in 0..<(n / 2) {
            let first = layer
            let last  = n - layer - 1

            for i in first..<last {
                let offset = i - first

                // Save top
                let top = block[first][i]

                // left → top
                block[first][i] = block[last - offset][first]

                // bottom → left
                block[last - offset][first] = block[last][last - offset]

                // right → bottom
                block[last][last - offset] = block[i][last]

                // top → right
                block[i][last] = top
            }
        }
    }

    func rotateTetrominoL(_ block: inout [[Color?]]) {
        precondition(block.count == 4 && block.allSatisfy { $0.count == 4 })

        let n = 4
        for layer in 0..<(n / 2) {
            let first = layer
            let last  = n - layer - 1

            for i in first..<last {
                let offset = i - first

                // Save top
                let top = block[first][i]

                // right → top
                block[first][i] = block[i][last]

                // bottom → right
                block[i][last] = block[last][last - offset]

                // left → bottom
                block[last][last - offset] = block[last - offset][first]

                // top → left
                block[last - offset][first] = top
            }
        }
    }

    func positionsWithNilBelow(in block: [[Color?]]) -> [(x: Int, y: Int)] {
        var result: [(x: Int, y: Int)] = []

        let rows = block.count
        let cols = block[0].count

        for y in 0..<rows {        // include bottom row
            for x in 0..<cols {

                guard let value = block[y][x] else { continue }

                // If we're on the last row → "below" is treated as nil
                if y == rows - 1 {
                    result.append((x: x, y: y+1))
                    continue
                }

                // Otherwise use real below value
                if block[y + 1][x] == nil {
                    result.append((x: x, y: y+1))
                }
            }
        }

        return result
    }

func compactRows(in grid: inout [[Color?]]) {
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

    func clearFullRows() {
        let rowsToClear = detectFullRows(in: self.screenData)         // your logic

        // Start animation
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
            
//        // After animation finishes → modify grid
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//            withAnimation {
//                self.compactRows(in: &self.screenData)
//                self.soundFX.clearRowSound()
//            }
//            self.clearingRows.removeAll()
//        }
    }
    func detectFullRows(in grid: [[Color?]]) -> [Int] {
        var result: [Int] = []
        
        for (rowIndex, row) in grid.enumerated() {
            // A full row has NO nil values
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
