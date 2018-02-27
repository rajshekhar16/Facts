//
//  Facts.swift
//  Facts
//
//  Created by Raj Shekhar on 2/28/18.
//  Copyright © 2018 Raj Shekhar. All rights reserved.
//

import UIKit

struct Facts {
   
    let title: String?
    var rows: [FactData] = []
}

extension Facts
{
    private enum Keys: String {
        case title
        case rows
    }
    
    init(json: jsonObject)
    {
        title = json[Keys.title.rawValue]  as? String
        
        if let rowArr = json[Keys.rows.rawValue] as? [jsonObject]
        {
            for rowVal in rowArr
            {
                let factObj = FactData(json: rowVal)
                rows.append(factObj)
            }
        }
        
    }
}

