//
//  ScreenView.swift
//  Tetris
//
//  Created by Jonathan French on 30.11.25.
//


import SwiftUI
import UIKit

struct ScreenView: View {
    @EnvironmentObject var manager: GameManager
    //    @ObservedObject var gameScreen: ScreenData
    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 0) {
                ZStack(alignment: .center)  {
                    VStack(spacing: 0) {
                        ForEach(0..<20, id: \.self) { y in
                            HStack(spacing: 0) {
                                ForEach(0..<10, id: \.self) { x in
                                    if let c = manager.screenData[y+4][x] {
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .fill(c)
                                            .stroke(.white, lineWidth: 2)
                                            .opacity(manager.clearingRows.contains(y+4) ? 0 : 1)      // fade out
                                            .scaleEffect(manager.clearingRows.contains(y+4) ? 0.01 : 1) // shrink
                                            .animation(.easeOut(duration: 0.5), value: manager.clearingRows)
                                        
                                            .scaleEffect(manager.gameState == .gameending ? 0 : 1)
                                            .animation(.easeOut(duration: 1), value: manager.gameState == .gameending)
                                    } else {
                                        Rectangle().fill(.clear)
                                    }
                                }.frame(width: manager.assetDimension, height: manager.assetDimension)
                            }
                        }
                    }
                    .background(
                        Image("background")
                            .resizable()
                            .scaledToFill()
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 1)
                            .background(Color.clear)
                            .allowsHitTesting(false)
                    )
                }
            }
        }.clipped()
    }
}

//struct BoundsKey: PreferenceKey {
//    static var defaultValue: Anchor<CGRect>? = nil
//    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
//        value = nextValue()
//    }
//}

struct SideBorder: ViewModifier {
    var color: Color = .black
    var width: CGFloat = 1
    var sides: [Side]
    
    enum Side { case left, right, bottom, top }
    
    func body(content: Content) -> some View {
        content.overlay(alignment: .leading) {
            if sides.contains(.left) {
                Rectangle().fill(color).frame(width: width)
            }
        }
        .overlay(alignment: .trailing) {
            if sides.contains(.right) {
                Rectangle().fill(color).frame(width: width)
            }
        }
        .overlay(alignment: .bottom) {
            if sides.contains(.bottom) {
                Rectangle().fill(color).frame(height: width)
            }
        }
        .overlay(alignment: .top) {
            if sides.contains(.top) {
                Rectangle().fill(color).frame(height: width)
            }
        }
    }
}

extension View {
    func sideBorder(
        color: Color = .black,
        width: CGFloat = 1,
        sides: SideBorder.Side...
    ) -> some View {
        modifier(SideBorder(color: color, width: width, sides: sides))
    }
}
