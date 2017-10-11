//
//  DetailTableViewController.swift
//  Tasker
//
//  Created by Samantha Herdman on 10/9/17.
//  Copyright © 2017 Samantha J. Herdman. All rights reserved.
//

import UIKit

protocol TaskDetailDelegate {
    func addTask(taskName: String, maxCount: Int16, isMax: Bool) -> Bool
    func upDateTask(taskName: String, maxCount: Int16, isMax: Bool)
}

class DetailTableViewController: UITableViewController {
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var minmaxLabel: UILabel!
    @IBOutlet weak var minmaxSwitch: UISegmentedControl!
    @IBOutlet weak var maxCountLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var taskName: String?
    var maxCount: Int16?
    var isNew = true
    var isMax = false
    
    var delegate: TaskDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        taskNameTextField?.text = taskName ?? ""
        maxCountLabel?.text = String(maxCount ?? 1)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    @IBAction func saveTapped(_ sender: Any?) {
        if let taskName = taskNameTextField?.text  {
            if !taskName.isEmpty {
                if self.delegate?.addTask(taskName: taskName, maxCount: maxCount ?? 1, isMax: isMax) == true {
                    let _ = navigationController?.popViewController(animated: true)
                } else {
                    // hmm?
                }
            } else {
                taskNameTextField.placeholder = "Please enter a task name!"
            }
        }
    }
    
    @IBAction func stepperTapped(_ sender: UIStepper) {
        maxCount = Int16(sender.value)
        maxCountLabel.text = "\(maxCount!)"
    }
    
    @IBAction func minmaxToggled(_ sender: UISegmentedControl) {
        isMax = sender.selectedSegmentIndex == 1
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


