//
//  TaskConditionTests.swift
//  Overdrive
//
//  Created by Said Sikira on 7/2/16.
//  Copyright © 2016 Said Sikira. All rights reserved.
//

import XCTest
import TestSupport
@testable import Overdrive

class TaskConditionTests: XCTestCase {
    
    let queue = TaskQueue(qos: .default)
    
    class FailedTestCondition: TaskCondition {
        func evaluate<T>(forTask task: Task<T>, evaluationBlock: ((TaskConditionResult) -> Void)) {
            evaluationBlock(.failed(TaskError.fail("Condition not satisfied")))
        }
    }
    
    class SatisfiedTestCondition: TaskCondition {
        func evaluate<T>(forTask task: Task<T>, evaluationBlock: ((TaskConditionResult) -> Void)) {
            evaluationBlock(.satisfied)
        }
    }
    
    /// Tests failed condition
    func testFailedCondition() {
        let task = SimpleTask()
        let condition = FailedTestCondition()
        task.add(condition: condition)
        
        XCTAssert(task.conditions.count == 1, "Task condition count is not 1")
        XCTAssert(task.conditionErrors.count == 0, "Task condition error count should be 0")
        
        let expectation = self.expectation(description: "Task failed condition expecation")
        
        task
            .onValue { value in
                XCTAssert(false, "onValue block should not be executed")
            }.onError { error in
                XCTAssert(task.conditionErrors.count == 1, "Condition error count should be 1")
                expectation.fulfill()
        }
        
        TaskQueue(qos: .default).addTask(task)
        
        waitForExpectations(timeout: 1) {
            handlerError in
            print(handlerError)
        }
    }
    
    ///Tests satisfied condition
    func testSatisfiedCondition() {
        let task = SimpleTask()
        let condition = SatisfiedTestCondition()
        task.add(condition: condition)
        
        XCTAssert(task.conditions.count == 1, "Task condition count is not 1")
        XCTAssert(task.conditionErrors.count == 0, "Task condition error count should be 0")
        
        let expectation = self.expectation(description: "Satisfied condition expecation")
        
        task
            .onValue { value in
                XCTAssert(task.conditionErrors.count == 0, "Condition error count should be 1")
                expectation.fulfill()
            }.onError { error in
                XCTAssert(false, "onError block should not be executed")
        }
        
        TaskQueue(qos: .default).addTask(task)
        
        waitForExpectations(timeout: 1) {
            handlerError in
            print(handlerError)
        }
    }

}
