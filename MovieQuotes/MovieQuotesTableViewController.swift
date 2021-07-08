//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by Natalie Koenig on 7/7/21.
//

import UIKit

class MovieQuotesTableViewController: UITableViewController {
    
    let movieQuoteCellIdentifier = "MovieQuoteCell"
    var names = ["Natalie", "Greg", "Stef", "Josie", "Misty"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieQuoteCellIdentifier, for: indexPath)
        //Configure the cell
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
}
