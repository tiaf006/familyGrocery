//
//  LogInViewController.swift
//  familyGrocery
//
//  Created by TAIF Al-zahrani on 14/06/1444 AH.
//

import UIKit
import FirebaseAuth
import Firebase
import FacebookLogin

class LogInViewController: UIViewController {
    // MARK: - UI elements
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let contentView : UIView = {
        let contentView = UIView()
        contentView.clipsToBounds = true
        return contentView
    }()
    
    private let logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "groceryLOGO")
        return imageView
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
    
    private let loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        // button.backgroundColor = UIColor(cgColor: CGColor(red: T##CGFloat, green: T##CGFloat, blue: T##CGFloat, alpha: T##CGFloat))
        button.backgroundColor = .systemBrown
        button.setTitleColor(.white, for: .normal)
        button.RounedButton()
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(LogInAction), for: .touchUpInside)
        return button
    }()
    
    private let registerLable : UILabel = {
        let lable =  UILabel()
        lable.text = "Don't Have An Account Yet?"
        lable.textColor = .white
        lable.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return lable
    }()
    
    private let goToRegisterButton : UIButton = {
        let button = UIButton()
        button.setTitle("Register Now!", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
        return button
    }()
    // face book login not working
    private let facebookLogin : UIButton = {
        let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
        return button
    }()
    
    //MARK: - app lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        addSubViews()
        layOut()
    }
    
    // MARK: - actions
    /*- this login func will check if the fields are not empty and if they are an error will pop up telling them to fill all the info and it will also chek if the info enterd are correct and if not an erreo will pop up saying the info invalid
     -then it will check if the user exsests on the authntication in the database
     if so it will take them to the grocery list  and if not an error will pop up saying the user not exsiting
     - once the user is sighned in they will be added to the online users node as a user child node in the database
     */
    @objc private func LogInAction(){
        print("logged in")
        let alert = UIAlertController(title: "Error!", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(okAction)
        
        let email = emailField.text
        let password = passwordField.text
        
        if email?.isEmpty == true || password?.isEmpty == true {
            alert.message = "Please Fill All The Information"
            self.present(alert, animated: true)
        }
        else if password!.count < 6 || email?.isEmail() == false {
            alert.title = "Envalid Email Or Password"
            alert.message = "- Password Must Be 6 Characters Or More \n - Use Valid Email Format"
            self.present(alert, animated: true)
        }
        else{
            Auth.auth().signIn(withEmail: email!, password: password!) { authResult, error in
                if error != nil {
                    alert.message = "\(error!.localizedDescription)"
                    self.present(alert, animated: true)
                }
                else{
                    let user = authResult!.user
                    print(user)
                    
                    let ref = Database.database().reference(fromURL: "https://familygrocery-f098c-default-rtdb.firebaseio.com/")
                    ref.child("online-users").child(user.uid).setValue(["userID" : user.uid , "userEmail": user.email])
                }
            }
        }
    }
    
    @objc private func facebookLoginAction(){
        print("facebooook")
    }
    
// MARK: - Navigation
    @objc private func goToRegister(){
         print("go to registerr")
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
       }
    
    private func gotoGroceryList(){
        let groceryVC = GroceriesListViewController()
        navigationController?.pushViewController(groceryVC, animated: true)
    }
    
// MARK: - layout
        private func addSubViews(){
            view.addSubview(scrollView)
            scrollView.addSubview(contentView)
            contentView.addSubview(logoImageView)
            contentView.addSubview(emailField)
            contentView.addSubview(passwordField)
            contentView.addSubview(loginButton)
            contentView.addSubview(registerLable)
            contentView.addSubview(goToRegisterButton)
            contentView.addSubview(facebookLogin)
        }
        
        private func layOut(){
            navigationItem.title = "Log In"
            navigationItem.hidesBackButton = true
            view.backgroundColor = UIColor(patternImage: UIImage(named: "griceryBackground")!)
            
            //scrolView Constraints
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.topAnchor.constraint(equalTo: view.topAnchor,constant: 4).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -4).isActive = true
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            scrollView.contentSize = CGSize(width: view.frame.width, height: 700)
            scrollView.isScrollEnabled = true
            
            //contentView Constraints
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            contentView.frame.size.height = view.frame.size.height + 400
            contentView.frame.size.width = view.frame.size.width
            contentView.widthAnchor.constraint(greaterThanOrEqualTo:  scrollView.widthAnchor).isActive = true
            contentView.heightAnchor.constraint(greaterThanOrEqualTo:  scrollView.heightAnchor).isActive = true
            contentView.sizeToFit()

            //logoImageView Constraints
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
            //logoImageView.RounedImage()
            //logoImageView.backgroundColor = .systemBrown
            
            //emailField Consteaints
            emailField.translatesAutoresizingMaskIntoConstraints =  false
            emailField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 44).isActive = true
            emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
            emailField.heightAnchor.constraint(equalToConstant: 34).isActive = true
            
            //passwordField Constrants
            passwordField.translatesAutoresizingMaskIntoConstraints =  false
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 24).isActive = true
            passwordField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            passwordField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
            passwordField.heightAnchor.constraint(equalToConstant: 34).isActive = true
            
            //loginButton Constraints
            loginButton.translatesAutoresizingMaskIntoConstraints =  false
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 24).isActive = true
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
            loginButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
            
            //regesterLable and goToRegisterButton Constrants
            registerLable.translatesAutoresizingMaskIntoConstraints = false
            goToRegisterButton.translatesAutoresizingMaskIntoConstraints = false
            registerLable.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 24).isActive = true
            registerLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true

            goToRegisterButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 24).isActive = true
            goToRegisterButton.leadingAnchor.constraint(equalTo: registerLable.trailingAnchor, constant: 8).isActive = true
            goToRegisterButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            //facebookLogIn Constrants
            facebookLogin.translatesAutoresizingMaskIntoConstraints =  false
            facebookLogin.topAnchor.constraint(equalTo: registerLable.bottomAnchor, constant: 44).isActive = true
            facebookLogin.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44).isActive = true
            facebookLogin.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -44).isActive = true
            facebookLogin.heightAnchor.constraint(equalToConstant: 54).isActive = true
            
        }
}

// MARK: - extentions
/*extension LogInViewController : LoginButtonDelegate{
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
*/
