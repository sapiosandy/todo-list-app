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
        navigationItem.rightBarButtonItem =
          UIBarButtonItem(barButtonSystemItem: .add,
                          target: self,
                          action: #selector(addTask))
    }

    // 3. Always reload before showing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Add Task

    @objc private func addTask() {
        let alert = UIAlertController(title: "New Task",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter task"
        }
        alert.addAction(.init(title: "Cancel", style: .cancel))
        alert.addAction(.init(title: "Add", style: .default) { _ in
            guard let text = alert.textFields?.first?.text,
                  !text.isEmpty else { return }
            let task = Task(title: text)
            self.store.add(task)
            self.tableView.reloadData()
        })
        present(alert, animated: true)
    }

    // MARK: - Table Data Source

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return store.tasks.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath)
                            -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = store.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.accessoryType = task.isCompleted ? .checkmark : .none
        return cell
    }

    // MARK: - Table Delegate

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let task = store.tasks[indexPath.row]
        store.toggleCompletion(of: task)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            store.delete(at: IndexSet(integer: indexPath.row))
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
