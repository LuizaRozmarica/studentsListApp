//
//  MainTableViewController.swift
//  studentsList
//
//  Created by Луиза Розмарица on 26.04.2021.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {
    
    
    var students: Results<Student>!

    override func viewDidLoad() {
        super.viewDidLoad()

        students = realm.objects(Student.self)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editing))
    }
    
    @objc func editing() {
        tableView.isEditing = !tableView.isEditing
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.isEmpty ? 0 : students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell {
            
            let student = students[indexPath.row]
            cell.nameLabel.text = student.name + " " + student.lastName
            cell.markLabel.text = student.mark
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let student = students[indexPath.row]
            StorageManager.deleteObject(student)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//        let student = students[indexPath.row]
//        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
//            StorageManager.deleteObject(student)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//        return [deleteAction]
//    }
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let student = students[indexPath.row]
            guard let vc = segue.destination as? EditVC else { return }
            vc.currentStudent = student
        }
    }

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let editVC = segue.source as? EditVC else { return }
        
        editVC.saveStudent()
        tableView.reloadData()
    }
    

}
