//
//  UserStateViewController.swift
//  familyGrocery
//
//  Created by TAIF Al-zahrani on 14/06/1444 AH.
//

import UIKit
import Firebase
import FacebookCore
import FBSDKLoginKit
import FacebookLogin
class UserStateViewController: UIViewController {
    
    
// MARK: - vars
    static var currentUser = User()
    private var handle: AuthStateDidChangeListenerHandle!
    
    
//MARK: - app lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n \n !!!!!!!!!!( \(String(describing: Auth.auth().currentUser?.email)) )!!!!!!!!!!!!! \n \n")
    }
    //  the app will check is the user is logged in
    // if they are already logged in then they will be navigated to the grocery list
    // if not they will be navigated to the login screen to log in or register a new account
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = AccessToken.current,
               !token.isExpired {
            let token = token.tokenString
            let request = FBSDKLoginKit.GraphRequest(graphPath: "taif", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
            request.start(completionHandler: { connection, result, error in
                print(result)
            })
            self.goToGroceriesList()
           }
        
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

// MARK: - extentions
extension UserStateViewController : LoginButtonDelegate{
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        let request = FBSDKLoginKit.GraphRequest(graphPath: "taif", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
        request.start(completionHandler: { connection, result, error in
            print(result)
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }
    
    
}
