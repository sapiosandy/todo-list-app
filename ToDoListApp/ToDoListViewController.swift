//
//  ToDoListViewController.swift
//  ToDoListApp
//
//  Created by Sandra Gomez on 5/3/25.
//

import Foundation

import UIKit

class ToDoListViewController: UITableViewController {
    // 1. Reference the shared data store
    private let store = TaskStore.shared
    
    // 2. Configure table and nav bar
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To-Do"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // “+” button to add tasks
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
    }
    
    // 3. Always reload before showing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Add Task
    
    @objc private func addTask() {
        let alert = UIAlertController(title: "New Task", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter task"
        }
        alert.addAction(.init(title: "Cancel", style: .cancel))
        alert.addAction(.init(title: "Add", style: .default) { _ in
            guard let text = alert.textFields?.first?.text,!text.isEmpty else { return }
            let task = Task(title: text)
            self.store.add(task)
            self.tableView.reloadData()
        })
        present(alert, animated: true)
    }
    
    // MARK: - Table Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = store.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.accessoryType = task.isCompleted ? .checkmark : .none
        return cell
    }
    
    // MARK: - Table Delegate
    // Reloads just that row to update its checkmark, with a default animation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = store.tasks[indexPath.row]
        store.toggleCompletion(of: task)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
        // Delegate method: called when the user swipes to delete a row
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            // if the style is .delete, tells the store to remove that taks (by index), then animates deleting row from the table view.
            if editingStyle == .delete {
                store.delete(at: IndexSet(integer: indexPath.row))
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
//    //MARK: - Custom Swipe Actions (iOS 11+)
//    override func tableView(_ tableView: UITableView,
//                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
//    ) -> UISwipeActionsConfiguration? {
//        // 1. Create a “Remove” action
//        let delete = UIContextualAction(style: .destructive, title: "Trash") { action, view, completion in
//            // Update the model
//            self.store.delete(at: IndexSet(integer: indexPath.row))
//            // Animate the row removal
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            completion(true)
//        }
//        
//        // 2. Wrap it in a configuration
//        let config = UISwipeActionsConfiguration(actions: [delete])
//        config.performsFirstActionWithFullSwipe = true  // full-swipe performs delete
//        return config
//    }
//}
