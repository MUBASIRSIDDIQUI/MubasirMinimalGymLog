//
//  SwiftUIView.swift
//  MubasirMinimalGymLogApp
//
//  Created by Mubasir Siddiqui on 22/05/25.
//

// MubasirMinimalGymLogApp/Views/HomeView.swift
import SwiftUI

// Centralized strings for HomeView and its subviews
struct HomeViewStrings {
    static let navigationTitle = "Gym Log"
    static let currentWorkoutTitle = "Current Workout:"
    static let resumeWorkoutButton = "Resume Workout"
    static let chooseWorkoutTitle = "Choose a Workout:"
}

struct HomeView: View {
    @EnvironmentObject var store: WorkoutStore
    @Binding var selectedTab: Int

    let weekDays = ["M", "T", "W", "T", "F", "S", "S"]

    private func getCurrentDayIndex() -> Int {
        let calendar = Calendar.current
        // weekday is 1 for Sunday, 2 for Monday, ..., 7 for Saturday
        let weekday = calendar.component(.weekday, from: Date())

        if weekday == 1 { // Sunday
            return 6
        } else { // Monday to Saturday
            return weekday - 2 // Monday (2) becomes 0, Saturday (7) becomes 5
        }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                HStack(spacing: 10) {
                    ForEach(weekDays.indices, id: \.self) { index in
                        VStack(spacing: 5) {
                            Text(weekDays[index])
                                .font(.caption)
                                .foregroundColor(index == getCurrentDayIndex() ? .orange : .gray)
                            Circle()
                                .fill(index == getCurrentDayIndex() ? Color.orange : Color.gray.opacity(0.3))
                                .frame(width: 10, height: 10)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, 5)

                if let currentSession = store.currentWorkoutSession {
                    ActiveWorkoutCardView(sessionName: currentSession.name) {
                        selectedTab = 1 // Go to workout tab
                    }
                } else {
                    WorkoutTemplatesListView(selectedTab: $selectedTab)
                }
                Spacer() // Pushes content up
            }
            .padding()
            .background(Color.black.ignoresSafeArea())
            .navigationTitle(HomeViewStrings.navigationTitle) // Simplified title
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}

// Subview for displaying active workout info
struct ActiveWorkoutCardView: View {
    let sessionName: String
    let resumeAction: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(HomeViewStrings.currentWorkoutTitle)
                .font(.headline)
                .foregroundColor(.gray)
            Text(sessionName)
                .font(.title2).bold()
                .foregroundColor(.orange)
            Button(action: resumeAction) {
                Label(HomeViewStrings.resumeWorkoutButton, systemImage: "play.circle.fill")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

// Subview for listing workout templates
struct WorkoutTemplatesListView: View {
    @EnvironmentObject var store: WorkoutStore
    @Binding var selectedTab: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text(HomeViewStrings.chooseWorkoutTitle)
                .font(.title2).bold()
                .foregroundColor(.white)
                .padding(.bottom, 5)

            List {
                ForEach(store.templates) { template in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(template.name)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("\(template.exercises.count) exercises")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "play.fill")
                            .foregroundColor(.orange)
                            .padding(8)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding(.vertical, 4)
                    .listRowBackground(Color.black.opacity(0.5)) // Darker row for better contrast
                    .contentShape(Rectangle()) // Ensures the whole area is tappable
                    .onTapGesture {
                        store.startWorkout(template: template)
                        selectedTab = 1
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.black) // Ensure list background is black
        }
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
        .environmentObject(WorkoutStore())
        .preferredColorScheme(.dark)
}
