//
//  ViewController.swift
//  Facts
//
//  Created by Raj Shekhar on 2/28/18.
//  Copyright © 2018 Raj Shekhar. All rights reserved.
//

import UIKit

class FactsViewController: UITableViewController {

    var url: URL {
        let url = FactConstants.kFactsUrl
        return URL(string: url)!
    }
    
    var factsDetails :[FactData]?
    var dataSource: FactsDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.showShimmers()
        self.loadDataInToTable()
 
    }
    
    // To show shimmer effect on tableView with the help of 3rd party library "Loader"
    func showShimmers()
    {
        self.dataSource = FactsDataSource(factsData: [])
        self.tableView.dataSource = self.dataSource
        self.tableView.isScrollEnabled = false
        self.tableView.reloadData()
        Loader.addLoaderTo(self.tableView)
    }

    func hideShimmers()
    {
        self.tableView.isScrollEnabled = true
        Loader.removeLoaderFrom(self.tableView)

    }
    
    /// Responsible to load data into table
    func loadDataInToTable()
    {
        let networkObj = Networking()
        networkObj.load(url) { (fact) in
            
            if let title = fact?.title
            {
                self.navigationController?.navigationBar.topItem?.title = title;
                
            }
            if let factData = fact?.rows
            {
                // remove entry from model if all objects are nil
                self.factsDetails = factData.filter({ $0.imageURL != nil || ($0.desc != nil)  || $0.title != nil })
            }
            self.dataSource = FactsDataSource(factsData: self.factsDetails!)
            DispatchQueue.main.async {
                
                self.hideShimmers()
                self.tableView.dataSource = self.dataSource
                self.tableView.estimatedRowHeight = 113
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.reloadData()
                
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

