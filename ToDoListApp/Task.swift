//
//  Task.swift
//  ToDoListApp
//
//  Created by Sandra Gomez on 5/2/25.
//

import Foundation

struct Task: Codable, Identifiable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var dueDate: Date?

    init(id: UUID = .init(), title: String, isCompleted: Bool = false, dueDate: Date? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        
    }
}
