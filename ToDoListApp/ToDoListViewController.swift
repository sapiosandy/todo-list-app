//
//  ToDoListViewController.swift
//  ToDoListApp
//
//  Created by Sandra Gomez on 5/3/25.
//

import Foundation
import UIKit

class ToDoListViewController: UITableViewController {
    private let store = TaskStore.shared
    
    // MARK: – Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To-Do"
        // Enable large titles
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Make sure this view controller displays a large title
        navigationItem.largeTitleDisplayMode = .always
        // Align the title to the right
        if let navigationBar = navigationController?.navigationBar {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .right
            navigationBar.largeTitleTextAttributes = [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 36, weight: .bold)
            ]
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: – Add Task
    
    @objc private func addTask() {
        let alert = UIAlertController(title: "New Task", message: "\n\n\n\n\n",preferredStyle: .alert)
        alert.addTextField { tf in tf.placeholder = "Enter task" }
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels // Looks good in alert
        datePicker.frame = CGRect(x: 0, y: 50, width: 270, height: 100)
        
        // Add the date pikcer to the alert's view
        alert.view.addSubview(datePicker)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        )
        alert.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            guard let text = alert.textFields?.first?.text,!text.isEmpty else { return }
            let task = Task(title: text)
            self.store.add(task)
            self.tableView.reloadData()
        }
        )
        present(alert, animated: true)
    }
    
    // MARK: – Table Data Source
    
    override func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return store.tasks.count
    }
    
    override func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        let task = store.tasks[indexPath.row]
        // If completed, show strikethrough. If not, show normal text.
        if task.isCompleted {
            let attributedString = NSMutableAttributedString(string: task.title)
            attributedString.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSMakeRange(0, attributedString.length)
            )
            cell.textLabel?.attributedText = attributedString
        } else {
            cell.textLabel?.attributedText = nil
            cell.textLabel?.text = task.title
        }
        
        // Remove the checkmark
        cell.accessoryType = .none
        return cell
    }

    // MARK: – Table Delegate

    override func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        let task = store.tasks[indexPath.row]
        store.toggleCompletion(of: task)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    // MARK: – Swipe Actions (Delete + Edit)

    override func tableView(_ tableView: UITableView,trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 1️⃣ Delete action
        let delete = UIContextualAction(style: .destructive, title: "Remove") { _, _, completion in
            self.store.delete(at: IndexSet(integer: indexPath.row))
            tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }

        // 2️⃣ Edit action
        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, completion in
            let task = self.store.tasks[indexPath.row]
            let alert = UIAlertController(title: "Edit Task",message: "\n\n\n\n\n", preferredStyle: .alert)
            
            // Title text field
            alert.addTextField { tf in tf.text = task.title }
            
            
            // Date Picker
            
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.frame = CGRect(x: 0, y: 50, width: 270, height: 100)
            // Set date picker's initial value (use task.dueDate or today)
            if let due = task.dueDate {
                datePicker.date = due
            }
            alert.view.addSubview(datePicker)
            
            
            
            alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
                guard let newText = alert.textFields?.first?.text, !newText.isEmpty else { return }
                self.store.update(task, newTitle: newText, newDueDate: datePicker.date)
                tableView.reloadRows(at: [indexPath], with: .automatic)
              })
            // Cancel action
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            completion(true)
        }
        edit.backgroundColor = UIColor.systemBlue

        // 3️⃣ Combine into configuration
        let config = UISwipeActionsConfiguration(actions: [delete, edit])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

