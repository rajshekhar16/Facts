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
    let networkObj = Networking()
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.showActivityIndicator()
        self.loadDataInToTable()
        self.refreshControl?.addTarget(self, action:#selector(self.loadDataInToTable(refreshControl:)), for: UIControlEvents.valueChanged)
 
    }
    
    func checkForNetConnection() -> Bool
    {
        if !Reachability.isConnectedToNetwork(){
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet. Once connected pull to refresh", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return false
        }
        return true
    }
    
    // To show activity Indicator
    func showActivityIndicator()
    {
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.center = self.tableView.center;
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()

    }

    func hideActivityIndicator()
    {
        self.activityIndicator.stopAnimating()

    }
    
    /// Responsible to load data into table and also refresh when pull the tableView
    @objc func loadDataInToTable(refreshControl :UIRefreshControl? = nil)
    {
        let isConnected = self.checkForNetConnection()
        if isConnected
        {
            networkObj.clearImageCache()
            networkObj.load(url) { (fact) in
                
                if fact != nil
                {
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
                        
                        self.hideActivityIndicator()
                        self.tableView.dataSource = self.dataSource
                        self.tableView.rowHeight = UITableViewAutomaticDimension
                        self.tableView.reloadData()
                        if refreshControl != nil{
                            refreshControl?.endRefreshing()
                        }
                        
                        
                    }
                    
                }
            }
        }
        else{
            refreshControl?.endRefreshing()
        }
        
    }
    
    // MARK: Delegate Methods of TableViewController
    
    var cellHeights: [IndexPath : CGFloat] = [:]
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else { return 50.0 }
        return height
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

