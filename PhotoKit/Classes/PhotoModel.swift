//
//  PhotoModel.swift
//  ImageEditor
//
//  Created by dimsky on 2019/11/26.
//  Copyright © 2019 dimsky. All rights reserved.
//

import UIKit

/// 图片预览实体
public class PhotoModel {

    /// 原图URLString
    public var urlString: String?

    /// 原图
    public var image: UIImage?

    /// 缩略图
    public var thumbImage: UIImage?

    /// 源 UIImageView
    public var imageView: UIImageView?


    public var progress: CGFloat?

    public init(urlString: String) {
        self.urlString = urlString
    }

    public init(image: UIImage?) {
        self.image = image
    }
}
