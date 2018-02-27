//
//  ViewController.swift
//  Facts
//
//  Created by Raj Shekhar on 2/28/18.
//  Copyright © 2018 Raj Shekhar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var url: URL {
        let url = FactConstants.kFactsUrl
        return URL(string: url)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let networkObj = Networking()
        networkObj.load(url) { (fact) in
            // Will do it tomorrow
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

