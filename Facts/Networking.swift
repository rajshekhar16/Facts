//
//  Network.swift
//  Facts
//
//  Created by Raj Shekhar on 2/28/18.
//  Copyright © 2018 Raj Shekhar. All rights reserved.
//

import UIKit

public struct FactConstants
{
    static let kFactsUrl  = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
}

class Networking: NSObject {

    /// funtion to get response from REST Api and to fill data model Facts
    ///
    /// - Parameters:
    ///   - url: url of an api
    ///   - completion: return Facts object in completion handler
    func load(_ url: URL, withCompletion completion: @escaping (Facts?) -> Void) {
        
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            
            guard  let jsonObject = self.deserialize(data: data) else
            {
                completion(nil)
                return
            }
            
            let factObj    = Facts(json: jsonObject)
            DispatchQueue.main.async {
                completion(factObj)

            }
        })
        task.resume()
    }
    
    /// convert data from api into json using jsonserialization
    ///
    /// - Parameter data: data to be converted
    /// - Returns: json
    func deserialize(data: Data) -> jsonObject? {
        
        let responseStrInISOLatin = String(data: data, encoding: String.Encoding.isoLatin1)
        guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
            //print("could not convert data to UTF-8 format")
            return nil
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: modifiedDataInUTF8Format, options: .mutableContainers) as? jsonObject else {
            return nil
        }
        
        return json
        
    }
    
}
