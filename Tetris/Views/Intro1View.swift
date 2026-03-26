//
//  Intro1View.swift
//  Tetris
//
//  Created by Jonathan French on 12.12.25.
//

import SwiftUI

struct Intro1View: View {
    @EnvironmentObject var manager: GameManager
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
//            Text("SwiftUI Version")
//                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize * manager.deviceMulti))
//                .foregroundStyle(.red)
//            Spacer()
            Text("Jonathan French")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize * manager.deviceMulti))
                .foregroundStyle(.red)
            Text("2026")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize * manager.deviceMulti))
                .foregroundStyle(.red)

            Spacer()
            Text("NICE OF YOU TO")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize * manager.deviceMulti))
                .foregroundStyle(.yellow)
            Text("DROP IN")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize * manager.deviceMulti))
                .foregroundStyle(.yellow)

            Spacer()

            Text("Music by Rasputin")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize * manager.deviceMulti))
                .foregroundStyle(.white)
            Spacer()

//            Text("Based on an Original game by")
//                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize * manager.deviceMulti))
//                .foregroundStyle(.blue)
////            Spacer()
//            Text("Alexey Pajitnov 1984")
//                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize * manager.deviceMulti))
//                .foregroundStyle(.blue)
        }
    }
}

#Preview {
    Intro1View()
}
