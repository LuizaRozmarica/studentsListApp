//
//  EditVC.swift
//  studentsList
//
//  Created by Луиза Розмарица on 27.04.2021.
//

import UIKit

class EditVC: UITableViewController {
    
    var currentStudent: Student?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var markTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //"скрыть" ненужную разлиновку
        tableView.tableFooterView = UIView()
        
        //создать toolbar для markTextField
        createMarkToolbar()
        
        //проверки textField на соответсвие условиям
        nameTextField.addTarget(self, action: #selector(isNameCorrect), for: .editingDidEnd)
        lastNameTextField.addTarget(self, action: #selector(isNameCorrect), for: .editingDidEnd)
        markTextField.addTarget(self, action: #selector(isMarkCorrect), for: .editingDidEnd)
        
        //кнопка "сохранить" отключена, пока поля не заполнены корректно
        saveButton.isEnabled = false
        nameTextField.addTarget(self, action: #selector(tfEditingChanged), for: .editingDidEnd)
        lastNameTextField.addTarget(self, action: #selector(tfEditingChanged), for: .editingDidEnd)
        markTextField.addTarget(self, action: #selector(tfEditingChanged), for: .editingDidEnd)
        
        //экран редактирования ученика
        setupEditScreen()
    }
    
    //методы для экрана редактирования ученика
    private func setupEditScreen() {
        if currentStudent != nil {
            setupNavBar()
            nameTextField.text = currentStudent?.name
            lastNameTextField.text = currentStudent?.lastName
            markTextField.text = currentStudent?.mark
        }
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = nil
        title = "Редактировать ученика"
        //saveButton.isEnabled = true
    }
    
    //проверки для nameTextField и lastNameTextField
    @objc func isNameCorrect(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let ruCharacters = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя"
        let engCharacters = "abcdefghijklmnopqrstuvwxyz"
        text.lowercased().forEach { (char) in
            if ruCharacters.contains(char) == false && engCharacters.contains(char) == false {
                nameAlert(textField)
            }
        }
    }
    
    private func nameAlert(_ textField: UITextField) {
        let alert = UIAlertController(title: nil, message: "Ввести можно только русские или английские символы без пробелов", preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        textField.text = ""
    }
    
    //создание toolbar и кнопки done для markTextField
    private func createMarkToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneAction))
        toolbar.setItems([doneButton], animated: true)
        markTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneAction() {
        view.endEditing(true)
    }
    
    //проверки для markTextField
    @objc func isMarkCorrect() {
        guard let text = Int(markTextField.text!) else { return markAlert() }
        let range = (1...5)
        if range.contains(text) == false {
            markAlert()
        }
    }

    private func markAlert() {
        let alert = UIAlertController(title: nil, message: "Ввести можно только одно целое число от 1 до 5", preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        markTextField.text = ""
    }

    //сохранение ученика
    func saveStudent() {
        
        let newStudent = Student(name: nameTextField.text!, lastName: lastNameTextField.text!, mark: markTextField.text!)
        
        if currentStudent != nil {
            //в режиме редактирования ученика
            try! realm.write {
                currentStudent?.name = newStudent.name
                currentStudent?.lastName = newStudent.lastName
                currentStudent?.mark = newStudent.mark
            }
        } else {
            //в режиме добавления нового ученика
            StorageManager.saveObject(newStudent)
        }
    }
        
    //метод для кнопки "отмена"
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
        
       
    }


// MARK: - Text field delegate

extension EditVC: UITextFieldDelegate {
    
    //скрыть клавиатуру по нажатию на "готово"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //метод проверяет заполнены ли поля
    @objc private func tfEditingChanged() {
        if nameTextField.text?.isEmpty == false &&
            lastNameTextField.text?.isEmpty == false &&
            markTextField.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    
    
}
