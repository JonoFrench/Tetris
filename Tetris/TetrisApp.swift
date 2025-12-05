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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            GameScore.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(manager)
        }
        .modelContainer(sharedModelContainer)
        
    }
}
