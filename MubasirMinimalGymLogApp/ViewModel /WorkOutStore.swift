//
//  WorkOutStore.swift
//  MubasirMinimalGymLogApp
//
//  Created by Mubasir Siddiqui on 22/05/25.
//

// MubasirMinimalGymLogApp/Stores/WorkoutStore.swift
import SwiftUI // For @Published, ObservableObject
import Combine  // For ObservableObject (though SwiftUI often implies it)

class WorkoutStore: ObservableObject {
    @Published var templates: [WorkoutTemplate] = []
    @Published var currentWorkoutSession: WorkoutTemplate?
    @Published var activeExercises: [ExerciseItem] = []
    @Published var history: [WorkoutLogEntry] = []

    private let historyKey = "workoutHistory_v1" // Added version in case of future model changes

    init() {
        loadDefaultTemplates()
        loadHistory()
    }

    func loadDefaultTemplates() {
        guard templates.isEmpty else { return }
        templates = [
            WorkoutTemplate(name: "Push Day", exercises: [
                ExerciseItem(name: "Bench Press", targetReps: "3x5-8"),
                ExerciseItem(name: "Overhead Press", targetReps: "3x8-12"),
                ExerciseItem(name: "Incline DB Press", targetReps: "3x10-15"),
                ExerciseItem(name: "Tricep Pushdowns", targetReps: "3x12-15"),
                ExerciseItem(name: "Lateral Raises", targetReps: "3x15-20")
            ]),
            WorkoutTemplate(name: "Pull Day", exercises: [
                ExerciseItem(name: "Deadlifts", targetReps: "1x5+"),
                ExerciseItem(name: "Pull-ups", targetReps: "3xAMRAP"), // As Many Reps As Possible
                ExerciseItem(name: "Barbell Rows", targetReps: "3x8-12"),
                ExerciseItem(name: "Face Pulls", targetReps: "3x15-20"),
                ExerciseItem(name: "Bicep Curls", targetReps: "3x10-15")
            ]),
            WorkoutTemplate(name: "Leg Day", exercises: [
                ExerciseItem(name: "Squats", targetReps: "3x5-8"),
                ExerciseItem(name: "RDLs", targetReps: "3x8-12"),
                ExerciseItem(name: "Leg Press", targetReps: "3x10-15"),
                ExerciseItem(name: "Hamstring Curls", targetReps: "3x12-15"),
                ExerciseItem(name: "Calf Raises", targetReps: "4x15-20")
            ])
        ]
    }

    func startWorkout(template: WorkoutTemplate) {
        currentWorkoutSession = template
        activeExercises = template.exercises.map { exerciseDef in
            // Create fresh copies for the session, ensuring sets are reset
            ExerciseItem(name: exerciseDef.name, targetReps: exerciseDef.targetReps, completedSets: 0)
        }
    }

    func resetActiveWorkoutSets() {
        activeExercises = activeExercises.map { exercise in
            var mutableExercise = exercise
            mutableExercise.completedSets = 0
            return mutableExercise
        }
    }

    func finishWorkout() {
        guard let session = currentWorkoutSession, !activeExercises.isEmpty else {
            print("Error: No active workout to finish or exercises are empty.")
            return
        }

        let logEntry = WorkoutLogEntry(
            date: Date(),
            workoutName: session.name,
            completedExercises: activeExercises.filter { $0.completedSets > 0 } // Only log exercises with completed sets
        )
        
        // Only add if there were actually completed sets
        if !logEntry.completedExercises.isEmpty {
            history.insert(logEntry, at: 0)
            saveHistory()
        } else {
            print("Workout finished but no sets were completed. Not logging.")
        }

        currentWorkoutSession = nil
        activeExercises = []
//        print("Workout session ended. Logged: \(logEntry.workoutName if !logEntry.completedExercises.isEmpty else "N/A - No sets")")
    }

    // --- Persistence for History ---
    private func saveHistory() {
        do {
            let encoded = try JSONEncoder().encode(history)
            UserDefaults.standard.set(encoded, forKey: historyKey)
            print("History saved. Count: \(history.count)")
        } catch {
            print("Failed to save history: \(error.localizedDescription)")
        }
    }

    private func loadHistory() {
        guard let savedHistoryData = UserDefaults.standard.data(forKey: historyKey) else {
            print("No saved history found for key: \(historyKey).")
            history = []
            return
        }
        
        do {
            history = try JSONDecoder().decode([WorkoutLogEntry].self, from: savedHistoryData)
            print("History loaded. Count: \(history.count)")
        } catch {
            print("Failed to decode history: \(error.localizedDescription). Resetting history.")
            // Consider what to do on decode failure. Resetting is one option.
            history = []
            // Optionally remove the corrupted data
            // UserDefaults.standard.removeObject(forKey: historyKey)
        }
    }

    func deleteHistoryEntries(at offsets: IndexSet) {
        history.remove(atOffsets: offsets)
        saveHistory()
    }
    
    // Example for potentially adding user-defined templates later
    func addTemplate(_ template: WorkoutTemplate) {
        templates.append(template)
        // Potentially save templates to UserDefaults too if they become user-editable
    }
}
