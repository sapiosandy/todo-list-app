//
//  TaskStore.swift
//  ToDoListApp
//
//  Created by Sandra Gomez on 5/2/25.
//

import Foundation


// Declares a class named TaskStore. Marked final so you can't subclass it - this keeps things simple
final class TaskStore {
    
    // static let shared creates a single global instance of TaskStore you can use anywhere in your app. (TaskStore.shared). This is called the singleton pattern
    static let shared = TaskStore()
    // A private variable that will hold the location (path) of the tasks.json file on your device.
    private let fileURL: URL
    // tasks is your in-memory list of all Task items.
    // private(set) means other parts of your code can read tasks but only TaskStore itself can change it.
    private(set) var tasks: [Task] = []
    
    
    // This initializer is marked private so nobody else can create another TaskStore - they must use shared.
    private init() {
        // Finds your app's Documents folder. FileManager is Apple's built-in API for dealing with files and folders
        let docs = FileManager
        // The .default property gives you the shared, system-provided instance so you don't have to create your own
            .default
        // urls(for:in:) is a method that returns an array of folder URLs matching your request. for: .documentDirectory asks for the “Documents” directory—where your app is allowed to read/write user files. in: .userDomainMask tells it to look in the user’s home domain (on iOS that’s your app’s sandbox; on macOS it’s your user account). Result: an array of URLs (usually just one) pointing to …/Documents.
            .urls(for: .documentDirectory, in: .userDomainMask)
        // .first takes the first element of that URL array. It returns an optional (URL?) because, in theory, the array could be empty. The ! force-unwraps it, asserting “I’m sure there’s at least one Documents folder URL here.”
            .first!
        // Putting it all together, docs becomes a non-optional URL that points to your app’s Documents directory on disk. You then use this to build the full path to tasks.json, like:
        fileURL = docs.appendingPathComponent("tasks.json") // so you know exactly where to load and save your task data.
        // call load() // Loads any previously saved tasks into memory when TaskStore is first created. 
        load()
    }
    
    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else {return}
        tasks = (try? JSONDecoder().decode([Task].self, from: data)) ?? []
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(tasks) else {return}
        try? data.write(to: fileURL)
    }
    
    func add(_ task: Task) {
        tasks.append(task)
        save()
    }
    
    func toggleCompletion(of task: Task) {
        guard let i = tasks.firstIndex(where: { $0.id == task.id}) else {return}
        tasks[i].isCompleted.toggle()
        save()
    }
    
    func delete (at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        save()
    }
}
