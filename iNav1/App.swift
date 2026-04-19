//
//  iNav1App.swift
//  iNav1
//
//  Created by bell dien on 19/04/2026.
//

import SwiftUI

// MARK: - Root App Entry

@main
struct MyApp: App {
    // One router for the whole app (or one per NavigationStack scope)
    @StateObject private var router = NavigationRouter<Route>()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(router)
        }
    }
}
