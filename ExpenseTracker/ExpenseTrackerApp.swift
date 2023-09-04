//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Batuhan on 31.07.2023.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
