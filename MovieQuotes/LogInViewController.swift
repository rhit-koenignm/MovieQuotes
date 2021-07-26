//
//  LogInViewController.swift
//  MovieQuotes
//
//  Created by Natalie Koenig on 7/25/21.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
     
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    let showListSegueIdentifier = "ShowListSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            print("Someone is already signed in, move along")
            self.performSegue(withIdentifier: self.showListSegueIdentifier, sender: self)
        }
    }
    
    @IBAction func pressedSignInNewUser(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating a new user for Email/Password \(error)")
                return
            }
            
            print("It worked!")
            print(authResult)
            print(authResult?.user)
            print(authResult?.user.email)
            print(authResult?.user.uid)
            
            self.performSegue(withIdentifier: self.showListSegueIdentifier, sender: self)
        }
    
    }
    
    @IBAction func pressedLogInExistingUser(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error logging in an existing user for Email/Password \(error)")
                return
            }
            
            print("It worked!")
            print(authResult)
            print(authResult?.user)
            print(authResult?.user.email)
            print(authResult?.user.uid)
            
            self.performSegue(withIdentifier: self.showListSegueIdentifier, sender: self)
        }
    }
    
}
