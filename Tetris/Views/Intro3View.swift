//
//  Intro3View.swift
//  Tetris
//
//  Created by Jonathan French on 12.12.25.
//

import SwiftUI

struct Intro3View: View {
    @EnvironmentObject var manager: GameManager
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            Text("How to Play")
                .font(.custom("HelveticaNeue", size: IntroView.starttextSize * manager.deviceMulti))
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            Spacer()
            Text("1. Tetroids fall from the top of the screen.")
                .font(.custom("HelveticaNeue", size: IntroView.helptextSize * manager.deviceMulti))
                .foregroundStyle(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 16)
            Text("2. Move tetroids left or right to position them.")
                .font(.custom("HelveticaNeue", size: IntroView.helptextSize * manager.deviceMulti))
                .foregroundStyle(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 16)
            Text("3. Rotate tetroids to make them fit.")
                .font(.custom("HelveticaNeue", size: IntroView.helptextSize * manager.deviceMulti))
                .foregroundStyle(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 16)
            Text("4. Tap Next to drop tetroids to make them fall faster.")
                .font(.custom("HelveticaNeue", size: IntroView.helptextSize * manager.deviceMulti))
                .foregroundStyle(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 16)
            Text("5. Complete a full horizontal line to clear it.")
                .font(.custom("HelveticaNeue", size: IntroView.helptextSize * manager.deviceMulti))
                .foregroundStyle(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 16)
            Text("6. Cleared lines give you points.")
                .font(.custom("HelveticaNeue", size: IntroView.helptextSize * manager.deviceMulti))
                .foregroundStyle(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 16)
            Text("7. The game ends when tetroids stack to the top and no new tetroids can enter the screen.")
                .font(.custom("HelveticaNeue", size: IntroView.helptextSize * manager.deviceMulti))
                .foregroundStyle(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 16)
            Spacer()
            Text("Goal")
                .font(.custom("HelveticaNeue", size: IntroView.starttextSize * manager.deviceMulti))
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)

            Spacer()
            Text("Clear as many lines as possible and keep the board from filling up.")
                .font(.custom("HelveticaNeue", size: IntroView.helptextSize * manager.deviceMulti))
                .foregroundStyle(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 16)
        }
    }
}

#Preview {
    Intro3View()
}
