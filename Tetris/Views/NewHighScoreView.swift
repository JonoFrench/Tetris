//
//  NewHighScoreView.swift
//  Tetris
//
//  Created by Jonathan French on 23.03.26.
//

import SwiftUI

struct NewHighScoreView: View {
#if os(iOS)
    static var titleTextSize:CGFloat = 24
    static var subTitleTextSize:CGFloat = 14
    static var letterTextSize:CGFloat = 38
    static var starttextSize:CGFloat = 18
    static var infoTextSize:CGFloat = 12
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
                    .foregroundStyle(.yellow)
                    .font(.custom("DonkeyKongClassicsNESExtended", size: NewHighScoreView.titleTextSize * manager.deviceMulti))
                Spacer()
                Text("New High Score")
                    .foregroundStyle(.red)
                    .font(.custom("DonkeyKongClassicsNESExtended", size: NewHighScoreView.subTitleTextSize * manager.deviceMulti))
                Spacer()
                Text("Enter your")
                    .foregroundStyle(.white)
                    .font(.custom("DonkeyKongClassicsNESExtended", size: NewHighScoreView.subTitleTextSize * manager.deviceMulti))
                Text("initials")
                    .foregroundStyle(.white)
                    .font(.custom("DonkeyKongClassicsNESExtended", size: NewHighScoreView.subTitleTextSize * manager.deviceMulti))

                //Spacer()
                
                HStack {
                    Spacer()
                    Text(String(manager.letterArray[0]))
                        .foregroundStyle(.yellow)
                        .font(.custom("DonkeyKongClassicsNESExtended", size: NewHighScoreView.letterTextSize))
                        .padding() // Add some padding around the letter
                        .border(manager.letterIndex == 0 ? Color.red : Color.white , width: 2)
                    Spacer()
                    Text(String(manager.letterArray[1]))
                        .foregroundStyle(.yellow)
                        .font(.custom("DonkeyKongClassicsNESExtended", size: NewHighScoreView.letterTextSize))
                        .padding() // Add some padding around the letter
                        .border(manager.letterIndex == 1 ? Color.red : Color.white, width: 2)
                    Spacer()
                    Text(String(manager.letterArray[2]))
                        .foregroundStyle(.yellow)
                        .font(.custom("DonkeyKongClassicsNESExtended", size: NewHighScoreView.letterTextSize))
                        .padding() // Add some padding around the letter
                        .border(manager.letterIndex == 2 ? Color.red : Color.white, width: 2)
                    Spacer()
                    
                }
                Spacer()
                Text("Press Left / Right")
                    .foregroundStyle(.white)
                    .font(.custom("DonkeyKongClassicsNESExtended", size: NewHighScoreView.infoTextSize * manager.deviceMulti))
                Spacer()
                Text("Next to select")
                    .foregroundStyle(.red)
                    .font(.custom("DonkeyKongClassicsNESExtended", size: NewHighScoreView.infoTextSize * manager.deviceMulti))
                
                Spacer()
            }.background(.clear)
        }
    }
}

#Preview {
    let previewEnvObject = GameManager()
    return NewHighScoreView()
        .environmentObject(previewEnvObject)
    
}
