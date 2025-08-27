//
//  PawsePrintApp.swift
//  PawsePrint
//
//  Created by Rachael Bergeron on 8/12/25.
//

import SwiftUI
import SwiftData

@main
struct PawsePrintApp: App {
    @State private var isLoggedIn = false
    @StateObject private var musicPlayer = MusicPlayerViewModel()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ // schema defines what types of data app can store
            Item.self,         // item self is pretaining to the item type itself
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
            if isLoggedIn {
                MainTabView()
                    .environmentObject(musicPlayer)
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
                    .environmentObject(musicPlayer)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
