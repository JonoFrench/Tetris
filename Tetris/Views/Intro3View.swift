//
//  Intro3View.swift
//  Tetris
//
//  Created by Jonathan French on 12.12.25.
//

import SwiftUI

struct Intro3View: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            Text("How to Play")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize))
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            Spacer()
            Text("1. Pieces fall from the top of the screen.")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.helptextSize))
                .foregroundStyle(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            Text("2. Move pieces left or right to position them.")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.helptextSize))
                .foregroundStyle(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            Text("3. Rotate pieces to make them fit.")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.helptextSize))
                .foregroundStyle(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            Text("4. Drop pieces to make them fall faster.")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.helptextSize))
                .foregroundStyle(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            Text("5. Complete a full horizontal line to clear it.")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.helptextSize))
                .foregroundStyle(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            Text("6. Cleared lines give you points.")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.helptextSize))
                .foregroundStyle(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            Text("7. The game ends when pieces stack to the top and no new piece can enter.")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.helptextSize))
                .foregroundStyle(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            Text("Goal")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize))
                .foregroundStyle(.green)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)

            Spacer()
            Text("Clear as many lines as possible and keep the board from filling up.")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.helptextSize))
                .foregroundStyle(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    Intro3View()
}
