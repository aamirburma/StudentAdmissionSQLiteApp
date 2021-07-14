//
//  StudentDetailVC.swift
//  StudentManageSQLite
//
//  Created by Aamir Burma on 14/07/21.
//

import UIKit

import UIKit

class StudentDetailVC: UIViewController {

    private var notice = [Notice]()
    var strData = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hello Student"
        view.backgroundColor = .systemRed
        view.addSubview(myLabel)
        view.addSubview(myTextField)
        view.addSubview(myTextField1)
        view.addSubview(myTextField2)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "College3.jpg")!)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myTextField.frame = CGRect(x: 20,y: 300, width: view.width - 40, height: 50)
        myTextField1.frame = CGRect(x: 20,y: myTextField.bottom + 20, width: view.width - 40, height: 50)
        myTextField2.frame = CGRect(x: 20,y: myTextField1.bottom + 20, width: view.width - 40, height: 50)
        
        myLabel.frame = CGRect(x: 20,y: myTextField2.bottom + 20, width: view.width - 40, height: 50)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        notice = SQLiteHandler.shared.fetchNotice()
        let countRecords = notice.count - 1
        if notice.count > 0{
            strData = notice[countRecords].note
        }
        super.viewDidAppear(animated)
        myLabel.text = "New notice is : \(strData)"
        myTextField.text = "Student Name : \(UserDefaults.standard.value(forKey: "name")!)"
        myTextField1.text = "Student Age : \(UserDefaults.standard.value(forKey: "age")!)"
        myTextField2.text = "Student SPID : \(UserDefaults.standard.value(forKey: "spid")!)"
    }
    
    private let myLabel:UILabel = {
        let myLabel = UILabel()
//        myLabel.text = "New Notice is : \(strDa)! "
        myLabel.textAlignment = .center
        myLabel.textColor = .white
        myLabel.layer.cornerRadius = 6
        myLabel.backgroundColor = .darkGray
        return myLabel
    }()
    
    private let myTextField:UITextField = {
        let myUITextField = UITextField()
        myUITextField.isUserInteractionEnabled = false
        myUITextField.textColor = .systemGreen
        myUITextField.autocorrectionType = .no
        myUITextField.autocapitalizationType = .none
        myUITextField.borderStyle = .roundedRect
        myUITextField.textAlignment = .center
        myUITextField.borderStyle = .roundedRect
        return myUITextField
    }()
    
    private let myTextField1:UITextField = {
        let myUITextField = UITextField()
        myUITextField.isUserInteractionEnabled = false
        myUITextField.textColor = .systemGreen
        myUITextField.autocorrectionType = .no
        myUITextField.autocapitalizationType = .none
        myUITextField.borderStyle = .roundedRect
        myUITextField.textAlignment = .center
        myUITextField.borderStyle = .roundedRect
        return myUITextField
    }()
    
    private let myTextField2:UITextField = {
        let myUITextField = UITextField()
        myUITextField.isUserInteractionEnabled = false
        myUITextField.textColor = .systemGreen
        myUITextField.autocorrectionType = .no
        myUITextField.autocapitalizationType = .none
        myUITextField.borderStyle = .roundedRect
        myUITextField.textAlignment = .center
        myUITextField.borderStyle = .roundedRect
        return myUITextField
    }()


}
