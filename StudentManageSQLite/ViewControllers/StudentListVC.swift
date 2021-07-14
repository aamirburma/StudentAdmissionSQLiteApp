//
//  StudentListVC.swift
//  StudentManageSQLite
//
//  Created by Aamir Burma on 14/07/21.
//

import UIKit

class StudentListVC: UIViewController {

    private var studArray = [Student]()
        private let studTabelView = UITableView()
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            studTabelView.frame = view.bounds
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "College2.jpg")!)
            studArray = SQLiteHandler.shared.fetchStud()
//            studArray = CoreDataHandler.shared.fetch()
            
            if UserDefaults.standard.object(forKey:"sessionToken") == nil{
                logoutAdmin()
            }
            studTabelView.reloadData()
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Students List"
            view.addSubview(studTabelView)
            let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewStudent))
            let addItem3 = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addNewNotice))
            let addItem2 = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(logoutAdmin))
    //        navigationItem.setRightBarButton(addItem, animated: true)
            navigationItem.setLeftBarButton(addItem2, animated: true)
            navigationItem.setRightBarButtonItems([addItem,addItem3], animated: true)
            setupTableView()
            // Do any additional setup after loading the view.
        }
        
        @objc private func addNewStudent(){
            let vc = NewStudentVC()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        @objc private func addNewNotice(){
            let vc = NewNoticeVC()
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
        @objc private func logoutAdmin(){
            UserDefaults.standard.setValue(nil, forKey: "sessionToken")
            UserDefaults.standard.setValue(nil, forKey: "username")
    //        let vc = ViewController()
    //        navigationController?.pushViewController(vc, animated: true)
    //        vc.reloadInputViews()
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            studTabelView.frame = view.bounds
        }
    }
    extension StudentListVC: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            studArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "stud", for: indexPath)
            let stud = studArray[indexPath.row]
            cell.textLabel?.text = "\(stud.name) \t | \t \(stud.age) \t | \t \(stud.spid)"
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = NewStudentVC()
            vc.studets = studArray[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            let id = studArray[indexPath.row].id
            SQLiteHandler.shared.deleteStud(for: id){ [weak self] success in
                if(success){
                    self?.studArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }else{
                    let alert = UIAlertController(title: "Ooppss!", message: "There is a problem in deleting", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel))
                    DispatchQueue.main.async {
                        self?.present(alert, animated: true)
                    }
                }
            }
        }
        
        private func setupTableView(){
            studTabelView.register(UITableViewCell.self, forCellReuseIdentifier: "stud")
            studTabelView.delegate = self
            studTabelView.dataSource = self
        }
    }
