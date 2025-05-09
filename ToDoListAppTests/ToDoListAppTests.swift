//
//  ToDoListAppTests.swift
//  ToDoListAppTests
//
//  Created by Sandra Gomez on 5/3/25.
//

import XCTest
@testable import ToDoListApp

final class ToDoListAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    func testAddingTaskIncreasesCount() {
        // Arrange: Start with a clean slate
        let store = TaskStore.shared
        store.tasks = []
        
        // Act: add one task
        store.add(Task(title: "Buy milk"))
        
        // Assert: count should now be 1
                XCTAssertEqual(store.tasks.count,1, "Adding a task should increase task.count to 1")
    }
    
    func testAddingEmptyTitleDoesNotIncreaseCount() {
        // Arrange
        let store = TaskStore.shared
        store.tasks = []
        
        //Act
        store.add(Task(title: "")) // empty string
        store.add(Task(title: "     ")) // spaces only
        
        // Assert
        XCTAssertEqual(store.tasks.count,0, "Tasks with empty or whitespace-only titles should not be added")
    }
    
    func testAddingDuplicateTaskDoesNotIncreaseCount() {
        let store = TaskStore.shared
        store.tasks = []

        let task = Task(title: "Buy milk")
        
        store.add(task)
        store.add(task) // duplicate title

        XCTAssertEqual(store.tasks.count, 1, "Duplicate tasks should not be added if the title already exists")
    }
    
    func testCaseInsensitiveDuplicateIsNotAdded() {
        let store = TaskStore.shared
        store.tasks = []

        store.add(Task(title: "Buy milk"))
        store.add(Task(title: "buy milk")) // same title, different case

        XCTAssertEqual(store.tasks.count, 1, "Task titles should be treated as duplicates regardless of case")
    }
    
    func testToggleCompletionChangesIsCompleted() {
        let store = TaskStore.shared
        store.tasks = []
        
        let task = Task(title: "Walk the dog", isCompleted: false)
        store.add(task)
        
        //Act: toggle completion
        store.toggleCompletion(of:task)
        
        // Assert: the task should now be completed
        XCTAssertTrue(store.tasks[0].isCompleted, "Task should be marked as completed after toggle")
    }
    
    func testToggleCompletionTwiceReturnsToOriginalState() {
        let store = TaskStore.shared
        store.tasks = []
        
        let task = Task(title: "Walk the dog", isCompleted: false)
        store.add(task)
        
        //Act: toggle twice
        store.toggleCompletion(of: task)
        store.toggleCompletion(of: task)
        
        // Assert: task should be incomplete again
        XCTAssertFalse(store.tasks[0].isCompleted, "Task should be marked as not completed after toggling twice")
    }

}

