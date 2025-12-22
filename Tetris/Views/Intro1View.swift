//
//  Intro1View.swift
//  Tetris
//
//  Created by Jonathan French on 12.12.25.
//

import SwiftUI

struct Intro1View: View {
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text("SwiftUI Version")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize))
                .foregroundStyle(.red)
//            Spacer()
            Text("Jonathan French 2025")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize))
                .foregroundStyle(.red)
            Spacer()
            Text("Music by Rasputin")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize))
                .foregroundStyle(.white)
            Spacer()

            Text("Original game by")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize))
                .foregroundStyle(.blue)
//            Spacer()
            Text("Alexey Pajitnov 1984")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize))
                .foregroundStyle(.blue)
        }
    }
}

#Preview {
    Intro1View()
}
