//
//  YelpDataFetchManager.swift
//  Yelp App
//
//  Created by David Ashinsky on 5/29/18.
//  Copyright © 2018 David Ashinsky. All rights reserved.
//

import UIKit

class YelpDataFetchManager {
    
    private static let baseURLString = "https://api.yelp.com/v3/businesses/search"
    private static let defaultZipCode = "55416"
    private static let bearerToken = "Ywphlfre0QYfSwynaT178_Ntp2OP2D3iKwWQgnLNQFsurtcdmXTovJhyALEaNtnpio4GA5k1N1FJBRK9iuvrmkM9BGqsNyUZ8nHUUYEysHQQaGMtFJUXPHsy-tYNW3Yx"
    
    /** Method fetches restaurants with the given term, calling the completion block with the results, or an error if one exists.
     **/
    func fetchData(withTerm term: String, completion: @escaping ([YelpRestaurantModel]?, Error?)->Void) {
        
        // Start by creating the URL, ensuring it can be created before proceeding.
        guard let url = URL(string: YelpDataFetchManager.baseURLString + "?term=\(term)"+"&location=\(YelpDataFetchManager.defaultZipCode)") else {
            let urlError = NSError(domain: "Failed to create URL", code: 0, userInfo: nil)
            completion(nil, urlError)
            return
        }
        
        // Then create the request, and start the task.
        let request = urlRequest(withURL: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } else {
                DispatchQueue.main.async {
                    completion(YelpRestaurantModel.restaurants(fromData: data), nil)
                }
            }
        }
        
        task.resume()
    }
    
    /** Helper method to create a urlRequest with a given url, setting the appropriate HTTP headers.
     **/
    private func urlRequest(withURL url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(YelpDataFetchManager.bearerToken)", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}
