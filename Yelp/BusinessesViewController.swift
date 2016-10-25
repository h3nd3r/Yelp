//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchBar: UISearchBar!
    var businesses: [Business]!
    var search: Search = Search()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        searchBar = UISearchBar()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        searchBar.delegate = self

        //FiltersViewController.delegate = self
        //filtersViewController.delegate = self
            //.delegate = self
        
        Business.searchWithTerm(term: search.term, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                }
            }})
    }

    private func updateFilters() {
        // map filters to search object
        //autoRefreshLabel.text = preferences.autoRefresh ? "Yes" : "No"
        //playSoundsLabel.text = preferences.playSounds ? "Yes" : "No"
        //showPhotosLabel.text = preferences.showPhotos ? "Yes" : "No"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // we should escape searchBar.text
        search.term = searchBar.text!
        
        Business.searchWithTerm(term: search.term, sort: search.sort, categories: search.categories, deals: search.deals)
            { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
        
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

extension BusinessesViewController: SearchDelegate/*, FiltersViewControllerDelegate*/ {
    func updateSearch(/*filtersViewController: FiltersViewController,*/ didUpdateSearch filtersSearch: Search) {
        
        // TODO: add in radius
        print("New search terms: \(search)")
        
        Business.searchWithTerm(term: search.term, sort: filtersSearch.sort, categories: filtersSearch.categories, deals: filtersSearch.deals) { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            for business in businesses! {
             print(business.name!)
             print(business.address!)
             }
        }
    }
    func filtersViewController(/*filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]*/) {
        print("hello world!")/*
         var categories = filters["categories"] as? [String]
         
         Business.searchWithTerm(term: "Restaurants", sort: nil, categories: categories, deals: nil)
         { (businesses: [Business]?, error: Error?) -> Void in
         self.businesses = businesses
         self.tableView.reloadData()
         }*/
    }
}

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (businesses ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "Restaurant Detail" {
            let cell = sender as! BusinessCell
            let indexPath = tableView.indexPath(for: cell)
            let business = businesses[(indexPath?.row)!]
            let detailsViewController = segue.destination as! DetailsViewController
            
            detailsViewController.business = business
        }
        else {
            let navigationController = segue.destination as! UINavigationController
            let filtersViewController = navigationController.topViewController as! FiltersViewController
            //filtersViewController.search = filters
            //filtersViewController.delegate2 = self
            filtersViewController.delegate = self
            //filtersViewController.currentFilters = self.filters
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
