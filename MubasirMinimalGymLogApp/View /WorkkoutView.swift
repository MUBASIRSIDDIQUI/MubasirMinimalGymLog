//
//  SwiftUIView.swift
//  MubasirMinimalGymLogApp
//
//  Created by Mubasir Siddiqui on 22/05/25.
//


// MubasirMinimalGymLogApp/Views/WorkoutView.swift
import SwiftUI

struct WorkoutView: View {
    @EnvironmentObject var store: WorkoutStore
    @Binding var selectedTab: Int
    @State private var showingFinishAlert = false

    var body: some View {
        NavigationView { // Add NavigationView for toolbar items
            VStack(alignment: .leading) {
                if store.activeExercises.isEmpty {
                    NoWorkoutSelectedView(selectedTab: $selectedTab)
                } else {
                    ScrollView {
                        ForEach($store.activeExercises) { $exercise in
                            ExerciseRowView(exercise: $exercise)
                            if store.activeExercises.last?.id != exercise.id {
                                Divider().background(Color.gray.opacity(0.4))
                            }
                        }
                    }
                    .padding(.top, 5) // Add a little space from the title/toolbar
                }
                
                // Spacer to push button to bottom, only if workout is active
                if !store.activeExercises.isEmpty {
                    Spacer()
                    Button(action: {
                        showingFinishAlert = true
                    }) {
                        Text("Finish Workout")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                }
            }
            .padding()
            .background(Color.black.ignoresSafeArea())
            .navigationTitle(store.currentWorkoutSession?.name ?? "Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Add toolbar items only if a workout is active
                if !store.activeExercises.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            store.resetActiveWorkoutSets()
                        } label: {
                            Label("Reset Sets", systemImage: "arrow.counterclockwise.circle.fill")
                        }
                        .tint(.yellow)
                    }
                }
            }
            .alert("Finish Workout?", isPresented: $showingFinishAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Finish", role: .destructive) {
                    store.finishWorkout()
                    selectedTab = 2 // Navigate to History
                }
            } message: {
                Text("Are you sure you want to finish this workout session? Any incomplete sets will not be saved for exercises with 0 completed sets.")
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct NoWorkoutSelectedView: View {
    @Binding var selectedTab: Int
    var body: some View {
        Spacer()
        VStack(spacing: 15) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No Workout Selected")
                .font(.title2)
                .foregroundColor(.white)
            Text("Please start a workout from the Home screen.")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Button("Go to Home") {
                selectedTab = 0 // Navigate to Home tab
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
        }
        .frame(maxWidth: .infinity)
        Spacer()
    }
}

struct ExerciseRowView: View {
    @Binding var exercise: ExerciseItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(exercise.name)
                .foregroundColor(.white)
                .font(.headline)
            Text("Target: \(exercise.targetReps)")
                .foregroundColor(.gray)
                .font(.subheadline)
            
            HStack(spacing: 15) {
                Button {
                    if exercise.completedSets > 0 {
                        exercise.completedSets -= 1
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32) // Slightly increased size
                        .foregroundColor(exercise.completedSets > 0 ? .orange : .gray.opacity(0.5))
                }
                .buttonStyle(.plain)
                .disabled(exercise.completedSets == 0)

                Text("\(exercise.completedSets)")
                    .foregroundColor(.white)
                    .font(.title2.bold())
                    .frame(width: 45, height: 35) // Ensure consistent sizing
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    

                Button {
                    exercise.completedSets += 1
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.orange)
                }
                .buttonStyle(.plain)
                
                Spacer() // Pushes controls to the left
            }
        }
        .padding(.vertical, 12)
    }
}

#Preview {
//    WorkoutView()
}
