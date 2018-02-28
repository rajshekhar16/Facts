//
//  FactsDataSource.swift
//  Facts
//
//  Created by Raj Shekhar on 2/28/18.
//  Copyright © 2018 Raj Shekhar. All rights reserved.
//

import UIKit

class FactsDataSource: NSObject {

    let factsData :[FactData]
    init(factsData: [FactData]) {
        self.factsData = factsData
    }
    
}
    
    extension FactsDataSource: UITableViewDataSource {
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.factsData.count
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"FactsTableCell") as! FactsTableViewCell
            let quote = factsData[indexPath.row]
            cell.title =  quote.title
            cell.desc   =  quote.desc
            return cell
            
        }
    }
    
    

