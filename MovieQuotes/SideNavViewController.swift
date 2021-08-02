//
//  SideNavViewController.swift
//  MovieQuotes
//
//  Created by Natalie Koenig on 8/2/21.
//

import UIKit
import Firebase

class SideNavViewController: UIViewController {
    
    @IBAction func pressedGoToProfilePage(_ sender: Any) {
        //print("TODO: Make a profile page and go there")
        dismiss(animated: false, completion: nil)
        tableViewController.performSegue(withIdentifier: "ProfilePageSegue", sender: tableViewController)
    }
    
    @IBAction func pressedShowAllQuotes(_ sender: Any) {
        //print("TODO: Presenting view controller is \(presentingViewController)")
        tableViewController.isShowingAllQuotes = true
        tableViewController.startListening()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedShowMyQuotes(_ sender: Any) {
        tableViewController.isShowingAllQuotes = false
        tableViewController.startListening()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedDeleteQuotes(_ sender: Any) {
        //print("TODO: Go into editing mode")
        tableViewController.setEditing(!tableViewController.isEditing, animated: true)
    }
    
    @IBAction func pressedLogout(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        //print("TODO: Use Auth to do sign out")
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out error")
        }
    }
    
    var tableViewController: MovieQuotesTableViewController {
        let navController = presentingViewController as! UINavigationController
        return navController.viewControllers.last as! MovieQuotesTableViewController
    }
}
