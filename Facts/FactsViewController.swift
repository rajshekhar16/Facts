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
        let networkObj = Networking()
        networkObj.load(url) { (fact) in
            
            if let title = fact?.title
            {
                self.navigationController?.navigationBar.topItem?.title = title;

            }
            if let factData = fact?.rows
            {
                self.factsDetails = factData.filter({ $0.imageURL != nil || ($0.desc != nil)  || $0.title != nil })
            }
            self.dataSource = FactsDataSource(factsData: self.factsDetails!)
            DispatchQueue.main.async {
                
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

