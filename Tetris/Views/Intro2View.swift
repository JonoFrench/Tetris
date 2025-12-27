//
//  Intro2View.swift
//  Tetris
//
//  Created by Jonathan French on 12.12.25.
//

import SwiftUI
import SwiftData

struct Intro2View: View {
    static var hstextSize:CGFloat = 8
    @EnvironmentObject var manager: GameManager
    @Environment(\.modelContext) private var context
    @State private var topScores: [GameScore] = []


    var body: some View {
        VStack {
            Text("High Scores")
                .font(.custom("DonkeyKongClassicsNESExtended", size: IntroView.starttextSize * manager.deviceMulti))
                .foregroundStyle(.red)
            Spacer()
            VStack(alignment: .leading, spacing: 12) {
                
                // HEADER
                HStack {
                    Text("Rank").frame(width: 50 * manager.deviceMulti, alignment: .leading)                .font(.custom("DonkeyKongClassicsNESExtended", size: Intro2View.hstextSize * manager.deviceMulti))
                        .foregroundStyle(.white)
                    Text("Name").frame(width: 100 * manager.deviceMulti, alignment: .leading)
                        .font(.custom("DonkeyKongClassicsNESExtended", size: Intro2View.hstextSize * manager.deviceMulti))
                            .foregroundStyle(.white)
                   Text("Rows").frame(width: 60 * manager.deviceMulti, alignment: .trailing)
                        .font(.custom("DonkeyKongClassicsNESExtended", size: Intro2View.hstextSize * manager.deviceMulti))
                            .foregroundStyle(.white)
                    Text("Level").frame(width: 60 * manager.deviceMulti, alignment: .trailing)
                        .font(.custom("DonkeyKongClassicsNESExtended", size: Intro2View.hstextSize * manager.deviceMulti))
                            .foregroundStyle(.white)
                    Text("Score").frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.custom("DonkeyKongClassicsNESExtended", size: Intro2View.hstextSize * manager.deviceMulti))
                            .foregroundStyle(.white)
                }
                .font(.headline)
                
                Divider()
                
                // ROWS
                ForEach(topScores.indices, id: \.self) { index in
                    let score = topScores[index]
                    
                    HStack {
                        Text("\(index + 1)")
                            .font(.custom("DonkeyKongClassicsNESExtended", size: Intro2View.hstextSize * manager.deviceMulti))
                                .foregroundStyle(.white)
                            .frame(width: 50 * manager.deviceMulti, alignment: .leading)
                        
                        Text(score.name)
                            .font(.custom("DonkeyKongClassicsNESExtended", size: Intro2View.hstextSize * manager.deviceMulti))
                                .foregroundStyle(.white)
                            .frame(width: 100 * manager.deviceMulti, alignment: .leading)
                        
                        Text("\(score.rows)")
                            .font(.custom("DonkeyKongClassicsNESExtended", size: Intro2View.hstextSize * manager.deviceMulti))
                                .foregroundStyle(.white)
                            .frame(width: 60, alignment: .trailing)
                        
                        Text("\(score.level)")
                            .font(.custom("DonkeyKongClassicsNESExtended", size: Intro2View.hstextSize * manager.deviceMulti))
                                .foregroundStyle(.white)
                            .frame(width: 60 * manager.deviceMulti, alignment: .trailing)
                        
                        Text("\(score.score)")
                            .font(.custom("DonkeyKongClassicsNESExtended", size: Intro2View.hstextSize * manager.deviceMulti))
                                .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .bold()
                    }
                }                
                Spacer()
            }
            .padding()
            .task {
                topScores = manager.fetchTopScores(context: context)
            }
        }
    }
}

#Preview {
    Intro2View()
}
