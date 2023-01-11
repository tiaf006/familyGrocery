//
//  RegisterViewController.swift
//  familyGrocery
//
//  Created by TAIF Al-zahrani on 14/06/1444 AH.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class RegisterViewController: UIViewController {
// MARK: - UI elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.clipsToBounds = true
        return contentView
    }()
    
    private let nameField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name..."
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.keyboardType = .emailAddress
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let emailField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email Address..."
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.keyboardType = .emailAddress
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let passwordField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password..."
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.keyboardType = .default
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    private let registerButton : UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemBrown
        button.setTitleColor(.white, for: .normal)
        button.RounedButton()
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(RegisterAction), for: .touchUpInside)
        return button
    }()
        
//MARK: - app lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }
    override func viewDidLayoutSubviews() {
        addSubViews()
        layOut()
    }
    
    // MARK: - actions
    /*- this register func will check if the fields are not empty and if they are an error will pop up telling them to fill all the info and it will also chek if the info enterd are correct and if not an error will pop up saying the info invalid
     if everething is correct then it will register a new account and take the user to the grocery list
     - once the user is registered they will be added to the online users node as a user child node in the database
     */
    @objc private func RegisterAction(){
        print("registered")
        let alert = UIAlertController(title: "Error!", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(okAction)
        
        let email = emailField.text
        let password = passwordField.text
        let name = nameField.text
        
        if email?.isEmpty == true || password?.isEmpty == true || name?.isEmpty == true {
            alert.message = "Please Fill All The Information"
            self.present(alert, animated: true)
        }
        else if password!.count < 6 || email?.isEmail() == false {
            alert.title = "Envalid Email Or Password"
            alert.message = "- Password Must Be 6 Characters Or More \n - Use Valid Email Format"
            self.present(alert, animated: true)
        }
        else{
            Auth.auth().createUser(withEmail: email!, password: password!) { authResult, error in
                if error != nil {
                    alert.message = "\(error!.localizedDescription)"
                    self.present(alert, animated: true)
                }
                else{
                    let user = authResult!.user
                    
                    let ref = Database.database().reference(fromURL: "https://familygrocery-f098c-default-rtdb.firebaseio.com/")
                    ref.child("online-users").child(user.uid).setValue(["userID" : user.uid , "userEmail": user.email])
                    }
                }
            }
        }
    
    // MARK: - Navigation
    private func gotoGroceryList(){
        let groceryVC = GroceriesListViewController()
        navigationController?.pushViewController(groceryVC, animated: true)
    }
       
    
// MARK: - layout
    private func addSubViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(nameField)
        contentView.addSubview(emailField)
        contentView.addSubview(passwordField)
        contentView.addSubview(registerButton)
    }
    
    private func layOut(){
        navigationItem.title = "Register"
        view.backgroundColor = UIColor(patternImage: UIImage(named: "griceryBackground")!)
        
        //scrolView Constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor,constant: 4).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -4).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: 600)
        scrollView.isScrollEnabled = true
        
        //contentView Constraints
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.frame.size.height = view.frame.size.height + 400
        contentView.frame.size.width = view.frame.size.width
        contentView.widthAnchor.constraint(greaterThanOrEqualTo:  scrollView.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(greaterThanOrEqualTo:  scrollView.heightAnchor).isActive = true
        contentView.sizeToFit()

        //nameField Constraints
        nameField.translatesAutoresizingMaskIntoConstraints =  false
        nameField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 44).isActive = true
        nameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        nameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        nameField.heightAnchor.constraint(equalToConstant: 34).isActive = true

        //emailField Consteaints
        emailField.translatesAutoresizingMaskIntoConstraints =  false
        emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 24).isActive = true
        emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        //passwordField Constrants
        passwordField.translatesAutoresizingMaskIntoConstraints =  false
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 24).isActive = true
        passwordField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        passwordField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        //registerButton Constraints
        registerButton.translatesAutoresizingMaskIntoConstraints =  false
        registerButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 24).isActive = true
        registerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
    }
    
}
