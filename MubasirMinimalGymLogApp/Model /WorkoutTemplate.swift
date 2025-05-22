//
//  WorkoutTemplate.swift
//  MubasirMinimalGymLogApp
//
//  Created by Mubasir Siddiqui on 22/05/25.
//


// MubasirMinimalGymLogApp/Models/WorkoutTemplate.swift
import Foundation

struct WorkoutTemplate: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var exercises: [ExerciseItem]

    init(id: UUID = UUID(), name: String, exercises: [ExerciseItem]) {
        self.id = id
        self.name = name
        self.exercises = exercises
    }
}