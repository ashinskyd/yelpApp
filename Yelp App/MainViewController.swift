//
//  MainViewController.swift
//  Yelp App
//
//  Created by David Ashinsky on 5/29/18.
//  Copyright © 2018 David Ashinsky. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var resultsTableView: UITableView!
    
    // MARK: Properties
    static let appTitle = "'Yelp' App"
    fileprivate static let showDetailSegueIdentifier = "showDetailSegue"
    fileprivate private(set) var restaurantResults: [YelpRestaurantModel]?
    var dataFetcher = YelpDataFetchManager()
    
    /** Holds the selected row of the restaurant that was selected **/
    fileprivate var selectedIndex: Int?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        title = MainViewController.appTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedIndex = nil
    }

    // MARK: Actions
    
    /** Called once the user presses the search button.
     *  Asynchronously fetches results based on the text field's text.
     **/
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        // Sanitize the search field first.
        guard let searchTerm = searchTextField.text else { return }
        
        // Then perform the request
        dataFetcher.fetchData(withTerm: searchTerm) { (results, error) in
            if error != nil {
                self.updateRestaurants(withRestaurants: nil)
            } else {
                self.updateRestaurants(withRestaurants: results)
            }
        }
    }
    
    func updateRestaurants(withRestaurants restaurants: [YelpRestaurantModel]?) {
        self.restaurantResults = restaurants
        self.resultsTableView.reloadData()
    }
    
    // MARK: MISC Overrides
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Check that:
        // -This is the correct segue
        // -The destination VC is the correct type
        guard let identifier = segue.identifier,
              identifier == MainViewController.showDetailSegueIdentifier,
              let detailViewController = segue.destination as? DetailViewController,
              let selectedRow = selectedIndex,
              let restaurant = restaurantResults?[selectedRow] else { return }
        
        // Setup the detail vc before its pushed onto the nav stack.
        detailViewController.restaurant = restaurant
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row, and then push the detail view onto the nav stack.
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        performSegue(withIdentifier: MainViewController.showDetailSegueIdentifier, sender: self)
    }
}

extension MainViewController: UITableViewDataSource {
    
    private static let cellReuseIdentifier = "DefaultCellReuseIdentifier"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainViewController.cellReuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: MainViewController.cellReuseIdentifier)
        
        cell.textLabel?.text = restaurantResults?[indexPath.row].name
        return cell
    }
}
