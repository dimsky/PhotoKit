//
//  PhotoBrowser.swift
//  ImageEditor
//
//  Created by dimsky on 2019/11/26.
//  Copyright © 2019 dimsky. All rights reserved.
//

import UIKit


let PhotoViewMaxScale: CGFloat = 3


enum PhotoBrowserDismissAnimationType {
    case scale
}

enum PhotoBrowserShowAnimationType {
    case scale
}

enum PhotoBrowserBackgroundStyleType {
    case blurPhoto
    case blur
    case black
    case color(color: UIColor)
}

enum PhotoBrowserPageControlType {
    case dot        //当大于16时 以 text 显示
    case text
}

open class PhotoBrowser: NSObject {
    
    public static func browser(photos: [PhotoModel], selectedIndex index: Int, showIn vc: UIViewController) {
        let controller = PhotoBrowserController(photos: photos, selectedIndex: index)
        controller.canSelect = false
        controller.canEdit = false
        vc.present(controller, animated: false, completion: nil)
    }


    public static func confirm(photos: [PhotoModel], selectedIndex index: Int, showIn vc: UIViewController, finish: @escaping ([PhotoModel]) -> Void) {
        let controller = PhotoBrowserController(photos: photos, selectedIndex: index)
        controller.canSelect = true
        controller.canEdit = true
        controller.isComfirm = true
        controller.confirmFinishHandler = finish
//        vc.navigationController?.pushViewController(controller, animated: true)
        vc.present(controller, animated: false, completion: nil)
    }
}
