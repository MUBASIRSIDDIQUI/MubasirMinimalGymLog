//
//  MubasirMinimalGymLogAppApp.swift
//  MubasirMinimalGymLogApp
//
//  Created by Mubasir Siddiqui on 22/05/25.
//
// MubasirMinimalGymLogApp/App/MubasirMinimalGymLogApp.swift
import SwiftUI

@main
struct MubasirMinimalGymLogApp: App {
    @StateObject var workoutStore = WorkoutStore() // Create the store instance

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(workoutStore) // Inject the store
                .preferredColorScheme(.dark) // Apply preferred color scheme globally
        }
    }
}
