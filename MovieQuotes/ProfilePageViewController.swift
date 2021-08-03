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
        //print("TODO: Upload a photo")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("You must be on a real device!")
            imagePickerController.sourceType = .camera

        } else {
            print("You are probably on the simulator")
            imagePickerController.sourceType = .photoLibrary
        }
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func updateView() {
        displayNameTextField.text = UserManager.shared.name
        // TODO: Figure out how to load the image for the ImageView asynchronously
        if UserManager.shared.photoUrl.count > 0 {
            ImageUtils.load(imageView: profilePhotoImageView, from: UserManager.shared.photoUrl)
        }
    }
}
    
extension ProfilePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage? {
            print("Using the edited image")
            profilePhotoImageView.image = image
            
            //TODO: Upload to Firestore!
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
            print("Using the original photo")
            profilePhotoImageView.image = image
            
            //TODO: Upload to Firestore
        }
        picker.dismiss(animated: true)
    }
    
}
