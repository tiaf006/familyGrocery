//
//  GroceriesViewController.swift
//  familyGrocery
//
//  Created by TAIF Al-zahrani on 14/06/1444 AH.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class GroceriesListViewController: UIViewController {
    var groceryItems = [GroceryItem]()
    let currentUser = Auth.auth().currentUser
    let ref = Database.database().reference(fromURL: "https://familygrocery-f098c-default-rtdb.firebaseio.com/")
    
    // MARK: - UI elements
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero)
        // using the cell controller we created as grocery table view cell
        tableView.register(GroceryItemTableViewCell.self, forCellReuseIdentifier: "itemCell")
        return tableView
    }()
    
    //MARK: - app lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGroceryItems()
    }
    
    override func viewDidLayoutSubviews() {
        layOut()
    }
    
    // MARK: - layout
    private func layOut(){
        navigationItem.title = "Grocery List"
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.backgroundColor = .white
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "griceryBackground")!)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(AddGroceryItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Online Users", style: .plain, target: self, action: #selector(goToOnlineUsers))
        
        //tableView constraints
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
    
    // MARK: - actions
    /*- display an alert for the user when they tap on the plus buttton
     - the alert will contain a textfiled for the user to enter the item name thay want to add to the database and the table view
     - when the user tap save that data base will create a new child node to the grocery-items node that contain the info of the new item that the user added
     
     */
    @objc private func AddGroceryItem(){
        print("add new item")
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        alert.addTextField { (textField: UITextField! ) -> Void in
            textField.placeholder = "Enter your item"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { addAlert -> Void in
        let itemTextField = alert.textFields![0] as UITextField
            
            if let groceryItem = itemTextField.text {
                if groceryItem != "" {
                    let usersRef =  self.ref.child("grocery-items").child(groceryItem)
                    let values: [String: Any] = ["item-name": groceryItem, "addedByUser": "Added By: \(String(describing: self.currentUser!.email!))", "isCompleted": "\(false)"]
                    usersRef.updateChildValues(values, withCompletionBlock: {(err, usersRef)in
                        if err != nil {
                            print(err )
                            return
                        }
                        print("Save user successfully into Firebase db") }
                    )
                }
            }
        })
        let cancleAction = UIAlertAction(title: "cancle", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancleAction)
        self.present(alert, animated: true)
    }
    
    func fetchGroceryItems() {
        Database.database().reference().child("grocery-items").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let item = GroceryItem()
                item.addedByUser = dictionary["addedByUser"] as? String
                item.isCompleated = dictionary["isCompleted"] as? Bool
                item.itemName = dictionary["item-name"] as? String
                self.groceryItems.append(item)
                self.tableView.reloadData()
                print ("!!!!!!!\(String(describing: item.addedByUser )), \(String(describing: item.itemName))!!!!")
            }
        }, withCancel: nil)
    }
    
    // MARK: - Navigation
    @objc private func goToOnlineUsers(){
        print("online users!")
        let onlineUsersVC = OnlineUsersListViewController()
        navigationController?.pushViewController(onlineUsersVC, animated: true)
    }
    
}

//MARK: - extentions
extension GroceriesListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.rowHeight = 80
      return  groceryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! GroceryItemTableViewCell
        cell.itemNameLable.text = groceryItems[indexPath.row].itemName
        cell.addedByUserLable.text = groceryItems[indexPath.row].addedByUser
        cell.backgroundColor = .clear
        return cell
    }
    /*- when the user swip the cell to left then 2 actions will appear
     - the first one is the delet action that will delete the item node from the grosery-items node when tapped
     - the second action is the edit action that will pop an alert with a text field for the user to enter the update that they want to perform on an exsiting item name and when save is tapped the item name will change in the database item node and on the table view as well
     */
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") {(action, view, compeletionHandler) in
            print("edit")
            let alert = UIAlertController(title: "Edit item", message: "", preferredStyle: .alert)
            alert.addTextField { (textField: UITextField! ) -> Void in
                textField.placeholder = "Enter your item"
            }
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { addAlert -> Void in
                let itemTextField = alert.textFields![0] as UITextField
                
                if let groceryItem = itemTextField.text {
                    if groceryItem != "" {
                        print(groceryItem)
                        self.ref.child("grocery-items").child(self.groceryItems[indexPath.row].itemName ?? "").updateChildValues(["item-name": groceryItem, "isCompleted":self.groceryItems[indexPath.row].isCompleated ?? false, "addedByUser": "Added By: \(Auth.auth().currentUser!.email!)"])
                        self.groceryItems[indexPath.row].itemName = groceryItem
                        self.groceryItems[indexPath.row].addedByUser = Auth.auth().currentUser!.email!
                        tableView.reloadData()
                    }
                }
            })
            let cancleAction = UIAlertAction(title: "cancle", style: .cancel)
            alert.addAction(saveAction)
            alert.addAction(cancleAction)
            self.present(alert, animated: true)
        }
        edit.backgroundColor = .systemMint
        
        let delete = UIContextualAction(style: .normal, title: "Delete") {(action, view, compeletionHandler) in
           print("delete")
            self.ref.child("grocery-items").child(self.groceryItems[indexPath.row].itemName ?? "").setValue(nil)
            self.groceryItems.remove(at: indexPath.row)
            tableView.reloadData()
        }
        delete.backgroundColor = .systemOrange
        
        let swip = UISwipeActionsConfiguration(actions: [edit, delete])
        return swip
    }
}
