//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Natalie Koenig on 8/2/21.
//

import UIKit
import Firebase

class ProfilePageViewController: UIViewController {
    
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    override func viewDidLoad() {
        UserManager.shared.beginListening(uid: Auth.auth().currentUser!.uid, changeListener: updateView)
        
        displayNameTextField.addTarget(self, action: #selector(handleNameEdit), for: UIControl.Event.editingChanged)
    }
    
    @objc func handleNameEdit(){
        if let name = displayNameTextField.text {
            print("Sent the name \(name) to the Firestore!")
            UserManager.shared.updateName(name: name)
        
        }
    }
    
    @IBAction func pressedEditPhoto(_ sender: Any) {
        print("TODO: Upload a photo")
    }
    
    
    func updateView() {
        displayNameTextField.text = UserManager.shared.name
        // TODO: Figure out how to load the image for the ImageView asynchronously
        
    }
}
