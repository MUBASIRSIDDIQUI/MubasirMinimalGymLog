//
//  SwiftUIView.swift
//  MubasirMinimalGymLogApp
//
//  Created by Mubasir Siddiqui on 22/05/25.
//

// MubasirMinimalGymLogApp/Views/HistoryView.swift
import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var store: WorkoutStore

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if store.history.isEmpty {
                    EmptyHistoryView()
                } else {
                    List {
                        ForEach(store.history) { entry in
                            WorkoutLogEntryView(entry: entry)
                                .listRowBackground(Color.black.opacity(0.6)) // Darker row
                                .listRowSeparatorTint(.gray.opacity(0.5))
                        }
                        .onDelete(perform: store.deleteHistoryEntries)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.black)
                }
            }
            .padding([.horizontal, .bottom]) // Adjust padding
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Workout History")
            .toolbar {
                if !store.history.isEmpty { EditButton() } // Show EditButton only if there's history
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct EmptyHistoryView: View {
    var body: some View {
        Spacer()
        VStack(spacing: 15) {
            Image(systemName: "list.star")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No Workout History")
                .font(.title2)
                .foregroundColor(.white)
            Text("Complete a workout to see it logged here.")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        Spacer()
    }
}

struct WorkoutLogEntryView: View {
    let entry: WorkoutLogEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(entry.workoutName)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text(entry.dateString)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            if !entry.completedExercises.isEmpty {
                Text("Completed Exercises:")
                    .font(.caption.weight(.medium))
                    .foregroundColor(.orange)
                    .padding(.top, 4)
                
                ForEach(entry.completedExercises) { ex in // Assuming completedExercises only contains those with sets > 0
                     HStack(alignment: .firstTextBaseline) {
                        Text("  • \(ex.name):")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(ex.completedSets) set(s) of \(ex.targetReps)")
                            .font(.caption)
                            .foregroundColor(.white)
                     }
                }
            } else {
                Text("No sets were completed for this workout.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}
