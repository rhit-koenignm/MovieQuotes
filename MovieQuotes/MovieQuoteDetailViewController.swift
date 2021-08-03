//
//  MovieQuoteDetailViewController.swift
//  MovieQuotes
//
//  Created by Natalie Koenig on 7/7/21.
//

import UIKit
import Firebase

class MovieQuoteDetailViewController: UIViewController {
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    
    @IBOutlet weak var authorBox: UIStackView!
    @IBOutlet weak var authorProfileImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    var movieQuote: MovieQuote?
    var movieQuoteRef: DocumentReference!
    var movieQuoteListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func showEditDialog() {
        let alertController = UIAlertController(title: "Edit this movie quote", message: "", preferredStyle: .alert)
        //Configure
        alertController.addTextField { (textField) in
            textField.placeholder = "Quote"
            textField.text = self.movieQuote?.quote
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Movie"
            textField.text = self.movieQuote?.movie
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        let submitAction = UIAlertAction(title: "Create Quote", style: UIAlertAction.Style.default) { (action) in
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField
            //print(quoteTextField.text)
            //print(movieTextField.text)
//            self.movieQuote?.quote = quoteTextField.text!
//            self.movieQuote?.movie = movieTextField.text!
//            self.updateView()
            self.movieQuoteRef.updateData([
                "quote": quoteTextField.text!,
                "movie": movieTextField.text!
            ])
        }
        alertController.addAction(submitAction)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //updateView()
        authorBox.isHidden = true
        movieQuoteListener = movieQuoteRef.addSnapshotListener{ (DocumentSnapshot, error) in
            if let error = error {
                print("Error getting movie quote \(error)")
                return
            }
            if !DocumentSnapshot!.exists {
                print("Might go back to the list since someone else deleted this document.")
                return
            }
            
            self.movieQuote = MovieQuote(documentSnapshot: DocumentSnapshot!)
            
            //Decide if we can edit or not!
            if (Auth.auth().currentUser!.uid == self.movieQuote?.author) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(self.showEditDialog))
            } else {
                self.navigationItem.rightBarButtonItem = nil
            }
            
            
            //Get the user object for this author
            UserManager.shared.beginListening(uid: self.movieQuote!.author, changeListener: self.updateAuthorBox)
            
            self.updateView()
            
        }
    }
    
    func updateAuthorBox() {
        print("Update the author box for \(UserManager.shared.name)")
        
        authorBox.isHidden = (UserManager.shared.name.isEmpty) && (UserManager.shared.photoUrl.isEmpty)
        
        if (!UserManager.shared.name.isEmpty){
            authorNameLabel.text = UserManager.shared.name
        }
        else  {
            authorNameLabel.text = "unknown"
        }
    
        if (!UserManager.shared.photoUrl.isEmpty) {
            ImageUtils.load(imageView: authorProfileImageView, from: UserManager.shared.photoUrl)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        movieQuoteListener.remove()
    }
    
    func updateView() {
        quoteLabel.text = movieQuote?.quote
        movieLabel.text = movieQuote?.movie
    }
    
}
