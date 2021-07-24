//
//  MovieQuote.swift
//  MovieQuotes
//
//  Created by Natalie Koenig on 7/7/21.
//

import Foundation
import Firebase

class MovieQuote {
    var quote: String
    var movie: String
    var id: String?
    var author: String
    
    init(documentSnapshot: DocumentSnapshot) {
        self.id = documentSnapshot.documentID
        let data = documentSnapshot.data()!
        self.quote = data["quote"] as! String
        self.movie = data["movie"] as! String
        self.author = data["author"] as! String
    }
}
