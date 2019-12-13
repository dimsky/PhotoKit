//
//  PhotoKit.swift
//  PhotoKit
//
//  Created by dimsky on 2019/12/13.
//

import UIKit

public protocol PhotoKitConfigDelegate {
    func setImage(withImageView imageView: UIImageView, url: URL, placeholder: UIImage, progress: @escaping (_ receivedSize: Int, _ expectedSize: Int) -> Void, completion: @escaping (_ image: UIImage?, _ url: URL?, _ success: Bool, _ error: Error?) -> Void)

    func cancelImageRequest(withImageView imageView: UIImageView)

    func imageFromMemoryForURL(url: URL) -> UIImage?

    func imageFromCacheForURL(url: URL) -> UIImage?

    func store(image: UIImage, forKey key: String)

    func imageFromCache(forKey key: String) -> UIImage?
}

public class PhotoKit {
    public static let shared: PhotoKit = PhotoKit()
    open var delegate: PhotoKitConfigDelegate?
}

var PhotoDelegate: PhotoKitConfigDelegate? = {
    return PhotoKit.shared.delegate
}()
