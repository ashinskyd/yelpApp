//
//  Yelp_AppTests.swift
//  Yelp AppTests
//
//  Created by David Ashinsky on 5/29/18.
//  Copyright © 2018 David Ashinsky. All rights reserved.
//

import XCTest
@testable import Yelp_App

class Yelp_AppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /** Tests the basic yelp restaurant model creation is valid **/
    func testModelCreation() {
        let testName = "testName"
        let model = YelpRestaurantModel(name: testName, rating: nil, price: nil, phone: nil)
        
        XCTAssertEqual(model.name, testName)
        XCTAssertNil(model.rating)
        XCTAssertNil(model.price)
        XCTAssertNil(model.phone)
    }
    
    /** Tests that the yelp API does not throw an error for a mock search. **/
    func testYelpApi() {
        let dispatchGroup = DispatchGroup()
    
        let searchTerm = "testSearchTerm"
        var errorResult: Error?
        
        dispatchGroup.enter()
        YelpDataFetchManager().fetchData(withTerm: searchTerm) { (restaurants, error) in
            errorResult = error
            dispatchGroup.leave()
        }
        
        dispatchGroup.wait()
        
        XCTAssertNil(errorResult)
    }
    
    /** Tests the main view controller title and results tableview count **/
    func testMainViewController() {
        let mainViewController = mockMainViewController()
        
        XCTAssertEqual(mainViewController.title!, MainViewController.appTitle)
        XCTAssertEqual(mainViewController.resultsTableView.numberOfRows(inSection: 0), 1)
    }
}

private extension Yelp_AppTests {
    
    /** Returns a mocked 'MainViewController' for use in testing. The VC is already pre-populated with some mock data **/
    func mockMainViewController() -> MainViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let mainViewController = navigationController.viewControllers.first as! MainViewController
        
        let _ = mainViewController.view // To call viewDidLoad
        
        // Setup some fake data
        mainViewController.dataFetcher = YelpDataFetchManagerTester()
        mainViewController.searchButtonPressed(UIButton(frame: .zero))
        
        return mainViewController
    }
}


/** Mocks the YelpDataFetchManager class by returning a single restaurant result. **/
private class YelpDataFetchManagerTester: YelpDataFetchManager {
    
    static let restaurantName = "name"
    static let restaurantRating = 1
    static let restaurantPrice = "price"
    static let restaurantPhone = "phone"
    
    private static let testRestaurantModel = YelpRestaurantModel(name: YelpDataFetchManagerTester.restaurantName,
                                                                 rating: YelpDataFetchManagerTester.restaurantRating,
                                                                 price: YelpDataFetchManagerTester.restaurantPrice,
                                                                 phone: YelpDataFetchManagerTester.restaurantPhone)
    
    override func fetchData(withTerm term: String, completion: @escaping ([YelpRestaurantModel]?, Error?)->Void) {
        completion([YelpDataFetchManagerTester.testRestaurantModel], nil)
    }
}
