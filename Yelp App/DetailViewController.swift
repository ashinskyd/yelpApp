//
//  DetailViewController.swift
//  Yelp App
//
//  Created by David Ashinsky on 5/29/18.
//  Copyright © 2018 David Ashinsky. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    /** Contains the restaurant for which details show be displayed **/
    var restaurant: YelpRestaurantModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = restaurant?.name
        titleLabel.text = restaurant?.name
        titleLabel.sizeToFit()
        
        phoneLabel.text = restaurant?.phone
        phoneLabel.sizeToFit()
        if let rating = restaurant?.rating {
            ratingLabel.text = "Rating: \(rating)"
        } else {
            ratingLabel.text = nil
        }
        ratingLabel.sizeToFit()
    }
}
