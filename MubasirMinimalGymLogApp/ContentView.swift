import SwiftUI

// If this is your main app entry point, you would uncomment this.
// For now, ContentView can be previewed directly.
//@main
//struct MubasirMinimalGymLogApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}

// MubasirMinimalGymLogApp/Views/ContentView.swift
import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0 // Default to Home
    @EnvironmentObject var store: WorkoutStore // Access the store

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem { Label("Home", systemImage: "house.fill") } // Using fill icons
                .tag(0)

            WorkoutView(selectedTab: $selectedTab)
                .tabItem { Label("Workout", systemImage: "figure.walk") } // Changed icon
                .tag(1)

            HistoryView()
                .tabItem { Label("History", systemImage: "clock.fill") }
                .tag(2)
        }
        .accentColor(.orange) // Accent color for the TabView
    }
}
