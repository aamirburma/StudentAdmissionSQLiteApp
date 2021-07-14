//
//  NewNoticeVC.swift
//  StudentManageSQLite
//
//  Created by Aamir Burma on 14/07/21.
//

import UIKit

class NewNoticeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Notice for students"
        view.backgroundColor = .systemTeal
        view.addSubview(saveButton)
        view.addSubview(noticeTextArea)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "College2.jpg")!)
        // Do any additional setup after loading the view.
    }
    
    
    private let noticeTextArea:UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemFill
        textView.textColor = .white
        textView.layer.cornerRadius = 6
        return textView
    }()
    
    private let saveButton:UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveNotice), for: .touchUpInside)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 6
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noticeTextArea.frame = CGRect(x: 40, y: 180, width: view.width - 80, height: 300)
        saveButton.frame = CGRect(x: 40, y: noticeTextArea.bottom + 20, width: view.width - 80, height: 30)
    }
    
    @objc private func saveNotice(){
        let name = noticeTextArea.text!
        SQLiteHandler.shared.insertNotice(note: name){
                [weak self] success in
            if(success){
                self?.navigationController?.popViewController(animated: true)
                print("Insert Successfully")
                
            }
        }
    }

}
