//
//  TetrisApp.swift
//  Tetris
//
//  Created by Jonathan French on 28.11.25.
//

import SwiftUI
import SwiftData

@main
struct TetrisApp: App {
    @StateObject private var manager = GameManager()
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            GameScore.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(manager)
        }
        .modelContainer(for: GameScore.self, onSetup: seedData)
//        _ = seedData(container: sharedModelContainer)
    }
    
    func seedData(_ result: Result<ModelContainer, Error>) {
        guard let container = try? result.get() else {
            print("Failed to set up model container")
            return
        }

        let context = ModelContext(container)

        let count = (try? context.fetchCount(FetchDescriptor<GameScore>())) ?? 0
        guard count == 0 else { return }

        for i in 1...10 {
            let score = GameScore(
                timestamp: .now,
                rows: Int.random(in: 1...20),
                score: Int.random(in: 500...3000),
                level: Int.random(in: 1...10),
                name: "JPF \(i)"
            )
            context.insert(score)
        }

        try? context.save()
    }

}
