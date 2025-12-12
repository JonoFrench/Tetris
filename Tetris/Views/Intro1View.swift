//
//  Intro1View.swift
//  Tetris
//
//  Created by Jonathan French on 12.12.25.
//

import SwiftUI

struct Intro1View: View {
    var body: some View {
        VStack {
            Text("iOS SwiftUI Version")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize))
                .foregroundStyle(.white)
            Spacer()
            Text("Jonathan French 2025")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize))
                .foregroundStyle(.white)
            Spacer()
            Text("Tap to Play")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    Intro1View()
}
