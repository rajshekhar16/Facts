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

    /// funtion to get response from REST Api and to fill data model(Facts)
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

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
  
    /// Responsible to download images from url and image caching, will set image directly if coming from cache else will return downloaded image and indexpath in completion handler so that table view can reload particular cell.(This extension is specific for only tableView)
    ///
    /// - Parameters:
    ///   - url: Url of an image
    ///   - indexPath: indexPath of image
    ///   - completion: object of UIImage and Indexpath
    func loadImageUsingCacheForTableView(_ url: URL,indexPath :IndexPath,completion: @escaping (IndexPath?, UIImage) -> Void) {
        self.image = nil
        let urlString = url.absoluteString
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            //print("RESPONSE FROM API: \(response)")
            if error != nil {
                print("ERROR LOADING IMAGES FROM URL: \(error.debugDescription)")
                DispatchQueue.main.async {
                    let placeHolderImg = UIImage(named:"noImage.jpg")
                    imageCache.setObject(placeHolderImg!, forKey: NSString(string: urlString))

                }
                return
            }
            DispatchQueue.main.async {
                if let data = data {
                    if let downloadedImage = UIImage(data: data) {
                        imageCache.setObject(downloadedImage, forKey: NSString(string: urlString))
                        completion(indexPath, downloadedImage)
                       // self.image = downloadedImage
                    }
                }
            }
        }).resume()
        
    }
}
