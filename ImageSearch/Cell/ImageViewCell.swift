//
//  ImageViewCell.swift
//  ImageSearch
//
//  Created by Babu Gangatharan on 7/20/17.
//  Copyright © 2017 Babu Gangatharan. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: Static
    
    static let identifier = "ImageViewCell"
    
    //MARK: Functions
    
    func configureCell(for photo: Photo) {
        //imageView.image = photo.url
    }
}
