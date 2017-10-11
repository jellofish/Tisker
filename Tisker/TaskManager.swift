//
//  TaskManager.swift
//  Tasker
//
//  Created by Samantha Herdman on 10/6/17.
//  Copyright © 2017 Samantha J. Herdman. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TaskManager: NSObject {
    let entityName = "CountedTask"
    var countedTasks = Array<CountedTask>()
    
    func refreshTasks() {
       // where we can fetch update data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<CountedTask>(entityName: entityName)
        
        do {
            countedTasks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print( "Could not fetch. \(error), (error.userInfo)")
        }

    }
    
    func saveTasks() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

    }
    
    func taskAt(_ atIndex: Int) -> CountedTask? {
        if atIndex < countedTasks.count {
            return countedTasks[atIndex]
        }
        
        return nil
    }
    
    func allTasks() -> Array<CountedTask> {
        return countedTasks
    }
    
    func addTask(taskName: String, maxCount: Int16, currentCount: Int16, isMax: Bool) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)
        
        let countedTask = NSManagedObject(entity: entity!, insertInto: managedContext) as! CountedTask
        
        countedTask.setValue(NSUUID().uuidString, forKeyPath: "id")
        countedTask.setValue(taskName, forKeyPath: "taskName")
        countedTask.setValue(maxCount, forKeyPath: "maxCount")
        countedTask.setValue(currentCount, forKeyPath: "currentCount")
        countedTask.setValue(isMax, forKeyPath: "isMax")
        
        
        do {
            try managedContext.save()
            countedTasks.append(countedTask)
            return true
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }

    }
    
    func removeTask(_ atIndex: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(countedTasks[atIndex])
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        refreshTasks()
    }
    
    func taskWith(id: String) -> CountedTask? {
        for item in countedTasks {
            if item.id == id {
                return item
            }
        }
        
        return nil
    }
    
    func tasksWith(taskName: String) -> [CountedTask] {
        var tasks = Array<CountedTask>()
        
        for item in countedTasks {
            if item.taskName == taskName {
                tasks.append(item)
            }
        }
        
        return tasks
    }
    
    func incrementTaskCount(_ atIndex: Int) {
        if atIndex < countedTasks.count {
            let thisTask = countedTasks[atIndex]
            if let value = thisTask.value(forKeyPath: "currentCount") as? Int16 {
                thisTask.setValue(value + 1, forKeyPath: "currentCount")
                saveTasks()
            }
        }
        
    }
    
    func resetTaskCount(_ atIndex: Int) {
        if atIndex < countedTasks.count {
            countedTasks[atIndex].setValue(0, forKeyPath: "currentCount")
        }
        
        saveTasks()
    }
    
    func resetTaskCountFor(task: CountedTask) {
        task.setValue(0, forKeyPath: "currentCount")
    }
    
    func resetAllTaskCounts() {
        let _ = countedTasks.map {
            resetTaskCountFor(task: $0)
        }
    }
    
    func updateTask(_ atIndex: Int, taskName: String, maxCount: Int16, currentCount: Int16, isMax: Bool) {
        
        if atIndex < countedTasks.count {
            countedTasks[atIndex].setValue(taskName, forKeyPath: "taskName")
            countedTasks[atIndex].setValue(maxCount, forKeyPath: "maxCount")
            countedTasks[atIndex].setValue(currentCount, forKeyPath: "currentCount")
            countedTasks[atIndex].setValue(isMax, forKeyPath: "isMax")
        }
        
        saveTasks()
    }
    
    
    func addTestData() {
        let _ = addTask(taskName: "Digital book purchase", maxCount: 10, currentCount:0, isMax: true)
        let _ = addTask(taskName: "Restaurant dinner", maxCount: 10, currentCount: 0, isMax: true)

    }

}
