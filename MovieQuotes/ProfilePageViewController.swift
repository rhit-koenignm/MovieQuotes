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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserManager.shared.beginListening(uid: Auth.auth().currentUser!.uid, changeListener: updateView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserManager.shared.stopListening()
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
        if UserManager.shared.photoUrl.count > 0 {
            ImageUtils.load(imageView: profilePhotoImageView, from: UserManager.shared.photoUrl)
        }
    }
}
