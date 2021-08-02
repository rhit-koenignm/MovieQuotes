//
//  LogInViewController.swift
//  MovieQuotes
//
//  Created by Natalie Koenig on 7/25/21.
//

import UIKit
import Firebase
import Rosefire
import GoogleSignIn

class LogInViewController: UIViewController {
     
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    let REGISTRY_TOKEN = "2cc34286-ac2f-4754-b796-baba9632702a" //TODO go visit rosefire.csse.rose-hulman.edu to generate this!
    let showListSegueIdentifier = "ShowListSegue"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        googleSignInButton.style = .wide
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
    
    @IBAction func pressedRosefireLogin(_ sender: Any) {
        Rosefire.sharedDelegate().uiDelegate = self // This should be your view controller
        Rosefire.sharedDelegate().signIn(registryToken: REGISTRY_TOKEN) { (err, result) in
          if let err = err {
            print("Rosefire sign in error! \(err)")
            return
          }
          print("Result = \(result!.token!)")
          print("Result = \(result!.username!)")
          print("Result = \(result!.name!)")
          print("Result = \(result!.email!)")
          print("Result = \(result!.group!)")
          
            
            Auth.auth().signIn(withCustomToken: result!.token) { (authResult, error) in
            if let error = error {
              print("Firebase sign in error! \(error)")
              return
            }
            // User is signed in using Firebase!
                self.performSegue(withIdentifier: self.showListSegueIdentifier, sender: self)
          }
        }

    }
    
}
