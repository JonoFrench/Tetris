//
//  ContentView.swift
//  Tetris
//
//  Created by Jonathan French on 28.11.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var manager: GameManager

    var body: some View {
           ZStack(alignment: .top) {
                Color(.black)
                VStack(spacing: 0) {
                    TopView()
                        .frame(width: UIScreen.main.bounds.width,height: 60, alignment: .center)
                        .zIndex(3.0)
                        .background(.black)
                    if manager.gameState == .intro {
                        IntroView().background(.black)
                    } else {
                        GameView()
//                            .background(.gray)
                    }
    //                BottomView()
    //                    .background(.red)
    //                Spacer()
                    ButtonView()
//                        .frame(maxWidth: .infinity,alignment: .center)
                        .frame(width: UIScreen.main.bounds.width,height: 120, alignment: .center)
                        //.frame(maxWidth: .infinity)
                        .zIndex(2.0)
                        .background(.black)
                }
            }
        }

}

#Preview {
    let previewEnvObject = GameManager()
    return ContentView()
        .modelContainer(for: GameScore.self, inMemory: true)
        .environmentObject(previewEnvObject)
}
