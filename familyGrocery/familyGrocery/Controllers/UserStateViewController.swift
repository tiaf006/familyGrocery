//
//  UserStateViewController.swift
//  familyGrocery
//
//  Created by TAIF Al-zahrani on 14/06/1444 AH.
//

import UIKit
import Firebase

class UserStateViewController: UIViewController {
// MARK: - vars
    static var currentUser = User()
    private var handle: AuthStateDidChangeListenerHandle!
    
    
//MARK: - app lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n \n !!!!!!!!!!( \(String(describing: Auth.auth().currentUser?.email)) )!!!!!!!!!!!!! \n \n")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if handle != nil { return }
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            print("Auth status did change")
            self.dismiss(animated: true)
            if user != nil {
                self.goToGroceriesList()
                
            } else {
                self.goToLogin()
            }
        }
    }
        
// MARK: - Navigation
    private func goToLogin(){
        let loginVC = LogInViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    private func goToGroceriesList(){
        let groceryListVC = GroceriesListViewController()
        navigationController?.pushViewController(groceryListVC, animated: true)
        navigationItem.hidesBackButton = true
    }
}
