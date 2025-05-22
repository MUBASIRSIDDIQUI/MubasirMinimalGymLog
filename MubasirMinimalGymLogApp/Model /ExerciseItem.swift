//
//  ExerciseItem.swift
//  MubasirMinimalGymLogApp
//
//  Created by Mubasir Siddiqui on 22/05/25.
//


// MubasirMinimalGymLogApp/Models/ExerciseItem.swift
import Foundation // UUID needs Foundation

struct ExerciseItem: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var targetReps: String
    var completedSets: Int

    // Initializer for templates or when starting a new exercise
    init(id: UUID = UUID(), name: String, targetReps: String, completedSets: Int = 0) {
        self.id = id
        self.name = name
        self.targetReps = targetReps
        self.completedSets = completedSets
    }
}