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

    /// 浏览大图
    /// - Parameters:
    ///   - photos: 全部图片实体， 仅需初始化 urlString 或 image
    ///   - sourceViewKeyPath: 显示小图的源视图的 KeyPath
    ///   - offset: photos 偏移量，如第一张不为图片的情况, offset = 1
    ///   - collectionView: 列表视图对象
    ///   - index: 选中的IndexPath
    ///   - vc: 当前UIViewController
    public static func browser(photos: [PhotoModel], sourceViewKeyPath: AnyKeyPath, offset: Int = 0, collectionView: UICollectionView, selectedIndex index: IndexPath, showIn vc: UIViewController) {

        let visibleItems = collectionView.indexPathsForVisibleItems
        for item in visibleItems {
            let cell = collectionView.cellForItem(at: item)

            if let imageView = cell?[keyPath: sourceViewKeyPath] as? UIImageView {

                let index = item.item - offset
                if photos.count > index && index >= 0 {
                    photos[index].imageView = imageView
                    photos[index].thumbImage = imageView.image
                }
            }
        }

        PhotoBrowser.browser(photos: photos, selectedIndex: index.item - offset, showIn: vc)
    }
    
    public static func browser(photos: [PhotoModel], selectedIndex index: Int, showIn vc: UIViewController) {
        let controller = PhotoBrowserController(photos: photos, selectedIndex: index)
        controller.canSelect = false
        controller.canEdit = false
//        let nav = UINavigationController(rootViewController: controller)
//        nav.isNavigationBarHidden = true
//        nav.view.backgroundColor = UIColor.clear
//        nav.modalPresentationStyle = .overFullScreen
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
