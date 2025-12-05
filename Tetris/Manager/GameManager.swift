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

@MainActor
final class GameManager: ObservableObject {
    // MARK: - Published Properties
    @Published var gameState: GameState = .intro
    @Published var score = 0
//    let soundFX:SoundFX = SoundFX()
    @Published
    var screenData:[[Color?]] = [[]]
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
    var iCount = 0
    var oCount = 0
    var sCount = 0
    var zCount = 0
    var lCount = 0
    var jCount = 0
    var tCount = 0

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
    let leftOffset =  [1,1,2,1,1,1,1]
    let rightOffset = [9,10,9,8,9,9,8]
    var checkPointsX:[Int] = []
    var checkPointsY:[Int] = []
    let addOffset = [-1,-1,0,0,0,0,0]
    
    init() {
//        setBlockImages()
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
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.5))
            setTetronimo()
        }
    }
    
    @objc func nextTetromino(notification: Notification) {
        compactRows(in: &screenData)
        self.setTetronimo()
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
        var n = Int.random(in: 0...6) // shape
        var posX = Int.random(in: leftOffset[n]...rightOffset[n]) // position
        if currentTetrominio != nil {
            self.currentTetrominio = nextTetrominio
            nextTetrominio = Tetromino(xPos: posX, yPos: -3, manager: self, tetrominioArray: tetroPick[n])
        }
        else
        {
            currentTetrominio = Tetromino(xPos: posX, yPos: -3, manager: self, tetrominioArray: tetroPick[n])
            n = Int.random(in: 0...6)
            posX = Int.random(in: leftOffset[n]...rightOffset[n])
            nextTetrominio = Tetromino(xPos: posX, yPos: -3, manager: self, tetrominioArray: tetroPick[n])
        }
        print("frame \(n.description) dropping from \(posX)")
    }
    
    func setScreenData() {
        tetroPick = [oTetrominio,iTetrominio,sTetrominio,zTetrominio,lTetrominio,jTetrominio,tTetrominio]

        screenData.removeAll()
        screenData = Array(
            repeating: Array(repeating: nil, count: arrayDimentionX),
            count: arrayDimentionY
        )
        
//        screenData[27][0] = .red
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
    
//    func setBlockImages() {
//        blockImages.removeAll()
//        for i in 0..<7 {
//            blockImages.append(getTileImage(name: "Blocks", pos: Int.random(in: 0...6), y: 0)!)
//        }
//        
//        gridImages = [blockImages[0],blockImages[0],blockImages[0],blockImages[0],blockImages[0],blockImages[0],nil,blockImages[0],blockImages[0],blockImages[0],blockImages[0],nil,blockImages[0],blockImages[0],blockImages[0],blockImages[0]]
//    }
//  
//    func getTileImage(name: String, pos: Int, y: Int) -> Image? {
//        guard let uiImage = getTile(name: name, pos: pos, y: y) else { return nil }
//        return Image(uiImage: uiImage)
//    }
//    
//    func getTile(name:String,pos:Int,y:Int) -> UIImage? {
//        guard let image = UIImage(named: name) else { return nil }
//        let rect = CGRect(x: pos * 8, y: y * 8, width: 8, height: 8)
//        guard let cgImage = image.cgImage?.cropping(to: rect) else { return nil }
//        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
//    }
    
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

    
    
}

extension Notification.Name {
    static let notificationNextTetromino = Notification.Name("NotificationNextTetromino")
}


extension GameManager {
    
    func setNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.nextTetromino(notification:)), name: .notificationNextTetromino, object: nil)
    }
}
