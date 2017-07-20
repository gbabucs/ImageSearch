//
//  ServiceManager.swift
//  ImageSearch
//
//  Created by Babu Gangatharan on 7/21/17.
//  Copyright © 2017 Babu Gangatharan. All rights reserved.
//

import Foundation

class ServiceManager {
    
    typealias ImageResponse = (NSError?, [Photo]?) -> Void
    
    struct Keys {
        static let apiKey = "1d700f6a368d27dd8dabce5a9588d509"
    }
    
    struct Errors {
        static let invalidAccessErrorCode = 100
        static let domain = "com.flickr.api"
    }
    
    class func getPhotos(for searchText: String, completion onCompletion: @escaping ImageResponse) -> Void {
        guard let allowedUrlString = searchText.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed) else {
            return
        }
            
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Keys.apiKey)&format=json&nojsoncallback=1&text=\(allowedUrlString)"
        
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        let searchTask = URLSession.shared.dataTask(with: url as URL, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                print("Error: \(error.debugDescription)")
                onCompletion(error as NSError?, nil)
                
                return
            }
            
            do {
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                guard let results = resultsDictionary else { return }
                
                if let statusCode = results["code"] as? Int,
                    statusCode == Errors.invalidAccessErrorCode {
                    let invalidAccessError = NSError(domain: Errors.domain, code: statusCode, userInfo: nil)
                    
                    onCompletion(invalidAccessError, nil)
                    
                    return
                }
                
                guard let photosKey = results["photos"] as? [String: AnyObject],
                    let photosArray = photosKey["photo"] as? [[String: AnyObject]] else {
                        
                        return
                }
                
                
                let photos: [Photo] = photosArray.map { dictionary in
                    
                    let id = dictionary["id"] as? String ?? ""
                    let secret = dictionary["secret"] as? String ?? ""
                    let server = dictionary["server"] as? String ?? ""
                    let farm = dictionary["farm"] as? Int ?? 0
                    let title = dictionary["title"] as? String ?? ""
                    
                    let photo = Photo(id: id, secret: secret, server: server, farm: farm, title: title)
                    
                    return photo
                }
                
                onCompletion(nil, photos)
                
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                onCompletion(error, nil)
                return
            }
            
        })
        searchTask.resume()
    }
    
}
