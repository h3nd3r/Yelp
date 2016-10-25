//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Sara Hender on 10/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

protocol SearchDelegate: class {
    var search: Search { get }
    func updateSearch(/*filtersViewController: FiltersViewController,*/ didUpdateSearch filterSearch: Search)
}

class FiltersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: SearchDelegate?
    
    let HeaderViewIdentifier = "TableViewHeaderView"    
    var currentFilters: Filters!
    
    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        
        currentFilters = currentFilters ?? Filters()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
    }

    func initFilters(search: Search) {
        print(#function)
        currentFilters = currentFilters ?? Filters()
        currentFilters.update(search)
        //tableView.reloadData()
    }

    func filtersFromTableData() -> Filters {
        var newFilters = Filters()
        //newPrefs.autoRefresh = autoRefreshSwitch.on
        //newPrefs.playSounds = soundsSwitch.on
        //newPrefs.showPhotos = showPhotosSwitch.on
        return newFilters
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func searchAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        print("current filters: \(currentFilters.toSearch())")

        delegate?.updateSearch(didUpdateSearch: currentFilters.toSearch())
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FiltersViewController: SwitchCellDelegate {
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        
        print(#function)
        print("did change value: \(value)")
        
        let indexPath = tableView.indexPath(for: switchCell)!
        
        currentFilters.setState(indexPath.section, index: indexPath.row, state: value)
    }
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentFilters.subfilterCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell

        cell.switchLabel.text = currentFilters.subfilter(indexPath.section, index: indexPath.row)
        cell.onSwitch.isOn = currentFilters.getState(indexPath.section, index: indexPath.row)
        cell.delegate = self
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentFilters.count()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderViewIdentifier)! as UITableViewHeaderFooterView
        header.textLabel?.text = currentFilters.filter(section)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

