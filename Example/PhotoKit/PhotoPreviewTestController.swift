//
//  PhotoPreviewTestController.swift
//  PhotoKit_Example
//
//  Created by dimsky on 2019/12/13.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import XPhotoKit
import SDWebImage

var imageUrls = ["https://ww2.sinaimg.cn/mw690/642beb18gw1ep3629gfm0g206o050b2a.gif",
                 "https://desk-fd.zol-img.com.cn/t_s4096x2160c5/g5/M00/01/00/ChMkJlmhG0yISd-jAEwxSgHE_aIAAf_JAKgfXUATDFi295.jpg",
                 "https://desk-fd.zol-img.com.cn/t_s4096x2160c5/g5/M00/01/00/ChMkJlmhG0aIYWnkAEH4zcEJBYIAAf_JAJdJkoAQfjl013.jpg",
                 "https://desk-fd.zol-img.com.cn/t_s4096x2160c5/g5/M00/01/00/ChMkJ1mhG1OIWSUfAEs3xPEtmHUAAf_JAL0B7cASzfc735.jpg",
                 "https://desk-fd.zol-img.com.cn/t_s4096x2160c5/g5/M00/01/00/ChMkJlmhG16IIs6uAEXscbfC4N0AAf_JANK830AReyJ870.jpg",
                 "https://desk-fd.zol-img.com.cn/t_s4096x2160c5/g5/M00/01/00/ChMkJ1mhG2SIcFHCAE-84ikqJ3MAAf_JAOV8YkAT7z6987.jpg",
                 "https://desk-fd.zol-img.com.cn/t_s4096x2160c5/g5/M00/01/00/ChMkJlmhG2yIQOqeACIi8fj5VxcAAf_JQAEYToAIiMJ278.jpg",
                 "https://desk-fd.zol-img.com.cn/t_s4096x2160c5/g5/M00/01/00/ChMkJ1mhG3CIJmxpAGBRC8J7TLgAAf_JQBIp0wAYFEj581.jpg",
                 "https://desk-fd.zol-img.com.cn/t_s4096x2160c5/g5/M00/04/00/ChMkJldRGKqILhShAD8AAHNIVegAASNjgKWCwsAPwAY381.jpg",
                 "https://desk-fd.zol-img.com.cn/t_s4096x2160c5/g5/M00/04/00/ChMkJ1dRGGiILyS2ADiAAM8JtcUAASNjQNuDVQAOIAY684.jpg",
                 "https://desk-fd.zol-img.com.cn/t_s4096x2160c5/g5/M00/04/00/ChMkJldRGIqID4TcAGRkOsHwywwAASNjgDzc-gAZGRS743.jpg",
                 "https://desk-fd.zol-img.com.cn/t_s4096x2160c5/g5/M00/04/00/ChMkJldRGJqIQJOMAG8JxVaJk7cAASNjgG1VIYAbwnd108.jpg",
"https://ww4.sinaimg.cn/mw690/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg",
"https://ww3.sinaimg.cn/mw690/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
"https://ww2.sinaimg.cn/mw690/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
"https://ww4.sinaimg.cn/mw690/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
"https://ww3.sinaimg.cn/mw690/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
"https://ww2.sinaimg.cn/mw690/677febf5gw1erma104rhyj20k03dz16y.jpg",
"https://ww4.sinaimg.cn/mw690/677febf5gw1erma1g5xd0j20k0esa7wj.jpg",
"https://ww4.sinaimg.cn/mw690/a15bd3a5jw1f12r9ku6wjj20u00mhn22.jpg",
"https://ww2.sinaimg.cn/mw690/a15bd3a5jw1f01hkxyjhej20u00jzacj.jpg",
"https://ww4.sinaimg.cn/mw690/a15bd3a5jw1f01hhs2omoj20u00jzwh9.jpg",
"https://ww2.sinaimg.cn/mw690/a15bd3a5jw1ey1oyiyut7j20u00mi0vb.jpg",
"https://ww2.sinaimg.cn/mw690/a15bd3a5jw1exkkw984e3j20u00miacm.jpg",
"https://ww3.sinaimg.cn/mw690/a15bd3a5jw1ew68tajal7j20u011iacr.jpg",
"https://ww2.sinaimg.cn/mw690/a15bd3a5jw1eupveeuzajj20hs0hs75d.jpg",
"https://ww2.sinaimg.cn/mw690/d8937438gw1fb69b0hf5fj20hu13fjxj.jpg",
"https://ww3.sinaimg.cn/mw690/63299128gw1f0dbt56v1rj20iz0sgabu.jpg",
"https://ww1.sinaimg.cn/mw690/63299128gw1f0dbt60jooj20k00u0wf0.jpg",
"https://wx4.sinaimg.cn/mw690/63299128ly3g9jt9t1es2j20sg0zk4qp.jpg",
"https://wx1.sinaimg.cn/mw690/63299128ly3g9jt9t448zj20sg0zknn6.jpg",
"https://wx4.sinaimg.cn/mw690/63299128gy1g9jnc1f6tej20uk0kr7oj.jpg",
"https://wx4.sinaimg.cn/mw690/63299128gy1g9jnc1j9fwj20uk0mvav7.jpg",
"https://wx1.sinaimg.cn/mw690/63299128gy1g9jeiiwauoj21900u04qp.jpg",
"https://wx2.sinaimg.cn/mw690/63299128ly3g9j83njqakj20u00u0qec.jpg",
"https://wx4.sinaimg.cn/mw690/63299128gy1g3fq8j5xm5j20m80rstgq.jpg",
"https://wx3.sinaimg.cn/mw690/63299128gy1g3fq8j5a2jj20m80roagx.jpg",
"https://wx2.sinaimg.cn/mw690/63299128gy1g0gb5zjbquj20rs0ijagi.jpg",
"https://wx3.sinaimg.cn/mw690/63299128gy1g0gb5zre5gj20rs0ijdng.jpg",
"https://wx4.sinaimg.cn/mw690/63299128gy1g58h2lnjz0j20i40n8n0b.jpg",
"https://wx1.sinaimg.cn/mw690/63299128ly1g06tn3g16bj20u00ls76s.jpg",
"https://wx2.sinaimg.cn/mw690/63299128gy1fug33jqn97j21kw2ddqv9.jpg",
"https://ww4.sinaimg.cn/mw690/4b355d26ly1g9kvruoq5fj20pt7pskjm.jpg"]

