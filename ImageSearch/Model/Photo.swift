//
//  Photo.swift
//  ImageSearch
//
//  Created by Babu Gangatharan on 7/20/17.
//  Copyright © 2017 Babu Gangatharan. All rights reserved.
//

import Foundation

struct Photo {
    
    //MARK: Properties
    
    let id: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    
    var url: String {
        return "http://farm\(farm).static.flickr.com/\(server)/{id}_\(secret).jpg"
    }
    
}
