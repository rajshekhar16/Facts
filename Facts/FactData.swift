//
//  FactData.swift
//  Facts
//
//  Created by Raj Shekhar on 2/28/18.
//  Copyright © 2018 Raj Shekhar. All rights reserved.
//

import UIKit

struct FactData {

    let title: String?
    let desc:  String?
    let imageURL: URL?
}

typealias jsonObject =  [String: Any]


extension FactData
{
    private enum Keys: String {
        case title
        case desc    = "description"
        case imageURL = "imageHref"
    }
    
    init(json: jsonObject)
    {
        title = json[Keys.title.rawValue]  as? String
        desc =  json[Keys.desc.rawValue]   as? String
        if let url: String = json[Keys.imageURL.rawValue] as? String {
            imageURL = URL(string: url)
        } else {
            imageURL = nil
        }
    }
}
