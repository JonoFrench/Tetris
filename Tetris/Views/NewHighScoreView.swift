//
//  NewHighScoreView.swift
//  Tetris
//
//  Created by Jonathan French on 23.03.26.
//

import SwiftUI

struct NewHighScoreView: View {
#if os(iOS)
    static var titleTextSize:CGFloat = 40
    static var subTitleTextSize:CGFloat = 30
    static var letterTextSize:CGFloat = 38
    static var starttextSize:CGFloat = 18
    static var infoTextSize:CGFloat = 24
#elseif os(tvOS)
    static var titleTextSize:CGFloat = 72
    static var subTitleTextSize:CGFloat = 56
    static var letterTextSize:CGFloat = 76
    static var starttextSize:CGFloat = 48
    static var infoTextSize:CGFloat = 36
#endif
    @EnvironmentObject var manager: GameManager
    @State private var initialIndex = 0
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
            VStack {
                Spacer()
                Text("Game Over")
                    .foregroundStyle(manager.grad)
                    .font(.custom("HelveticaNeue", size: NewHighScoreView.titleTextSize).bold())
                Spacer()
                Text("New High Score!")
                    .foregroundStyle(manager.gradOtoY)
                    .font(.custom("HelveticaNeue", size: NewHighScoreView.subTitleTextSize).bold())
                Spacer()
                Text("Enter your")
                    .foregroundStyle(manager.gradWtoG)
                    .font(.custom("HelveticaNeue", size: NewHighScoreView.subTitleTextSize).bold())
                Text("initials")
                    .foregroundStyle(manager.gradWtoG)
                    .font(.custom("HelveticaNeue", size: NewHighScoreView.subTitleTextSize).bold())

                //Spacer()
                
                HStack {
                    Spacer()
                    Text(String(manager.letterArray[0]))
                        .foregroundStyle(manager.gradOtoY)
                        .font(.custom("HelveticaNeue", size: NewHighScoreView.letterTextSize))
                        .padding() // Add some padding around the letter
                        .frame(width:70)
                        .border(manager.letterIndex == 0 ? manager.grad : manager.gradWtoG , width: 2)
                    Spacer()
                    Text(String(manager.letterArray[1]))
                        .foregroundStyle(manager.gradOtoY)
                        .font(.custom("HelveticaNeue", size: NewHighScoreView.letterTextSize))
                        .padding() // Add some padding around the letter
                        .frame(width:70)
                        .border(manager.letterIndex == 1 ? manager.grad : manager.gradWtoG, width: 2)
                    Spacer()
                    Text(String(manager.letterArray[2]))
                        .foregroundStyle(manager.gradOtoY)
                        .font(.custom("HelveticaNeue", size: NewHighScoreView.letterTextSize))
                        .padding() // Add some padding around the letter
                        .frame(width:70)
                        .border(manager.letterIndex == 2 ? manager.grad : manager.gradWtoG, width: 2)
                    Spacer()
                    
                }
                Spacer()
                Text("Press Left / Right")
                    .foregroundStyle(manager.gradWtoG)
                    .font(.custom("HelveticaNeue", size: NewHighScoreView.infoTextSize))
                Spacer()
                Text("Next to Select")
                    .foregroundStyle(manager.gradWtoG)
                    .font(.custom("HelveticaNeue", size: NewHighScoreView.infoTextSize))
                
                Spacer()
            }//.background(.clear)
        }.zIndex(1.0)
    }
}

#Preview {
    let previewEnvObject = GameManager()
    return NewHighScoreView()
        .environmentObject(previewEnvObject)
    
}
