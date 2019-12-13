//
//  PhotoModel.swift
//  ImageEditor
//
//  Created by dimsky on 2019/11/26.
//  Copyright © 2019 dimsky. All rights reserved.
//

import UIKit

public class PhotoModel {
    public var urlString: String?
    public var image: UIImage?
    public var thumbImage: UIImage?
    public var imageView: UIImageView?
    public var progress: CGFloat?

    public init(urlString: String) {
        self.urlString = urlString
    }

    public init(image: UIImage?) {
        self.image = image
    }
}
