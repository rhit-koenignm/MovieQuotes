//
//  AppDelegate.swift
//  MovieQuotes
//
//  Created by Natalie Koenig on 7/1/21.
//

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
//        let db = Firestore.firestore()
//        let settings = db.settings
//        settings.areTimestampsInSnapshotsEnabled = true
//        db.settings = settings
        return true
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print("There was an error with Google Sign in \(error)")
            return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
  //    let givenName = user.profile.givenName
  //    let familyName = user.profile.familyName
        let email = user.profile.email

        print("Name \(fullName!)  Email \(email!)")
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        // TODO: Use the Google sign in credential to sign in with Firebase
    
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Firebase sign in error form Google! \(error)")
                return
            }
            let loginVc = GIDSignIn.sharedInstance()?.presentingViewController as! LogInViewController
            loginVc.performSegue(withIdentifier: loginVc.showListSegueIdentifier, sender: loginVc)
        }
      //    Auth.auth().signIn(withCustomToken: result!.token) { (authResult, error) in
      //      if let error = error {
      //        print("Firebase sign in error! \(error)")
      //        return
      //      }

      //      // User is signed in using Firebase!
      //      self.performSegue(withIdentifier: self.showListSegueIndentifier, sender: self)

      //    }

    }
    
}