class PhotoPreviewTestController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {




    var collectionView: UICollectionView!



    var photoItems: [PhotoModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()


        autoreleasepool {
            for _ in 0...2 {
                imageUrls += imageUrls
            }
        }


        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        self.view.addSubview(collectionView)

//        self.view.addSubview(v)

//        let photoView: PhotoView = PhotoView(frame: self.view.bounds)
//        let photoModel = PhotoModel(image: UIImage(named: "bigImage2"))
//        photoView.model = photoModel
//        self.view.addSubview(photoView)
//        PhotoEditor.shared.actionBarShowIn(vc: self)
//        PhotoEditor.shared.photoModel = photoModel
//        PhotoEditor.shared.addEditFinishHandler { [weak photoView] (model) in
//            photoView?.model = model
//        }

        for url in imageUrls {
            let photoModel = PhotoModel(urlString: url)
            photoModel.urlString = url

            photoItems.append(photoModel)
        }

    }


    //MARK: - DELEGATE
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let url = imageUrls[indexPath.item]
        cell.imageView.xsl.setImage(withUrl: URL(string: url)!, placeholder: UIImage(named: "bigImage1")!, progress: { (a, b) in

        }) { (image, url, success, error) in

        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(imageUrls.count)
        PhotoBrowser.browser(photos: photoItems, sourceViewKeyPath: \ImageCell.imageView, collectionView: collectionView, selectedIndex: indexPath, showIn: self)
    }


//    func browser(photos: [PhotoModel], sourceViewKeyPath: AnyKeyPath, collectionView: UICollectionView, selectIndex: IndexPath) {
//
//        let visibleItems = collectionView.indexPathsForVisibleItems
//        for item in visibleItems {
//
//            let cell = collectionView.cellForItem(at: item)
//
//            if let imageView = cell?[keyPath: sourceViewKeyPath] as? UIImageView {
//                photos[item.item].imageView = imageView
//                photos[item.item].thumbImage = imageView.image
//            }
//        }
//
//        PhotoBrowser.browser(photos: photos, selectedIndex: selectIndex.item, showIn: self)
//    }
}

class ImageCell: UICollectionViewCell {

    var imageView: UIImageView!


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 20
        self.contentView.addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension WebImage {
    
}

struct PhotoKitConfig: PhotoKitConfigDelegate {
    func setImage(withImageView imageView: UIImageView, url: URL, placeholder: UIImage, progress: @escaping (Int, Int) -> Void, completion: @escaping (UIImage?, URL?, Bool, Error?) -> Void) {
        let progressBlock = { (recivedSize: Int, expectedSize: Int, targetUrl: URL? ) in
            progress(recivedSize, expectedSize)
            }
        let completionBlock = { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, url: URL?) in
            completion(image, url, error == nil ? true : false, error)

        }
        imageView.sd_setImage(with: url, placeholderImage: placeholder, options: .retryFailed, progress: progressBlock, completed: completionBlock)
    }

