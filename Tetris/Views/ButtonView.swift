//
//  ButtonView.swift
//  Tetris
//
//  Created by Jonathan French on 4.12.25.
//

import SwiftUI
import SwiftData

struct ButtonView: View {
    @EnvironmentObject var manager: GameManager
    @Environment(\.modelContext) private var context
    @State private var leftHoldTask: Task<Void, Never>?
    @State private var rightHoldTask: Task<Void, Never>?

    @State private var isHoldingLeft = false
    @State private var isHoldingRight = false
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    
                    Image("btn_left")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 100 * manager.deviceMulti,
                            height: 50 * manager.deviceMulti
                        ).gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in

                                    guard !isHoldingLeft else { return }
                                    isHoldingLeft = true

                                    // Immediate first movement
                                    moveLeft()
                                    manager.tactileFeedback(style: .soft)

                                    // Start repeat task
                                    leftHoldTask = Task { @MainActor in

                                        // Initial delay before repeating
                                        try? await Task.sleep(for: .milliseconds(350))

                                        // Continue while button is held
                                        while !Task.isCancelled {
                                            moveLeft()
                                            try? await Task.sleep(for: .milliseconds(100))
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    isHoldingLeft = false
                                    leftHoldTask?.cancel()
                                    leftHoldTask = nil
                                }
                        )
                        .onDisappear {
                            leftHoldTask?.cancel()
                            leftHoldTask = nil
                        }
                        .opacity(manager.gameState == .playing || manager.gameState == .highscore ? 1:0.5)

                    Image("btn_rotate_left")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 100 * manager.deviceMulti,
                            height: 50 * manager.deviceMulti
                        ).onTapGesture {
                            if manager.gameState == .playing {
                                print("Single tap - rotate")
                                manager.rotateL()
                            }
                            manager.tactileFeedback(style: .soft)
                        }
                        .opacity(manager.gameState == .playing ? 1:0.5)
                }
                Spacer()
                if manager.gameState == .highscore {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(manager.gradOtoY)
                        .stroke(.white, lineWidth: 2)
                        .frame(width: 100 * manager.deviceMulti, height: 50 * manager.deviceMulti)
                        .overlay(content: {
                            Text("NEXT")
                                .font(.custom("HelveticaNeue", size: 18 * manager.deviceMulti).bold())
                                .foregroundStyle(.black)
                        })
                        .onTapGesture {
                            nextLetter()
                        }
                    
                } else if let nextTetrominio = manager.nextTetrominio {
                    if manager.gameState == .playing || manager.gameState == .paused {
                        let nextResource = ImageResource(name: "\(nextTetrominio.kind)tetromino", bundle: .main)
                        NextView(next:nextResource)
                    }
                }
                
                Spacer()
                VStack {
                    
                    Image("btn_right")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 100 * manager.deviceMulti,
                            height: 50 * manager.deviceMulti
                        ).gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in

                                    guard !isHoldingRight else { return }
                                    isHoldingRight = true

                                    // Immediate first movement
                                    moveRight()
                                    manager.tactileFeedback(style: .soft)

                                    // Start repeat task
                                    rightHoldTask = Task { @MainActor in

                                        // Initial delay before repeating
                                        try? await Task.sleep(for: .milliseconds(350))

                                        // Continue while button is held
                                        while !Task.isCancelled {
                                            moveRight()
                                            try? await Task.sleep(for: .milliseconds(100))
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    isHoldingRight = false
                                    rightHoldTask?.cancel()
                                    rightHoldTask = nil
                                }
                        )
                        .onDisappear {
                            rightHoldTask?.cancel()
                            rightHoldTask = nil
                        }
                        .opacity(manager.gameState == .playing || manager.gameState == .highscore ? 1:0.5)
                    Image("btn_rotate_right")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 100 * manager.deviceMulti,
                            height: 50 * manager.deviceMulti
                        ).onTapGesture {
                            if manager.gameState == .playing {
                                print("Single tap - rotate")
                                manager.rotateR()
                            }
                            manager.tactileFeedback(style: .soft)
                        }
                        .opacity(manager.gameState == .playing ? 1:0.5)
                }
                Spacer()
            }
        }.background(.clear)
    }
    
    func nextLetter() {
        manager.letterIndex += 1
        manager.selectedLetter = 0
        /// Final letter and store it
        if manager.letterIndex == 3 {
            let score = GameScore(
                timestamp: .now,
                rows: manager.lines,
                score: manager.score,
                level: manager.level,
                name:String(manager.letterArray)
            )
            context.insert(score)
            try? context.save()
            manager.gameState = .intro
        }
    }
    private func moveRight() {
        if manager.gameState == .playing {
            manager.currentTetrominio?.moveRight()
        } else if manager.gameState == .highscore {
            manager.letterUp()
        }
    }
    
    private func moveLeft() {
        if manager.gameState == .playing {
            manager.currentTetrominio?.moveLeft()
        } else if manager.gameState == .highscore {
            manager.letterDown()
        }
    }
}

#Preview {
    ButtonView()
}
