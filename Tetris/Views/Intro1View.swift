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
            Text("World Tour")
                .font(.custom("HelveticaNeue", size: IntroView.starttextSize * manager.deviceMulti).bold())
                .foregroundStyle(manager.grad)
            Text("2026")
                .font(.custom("HelveticaNeue", size: IntroView.starttextSize * manager.deviceMulti).bold())
                .foregroundStyle(manager.gradOtoY)

            Spacer()
            Text("Latest Score")
                .font(.custom("HelveticaNeue", size: IntroView.starttextSize * manager.deviceMulti).bold())
                .foregroundStyle(manager.grad)
            Text("\(String(format: "%07d", manager.latestScore))")
                .font(.custom("HelveticaNeue", size: IntroView.starttextSize * manager.deviceMulti))
                .foregroundStyle(manager.gradOtoY)
            Text("Level:\(String(format: "%02d", manager.latestLevel)) Lines:\(String(format: "%03d", manager.latestLines))")
                .font(.custom("HelveticaNeue", size: IntroView.starttextSize * manager.deviceMulti))
                .foregroundStyle(manager.gradOtoY)
            Spacer()

            Text("Music by Rasputin")
                .font(.custom("HelveticaNeue", size: IntroView.starttextSize * manager.deviceMulti))
                .foregroundStyle(manager.grad)
            Spacer()
        }
    }
}

#Preview {
    Intro1View()
}
