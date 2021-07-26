//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by Natalie Koenig on 7/7/21.
//

import UIKit
import Firebase

class MovieQuotesTableViewController: UITableViewController {
    
    let movieQuoteCellIdentifier = "MovieQuoteCell"
    let detailSegueIdentifier = "DetailSegue"
    var movieQuotesRef: CollectionReference!
    var movieQuoteListener: ListenerRegistration!
    var isShowingAllQuotes = true
    
    //var names = ["Natalie", "Greg", "Stef", "Josie", "Misty"]
    var movieQuotes = [MovieQuote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "☰", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showMenu))
        
        
        
        movieQuotesRef = Firestore.firestore().collection("MovieQuotes")
        
        
//        movieQuotes.append(MovieQuote(quote: "Yo Adrian!", movie: "Rocky"))
//        movieQuotes.append(MovieQuote(quote: "I'll be back", movie: "The Terminator"))
    }
    
    @objc func showMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        let submitAction = UIAlertAction(title: "Create Quote", style: UIAlertAction.Style.default) { (action) in
            self.showAddQuoteDialog()
        }
        alertController.addAction(submitAction)
        let showAction = UIAlertAction(title: self.isShowingAllQuotes ? "Show only my quotes" : "Show all quotes", style: UIAlertAction.Style.default) { (action) in
            //Toggle the show all vs show mine mode.
            self.isShowingAllQuotes = !self.isShowingAllQuotes
            //Update
            self.startListening()
        }
        alertController.addAction(showAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        
        //This is anonymous auth
//        if (Auth.auth().currentUser == nil){
//            //You are NOT signed in
//            print("Signing in!")
//            Auth.auth().signInAnonymously { (authResult, error) in
//                if let error = error {
//                    print("Error with Anonymous auth! \(error)")
//                    return
//                }
//                print("Success! You signed in. Well done!")
//            }
//
//        } else {
//            //You are already signed in
//            print("You are already signed in")
//        }
//
//        startListening()
//
//        Use this code later
//        do {
//        try Auth.auth().signOut()
//        } catch {
//            print("Sign out error")
//        }
        
        
        if (Auth.auth().currentUser == nil) {
            print("There is no user. Go back to the login page")
        } else {
            print("You are signed in already!")
        }
        
        
        
        startListening()
    }

        
    func startListening() {
        if (movieQuoteListener != nil) {
            movieQuoteListener.remove()
        }
        var query = movieQuotesRef.order(by: "created", descending: true).limit(to: 50)
        if (!isShowingAllQuotes) {
            query = query.whereField("author", isEqualTo: Auth.auth().currentUser!.uid)
        }
        movieQuoteListener = query.addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.movieQuotes.removeAll()
                querySnapshot.documents.forEach { (documentSnapshot) in
                    print(documentSnapshot.documentID)
                    print(documentSnapshot.data())
                    self.movieQuotes.append(MovieQuote(documentSnapshot: documentSnapshot))
                }
                self.tableView.reloadData()
            } else {
                print("Error getting movie quotes \(error!)")
                return
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        movieQuoteListener.remove()
    }
    
    @objc func showAddQuoteDialog() {
        let alertController = UIAlertController(title: "Create a new movie quote", message: "", preferredStyle: .alert)
        //Configure
        alertController.addTextField { (textField) in
            textField.placeholder = "Quote"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Movie"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        let submitAction = UIAlertAction(title: "Create Quote", style: UIAlertAction.Style.default) { (action) in
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField
            
            self.movieQuotesRef.addDocument(data: [
                "quote": quoteTextField.text!,
                "movie": movieTextField.text!,
                "created": Timestamp.init(),
                "author": Auth.auth().currentUser!.uid
            ])
            //print(quoteTextField.text)
            //print(movieTextField.text)
//            let newMovieQuote = MovieQuote(quote: quoteTextField.text!, movie: movieTextField.text!)
//            self.movieQuotes.insert(newMovieQuote, at: 0)
//            self.tableView.reloadData()
        }
        alertController.addAction(submitAction)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieQuotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieQuoteCellIdentifier, for: indexPath)
        //Configure the cell
        cell.textLabel?.text = movieQuotes[indexPath.row].quote
        cell.detailTextLabel?.text = movieQuotes[indexPath.row].movie
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let movieQuote = movieQuotes[indexPath.row]
        return Auth.auth().currentUser?.uid == movieQuote.author
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            //movieQuotes.remove(at: indexPath.row)
            //tableView.reloadData()
            //print("Delete this quote")
            let movieQuoteToDelete = movieQuotes[indexPath.row]
            movieQuotesRef.document(movieQuoteToDelete.id!).delete()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
//                (segue.destination as! MovieQuoteDetailViewController).movieQuote = movieQuotes[indexPath.row]
                (segue.destination as! MovieQuoteDetailViewController).movieQuoteRef = movieQuotesRef.document(movieQuotes[indexPath.row].id!)
            }
        }
    }
}
