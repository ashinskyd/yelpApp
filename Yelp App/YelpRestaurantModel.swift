//
//  YelpRestaurantModel.swift
//  Yelp App
//
//  Created by David Ashinsky on 5/29/18.
//  Copyright © 2018 David Ashinsky. All rights reserved.
//

import UIKit

struct YelpRestaurantModel {
    
    let name: String?
    let rating: Int?
    let price: String?
    let phone: String?
    
    /** Returns an array of YelpRestaurantModel from the given raw Data from the Yelp API response, or nil if an error occurred. **/
    static func restaurants(fromData data: Data?) -> [YelpRestaurantModel]? {
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let businessData = json?["businesses"] as? [[String: Any]] else {
                return nil
        }
        
        var result = [YelpRestaurantModel]()
        for buisiness in businessData {
            let name = buisiness["name"] as? String
            let rating = buisiness["rating"] as? Int
            let price = buisiness["price"] as? String
            let phone = buisiness["phone"] as? String
            let model = YelpRestaurantModel(name: name, rating: rating, price: price, phone: phone)
            result.append(model)
        }
        return result
    }
}
