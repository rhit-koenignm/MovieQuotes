//
//  UserManager.swift
//  MovieQuotes
//
//  Created by Natalie Koenig on 8/2/21.
//

import Foundation
import Firebase

let kCollectionUsers = "Users"
let kKeyName = "name"
let kKeyPhotoUrl = "photoUrl"

class UserManager {
    
    var _collectionRef: CollectionReference
    var _document: DocumentSnapshot?
    var _userListener: ListenerRegistration?
    
    static let shared = UserManager()

    private init() {
        _collectionRef = Firestore.firestore().collection(kCollectionUsers)
    }
    
    //Create
    func addNewUserMaybe(uid: String, name: String?, photoUrl: String?) {
        // Get the user to see if they exist
        // Add the user ONLY if they don't exist
        
        let userRef = _collectionRef.document(uid)
        userRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting user \(error)")
            }
            if let documentSnapshot = documentSnapshot {
                if documentSnapshot.exists {
                    print("There is already a User object for this auth user. Do nothing")
                    return
                } else {
                    print("Creating a User with document id \(uid)")
                    userRef.setData([
                        kKeyName: name ?? "",
                        kKeyPhotoUrl: photoUrl ?? ""
                    ])
                }
            }
        }
    }
    
    //Read
    func beginListening(uid: String, changeListener: (() -> Void)?) {
        let userRef = _collectionRef.document(uid)
        userRef.addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("Error listening for user: \(error)")
                return
            }
            if let documentSnaphshot = documentSnapshot {
                self._document = documentSnapshot
                changeListener?()
            }
        }
    }
    
    func stopListening() {
        _userListener?.remove()
    }
    
    //Update
    func updateName(name: String){
        let userRef = _collectionRef.document(Auth.auth().currentUser!.uid)
        
        userRef.updateData([
            kKeyName: name
        ])
    }
    
    func updatePhotoUrl(photoUrl: String) {
        let userRef = _collectionRef.document(Auth.auth().currentUser!.uid)
        
        userRef.updateData([
            kKeyPhotoUrl: photoUrl
        ])
    }
    
    //Delete - There is no delete!
    
    
    //Getters
    var name: String {
        get {
            //return _document?.get(kKeyName)
            if let value = _document?.get(kKeyName) {
                return value as! String
            }
            return ""
        }
    }
    
    var photoUrl: String {
        get {
            //return _document?.get(kKeyName)
            if let value = _document?.get(kKeyPhotoUrl) {
                return value as! String
            }
            return ""
        }
    }
}
