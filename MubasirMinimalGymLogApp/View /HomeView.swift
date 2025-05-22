//
//  SwiftUIView.swift
//  MubasirMinimalGymLogApp
//
//  Created by Mubasir Siddiqui on 22/05/25.
//

// MubasirMinimalGymLogApp/Views/HomeView.swift
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: WorkoutStore
    @Binding var selectedTab: Int

    let weekDays = ["M", "T", "W", "T", "F", "S", "S"]

    private func getCurrentDayIndex() -> Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date()) // 1=Sun, 2=Mon, ..., 7=Sat
        return (weekday == 1) ? 6 : (weekday - 2) // Adjust so Monday is 0, Sunday is 6
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
            .navigationTitle("Gym Log") // Simplified title
            .navigationBarTitleDisplayMode(.large)
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
            Text("Current Workout:")
                .font(.headline)
                .foregroundColor(.gray)
            Text(sessionName)
                .font(.title2).bold()
                .foregroundColor(.orange)
            Button(action: resumeAction) {
                Label("Resume Workout", systemImage: "play.circle.fill")
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
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
            Text("Choose a Workout:")
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
                        Button {
                            store.startWorkout(template: template)
                            selectedTab = 1
                        } label: {
                            Image(systemName: "play.fill")
                                .foregroundColor(.orange)
                                .padding(8)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 4)
                    .listRowBackground(Color.black.opacity(0.5)) // Darker row for better contrast
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.black) // Ensure list background is black
        }
    }
}


#Preview {
//    HomeView
}