    func cancelImageRequest(withImageView imageView: UIImageView) {
        imageView.sd_cancelCurrentImageLoad()
    }

    func imageFromCacheForURL(url: URL) -> UIImage? {
        guard let key = SDWebImageManager.shared.cacheKey(for: url) else {
            return nil
        }
        guard let image = SDImageCache.shared.imageFromCache(forKey: key) else {
            return nil
        }
        return image
    }

    func imageFromMemoryForURL(url: URL) -> UIImage? {
        guard let key = SDWebImageManager.shared.cacheKey(for: url) else {
                 return nil
             }
        guard let image = SDImageCache.shared.imageFromMemoryCache(forKey: key) else {
                 return nil
             }
        return image
    }

    func store(image: UIImage, forKey key: String) {
        SDImageCache.shared.store(image, forKey: key, completion: nil)
    }

    func imageFromCache(forKey key: String) -> UIImage? {
        return SDImageCache.shared.imageFromCache(forKey: key)
    }
}

public extension WebImageManager {
    func setImage(withUrl url: URL, placeholder: UIImage, progress: @escaping (Int, Int) -> Void,  completion: @escaping (UIImage?, URL?, Bool, Error?) -> Void) {
        let progressBlock = { (recivedSize: Int, expectedSize: Int, targetUrl: URL? ) in
            progress(recivedSize, expectedSize)
            }
        let completionBlock = { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, url: URL?) in
            completion(image, url, error == nil ? true : false, error)

        }
        self.imageView.sd_setImage(with: url, placeholderImage: placeholder, options: .retryFailed, progress: progressBlock, completed: completionBlock)
    }

    func cancelImageRequest() {
        self.imageView.sd_cancelCurrentImageLoad()
    }

    func imageFromCacheForURL(url: URL) -> UIImage? {
        guard let key = SDWebImageManager.shared.cacheKey(for: url) else {
            return nil
        }
        guard let image = SDImageCache.shared.imageFromCache(forKey: key) else {
            return nil
        }
        return image
    }

    func imageFromMemoryForURL(url: URL) -> UIImage? {
        guard let key = SDWebImageManager.shared.cacheKey(for: url) else {
                 return nil
             }
        guard let image = SDImageCache.shared.imageFromMemoryCache(forKey: key) else {
                 return nil
             }
        return image
    }
}


class SectionHeaderView: UIView {

    let titleLabel: UILabel
    let countLabel: UILabel
    let buttonSeperator: UIView

    var rightButtons: [UIButton] = [] {
        didSet {
            for (index, button) in rightButtons.enumerated() {
                self.addSubview(button)
                var rightMargin: CGFloat = -20
                var rightAnchor: NSLayoutXAxisAnchor = self.rightAnchor
                if index > 0 {
                    rightMargin = -17
                    rightAnchor = rightButtons[index - 1].leftAnchor
                }
                button.translatesAutoresizingMaskIntoConstraints = false
                button.rightAnchor.constraint(equalTo: rightAnchor, constant: rightMargin).isActive = true
                button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                if index != rightButtons.count - 1 {
                    let buttonSeperator = UIView()
                    buttonSeperator.backgroundColor = UIColor.gray
                    self.addSubview(buttonSeperator)
                    buttonSeperator.translatesAutoresizingMaskIntoConstraints = false
                    buttonSeperator.rightAnchor.constraint(equalTo: button.leftAnchor, constant: (rightMargin-1)/2).isActive = true
                    buttonSeperator.widthAnchor.constraint(equalToConstant: 1).isActive = true
                    buttonSeperator.heightAnchor.constraint(equalToConstant: 16).isActive = true
                    buttonSeperator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                }
            }
        }
    }

    var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }

    var count: String = "" {
        didSet {
            self.countLabel.text = count
        }
    }

    override init(frame: CGRect) {
        titleLabel = UILabel()
        countLabel = UILabel()
        buttonSeperator = UIView()
        super.init(frame: frame)

        self.addSubview(titleLabel)
        self.addSubview(countLabel)

        self.setupSubview()
        self.setupSubviewFrames()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubview() {


        self.buttonSeperator.frame = CGRect(x: 0, y: 0, width: 1, height: 16)
        buttonSeperator.backgroundColor = UIColor.gray
        self.titleLabel.font = UIFont.systemFont(ofSize: 16)
        self.titleLabel.textAlignment = .right
        self.titleLabel.backgroundColor = UIColor.red
        self.countLabel.font = UIFont.systemFont(ofSize: 16)
        self.countLabel.backgroundColor = UIColor.yellow

    }

    func setupSubviewFrames() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        self.countLabel.translatesAutoresizingMaskIntoConstraints = false
        self.countLabel.leftAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: 5).isActive = true
        self.countLabel.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor).isActive = true
    }

}
