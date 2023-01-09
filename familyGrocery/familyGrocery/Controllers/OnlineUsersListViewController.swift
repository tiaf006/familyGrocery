//
//  OnlineUsersListViewController.swift
//  familyGrocery
//
//  Created by TAIF Al-zahrani on 14/06/1444 AH.
//

import UIKit
import Firebase
import FirebaseAuth

class OnlineUsersListViewController: UIViewController {
    var users = [User] ()
    // MARK: - UI elements
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    private  let searchController = UISearchController()
    
    //MARK: - app lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
    }
    
    override func viewDidLayoutSubviews() {
        layOut()
    }
    
    
    // MARK: - actions
    func fetchUsers() {
        Database.database().reference().child("online-users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
                let user = User()
                user.userID = dictionary["userID"]
                user.userEmail = dictionary["userEmail"]
                user.userName = ""
                self.users.append(user)
                self.tableView.reloadData()
                //print ("!!!!!!!\(String(describing: item.addedByUser )), \(String(describing: item.itemName))!!!!")
            }
        }, withCancel: nil)
    }
    
    // MARK: - Navigation
    @objc private func goToLogin(){
        print("back to login")
        let ref = Database.database().reference(fromURL: "https://familygrocery-f098c-default-rtdb.firebaseio.com/")
        ref.child("online-users").child(Auth.auth().currentUser!.uid).setValue(nil)
        tableView.reloadData()
        try! Auth.auth().signOut()
        //let loginVC = LogInViewController()
       // navigationController?.pushViewController(loginVC, animated: true)
    }
    
    // MARK: - layout
    private func layOut(){
        navigationItem.title = "Online Users"
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(goToLogin))
        
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
        
        searchController.loadViewIfNeeded()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.placeholder = "Search..."
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
}

//MARK: - extentions
extension OnlineUsersListViewController : UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = users[indexPath.row].userEmail!
        return cell
    }
}
