//
//  Extension.swift
//  ImageEditor
//
//  Created by dimsky on 2019/12/4.
//  Copyright © 2019 dimsky. All rights reserved.
//

import UIKit

public protocol WebImage {
    func setImage(withUrl url: URL, placeholder: UIImage, progress: @escaping (_ receivedSize: Int, _ expectedSize: Int) -> Void, completion: @escaping (_ image: UIImage?, _ url: URL?, _ success: Bool, _ error: Error?) -> Void)

    func cancelImageRequest()

    func imageFromMemoryForURL(url: URL) -> UIImage?

    func imageFromCacheForURL(url: URL) -> UIImage?

}

public extension WebImage {
    func setImage(withUrl url: URL, placeholder: UIImage, progress: @escaping (_ receivedSize: Int, _ expectedSize: Int) -> Void, completion: @escaping (_ image: UIImage?, _ url: URL?, _ success: Bool, _ error: Error?) -> Void) {}

    func cancelImageRequest(){}

    func imageFromMemoryForURL(url: URL) -> UIImage? { return nil }

    func imageFromCacheForURL(url: URL) -> UIImage? { return nil }
}

open class WebImageManager: WebImage {
    public let imageView: UIImageView

    init(imageView: UIImageView) {
        self.imageView = imageView
    }
}

public extension UIImageView {

    public var xsl: WebImageManager {
        return WebImageManager(imageView: self)
    }
}


var PhotoKitButtonActionHandler = 108
extension UIButton {

    var photoKit_actionHandler: (UIButton)->() {
        set {
            objc_setAssociatedObject(self, &PhotoKitButtonActionHandler, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }

        get {
            return objc_getAssociatedObject(self, &PhotoKitButtonActionHandler) as? (UIButton)->() ?? {_ in }
        }
    }

    func photoKit_setEventHandler(event: UIControl.Event, handler: @escaping (UIButton)->()) {
        self.photoKit_actionHandler = handler
        self.addTarget(self, action: #selector(photoKit_actionHandler(button:)), for: event)
    }

    @objc func photoKit_actionHandler(button: UIButton) {
        self.photoKit_actionHandler(button)
    }
}
