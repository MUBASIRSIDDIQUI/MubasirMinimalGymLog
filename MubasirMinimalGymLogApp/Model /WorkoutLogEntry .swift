//
//  WorkoutLogEntry .swift
//  MubasirMinimalGymLogApp
//
//  Created by Mubasir Siddiqui on 22/05/25.
//




// MubasirMinimalGymLogApp/Models/WorkoutLogEntry.swift
import Foundation

struct WorkoutLogEntry: Identifiable, Codable {
    let id: UUID
    var date: Date
    var workoutName: String
    var completedExercises: [ExerciseItem]

    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none // Changed to none for a cleaner date display in history
        return formatter.string(from: date)
    }

    init(id: UUID = UUID(), date: Date, workoutName: String, completedExercises: [ExerciseItem]) {
        self.id = id
        self.date = date
        self.workoutName = workoutName
        self.completedExercises = completedExercises
    }
}
