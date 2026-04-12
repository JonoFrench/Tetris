//
//  Intro2View.swift
//  Tetris
//
//  Created by Jonathan French on 12.12.25.
//

import SwiftUI
import SwiftData

struct Intro2View: View {
    static var hstextSize:CGFloat = 14
    @EnvironmentObject var manager: GameManager
    @Environment(\.modelContext) private var context
    @State private var topScores: [GameScore] = []


    var body: some View {
        VStack {
            Text("High Scores")
                .font(.custom("HelveticaNeue", size: IntroView.starttextSize * manager.deviceMulti))
                .foregroundStyle(.red)
//            Spacer()
            VStack(alignment: .leading, spacing: 6) {
                
                // HEADER
                HStack {
                    Text(" ").frame(width: 40 * manager.deviceMulti, alignment: .leading)                .font(.custom("HelveticaNeue", size: Intro2View.hstextSize * manager.deviceMulti))
                        .foregroundStyle(.white)
                    Text("Name").frame(width: 60 * manager.deviceMulti, alignment: .leading)
                        .font(.custom("HelveticaNeue", size: Intro2View.hstextSize * manager.deviceMulti))
                            .foregroundStyle(.white)
                   Text("Rows").frame(width: 60 * manager.deviceMulti, alignment: .trailing)
                        .font(.custom("HelveticaNeue", size: Intro2View.hstextSize * manager.deviceMulti))
                            .foregroundStyle(.white)
                    Text("Level").frame(width: 70 * manager.deviceMulti, alignment: .trailing)
                        .font(.custom("HelveticaNeue", size: Intro2View.hstextSize * manager.deviceMulti))
                            .foregroundStyle(.white)
                    Text("Score").frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.custom("HelveticaNeue", size: Intro2View.hstextSize * manager.deviceMulti))
                            .foregroundStyle(.white)
                }
                .font(.headline)
                
//                Divider()
                
                // ROWS
                ForEach(topScores.indices, id: \.self) { index in
                    let score = topScores[index]
                    
                    HStack {
                        Text("\(index + 1)")
                            .font(.custom("HelveticaNeue", size: Intro2View.hstextSize * manager.deviceMulti))
                                .foregroundStyle(.white)
                            .frame(width: 40 * manager.deviceMulti, alignment: .leading)
                        
                        Text(score.name)
                            .font(.custom("HelveticaNeue", size: Intro2View.hstextSize * manager.deviceMulti))
                                .foregroundStyle(.white)
                            .frame(width: 60 * manager.deviceMulti, alignment: .leading)
                        
                        Text("\(score.rows)")
                            .font(.custom("HelveticaNeue", size: Intro2View.hstextSize * manager.deviceMulti))
                                .foregroundStyle(.white)
                            .frame(width: 60, alignment: .trailing)
                        
                        Text("\(score.level)")
                            .font(.custom("HelveticaNeue", size: Intro2View.hstextSize * manager.deviceMulti))
                                .foregroundStyle(.white)
                            .frame(width: 70 * manager.deviceMulti, alignment: .trailing)
                        
                        Text("\(score.score)")
                            .font(.custom("HelveticaNeue", size: Intro2View.hstextSize * manager.deviceMulti))
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
