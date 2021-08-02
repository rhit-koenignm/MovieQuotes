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
        
    }
    
    //Read
    func beginListening(uid: String, changeListener: () -> Void) {
        
    
    }
    
    func stopListening() {
        _userListener?.remove()
    }
    
    //Update
    func updateName(name: String){
        
    }
    
    func updatePhotoUrl(photoUrl: String) {
        
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
