//
//  NewStudentVC.swift
//  StudentManageSQLite
//
//  Created by Aamir Burma on 14/07/21.
//
import UIKit

class NewStudentVC: UIViewController {

    var studets:Student?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    private let nameTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Student Name"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemFill
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let ageTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Age"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemFill
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let spidTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "SPID"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemFill
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let saveButton:UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveStudent), for: .touchUpInside)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 6
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Student Data"
        view.backgroundColor = .white
        view.addSubview(nameTextField)
        view.addSubview(spidTextField)
        view.addSubview(ageTextField)
        view.addSubview(saveButton)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "College2.jpg")!)
        
        if let stud = studets {
            nameTextField.text = stud.name
            ageTextField.text = String(stud.age)
            spidTextField.text = String(stud.spid)
            title = "Update Student Data"
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        nameTextField.frame = CGRect(x: 40, y: 300, width: view.width - 80, height: 40)
        ageTextField.frame = CGRect(x: 40, y: nameTextField.bottom + 20, width: view.width - 80, height: 40)
        spidTextField.frame = CGRect(x: 40, y: ageTextField.bottom + 20, width: view.width - 80, height: 40)
        saveButton.frame = CGRect(x: 40, y: spidTextField.bottom + 20, width: view.width - 80, height: 40)
    }
    
    @objc private func saveStudent(){
        let name = nameTextField.text!
        let age = Int(ageTextField.text!)!
        let spid = Int(spidTextField.text!)!
        
        if let stud = studets{
            let stud = Student(id: stud.id, name: name, age: age, spid: spid)
            update(stud: stud)
        }
        else{
            
            let stud = Student(id: 0, name: name, age: age, spid: spid)
            insert(stud: stud)
        }
    }
    
    private func insert(stud: Student){
        SQLiteHandler.shared.insertStud(stud: stud){ [weak self] success in
            if(success){
                let alert = UIAlertController(title: "Success!", message: "Data saved successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler:{
                    [ weak self ] _ in
                    self?.navigationController?.popViewController(animated: true)}))
                DispatchQueue.main.async {
                    self?.present(alert, animated: true)
                }
            }
            else{
                let alert = UIAlertController(title: "Ooppss!", message: "There is a problem in saving", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel))
                DispatchQueue.main.async {
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    
    private func update(stud: Student){
        SQLiteHandler.shared.updateStud(stud: stud){ [weak self] success in
            if(success){
                let alert = UIAlertController(title: "Success!", message: "Data updated successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler:{
                    [ weak self ] _ in
                    self?.navigationController?.popViewController(animated: true)}))
                DispatchQueue.main.async {
                    self?.present(alert, animated: true)
                }
            }
            else{
                let alert = UIAlertController(title: "Ooppss!", message: "There is a problem in updating", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel))
                DispatchQueue.main.async {
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}
