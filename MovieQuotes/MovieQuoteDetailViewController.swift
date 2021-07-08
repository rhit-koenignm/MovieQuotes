//
//  MovieQuoteDetailViewController.swift
//  MovieQuotes
//
//  Created by Natalie Koenig on 7/7/21.
//

import UIKit

class MovieQuoteDetailViewController: UIViewController {
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    
    var movieQuote: MovieQuote?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    
    func updateView() {
        quoteLabel.text = movieQuote?.quote
        movieLabel.text = movieQuote?.movie
    }
    
}
