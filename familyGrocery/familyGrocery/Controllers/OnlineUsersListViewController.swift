//
//  OnlineUsersListViewController.swift
//  familyGrocery
//
//  Created by TAIF Al-zahrani on 14/06/1444 AH.
//

import UIKit
import Firebase
import FirebaseAuth

// this controller with display all the online users in the database in a table view

class OnlineUsersListViewController: UIViewController {
    var users = [User] ()
    let ref = Database.database().reference(fromURL: "https://familygrocery-f098c-default-rtdb.firebaseio.com/")

    // MARK: - UI elements
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    //MARK: - app lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
    }
    
    override func viewDidLayoutSubviews() {
        layOut()
    }
    
    // MARK: - actions
    //get all online users from the database and add them to the table view users array
    func fetchUsers() {
        Database.database().reference().child("online-users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
                let user = User()
                user.userID = dictionary["userID"]
                user.userEmail = dictionary["userEmail"]
                user.userName = ""
                self.users.append(user)
                self.tableView.reloadData()
            }
        }, withCancel: nil)
    }
    
    // MARK: - Navigation
    // once the user tapp on the logout button it they will be directed back to the login screen and their online user node will be deleted from the firebase until the log back in
    @objc private func goToLogin(){
        print("back to login")
        ref.child("online-users").child(Auth.auth().currentUser!.uid).setValue(nil)
        tableView.reloadData()
        try! Auth.auth().signOut()
    }
    
    // MARK: - layout
    private func layOut(){
        navigationItem.title = "Online Users"
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.backgroundColor = .white
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "griceryBackground")!)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(goToLogin))
        
        //tableView constrants
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        tableView.reloadData()
    }
    
}

//MARK: - extentions
extension OnlineUsersListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    // using a prototyoe cell to display the users online
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = users[indexPath.row].userEmail!
        cell.textLabel!.textColor = .white
        cell.textLabel!.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        cell.backgroundColor = .clear
        return cell
    }
}
