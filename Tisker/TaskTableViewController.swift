//
//  TaskTableViewController.swift
//  Tasker
//
//  Created by Samantha Herdman on 10/6/17.
//  Copyright © 2017 Samantha J. Herdman. All rights reserved.
//

import UIKit
import CoreData


class TaskTableViewController: UITableViewController {
    let taskManager = TaskManager()
    var currentTask: CountedTask?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.leftBarButtonItem = self.editButtonItem

        self.title = "Tisker"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskManager.refreshTasks()
        resetIfNeeded()
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        taskManager.saveTasks()
        super.viewWillDisappear(animated)
    }
    
    func resetIfNeeded() {
        let dateComponents = Calendar.current.dateComponents([.day], from: Date())
        
        if dateComponents.day == 1 {
            taskManager.resetAllTaskCounts()
            taskManager.refreshTasks()
        }
    }
    
    func addTestData() {
        taskManager.addTestData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskManager.allTasks().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath as IndexPath)

        // Configure the cell...
        
        if let taskItem = taskManager.taskAt(indexPath.row) {
            cell.textLabel?.text = taskItem.taskName
            
            
            if taskItem.currentCount >= taskItem.maxCount {
                if taskItem.isMax {
                    cell.detailTextLabel?.textColor = UIColor.red
                    cell.detailTextLabel?.text = "\(taskItem.currentCount) of \(taskItem.maxCount)"
                    if taskItem.currentCount > taskItem.maxCount {
                        cell.detailTextLabel?.text = "\(cell.detailTextLabel?.text ?? "Hmm?") Tsk!"
                    }
                } else {
                    cell.detailTextLabel?.textColor = UIColor.black
                    cell.detailTextLabel?.text = "\(taskItem.currentCount)!"
                }

            } else {
                cell.detailTextLabel?.textColor = UIColor.black
                cell.detailTextLabel?.text = "\(taskItem.maxCount - taskItem.currentCount) left"
            }
            
        } else {
            cell.textLabel?.text = "unknown"
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing != true {
            taskManager.incrementTaskCount(indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            
        }
    }
    


    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            taskManager.removeTask(indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        } else if editingStyle == .insert {
            print("Insert")
        }
        
        tableView.reloadData()
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaskDetailSegue" {
            if let vc = segue.destination as? DetailTableViewController {
                vc.delegate = self
            }
        }
    }
}

extension TaskTableViewController: TaskDetailDelegate {
    func addTask(taskName: String, maxCount: Int16, isMax: Bool) -> Bool{
        return taskManager.addTask(taskName: taskName, maxCount: maxCount, currentCount: 0, isMax: isMax)
    }
    
    func upDateTask(taskName: String, maxCount: Int16, isMax: Bool) {
        
    }
}

