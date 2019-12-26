//
//  PhotoView.swift
//  ImageEditor
//
//  Created by dimsky on 2019/11/26.
//  Copyright © 2019 dimsky. All rights reserved.
//

import UIKit



let PhotoViewPadding: CGFloat = 10

public class PhotoView: UIScrollView, UIScrollViewDelegate {


    //MARK: - VIEW
    var imageView: UIImageView = UIImageView()
    var progressLayer: ProgressLayer = ProgressLayer(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

    //MARK: - DATA
    var model: PhotoModel? {
        didSet {
            self.progressLayer.stopSpin()
            PhotoDelegate?.cancelImageRequest(withImageView: self.imageView)
            if let model = model {
                if let image = model.image {
                        self.imageView.image = image
                }else if let urlString = model.urlString {
                    DispatchQueue.main.async {
                        self.progressLayer.startSpin()
                        self.progressLayer.isHidden = false
                    }
                    PhotoDelegate?.setImage(withImageView: self.imageView, url: URL(string: urlString)! , placeholder: model.thumbImage ?? UIImage(podAssetName: "icon_mosaic_normal")!, progress: { [weak self] (receivedSize, expectedSize) in
                        let progress: CGFloat = CGFloat(receivedSize) / CGFloat(expectedSize)
//                        DispatchQueue.main.async {
//                            self?.progressLayer.isHidden = false
//                            self?.progressLayer.progress = progress
//                        }
                        self?.model?.progress = progress
                    }) { [weak self] (image, url, success, error) in
                        if success {
                            self?.resizeContent()
                            self?.model?.image = image
                        }
                        DispatchQueue.main.async {
                            self?.progressLayer.stopSpin()
                            self?.progressLayer.isHidden = true
                        }
                    }
                }
            } else {
                self.imageView.image = nil
            }
            self.resizeContent()

        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bouncesZoom = true
        self.maximumZoomScale = PhotoViewMaxScale
        self.isMultipleTouchEnabled = true
        self.showsHorizontalScrollIndicator = true
        self.showsVerticalScrollIndicator = true
        self.delegate = self
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }

        self.imageView.contentMode = .scaleAspectFill
//        self.imageView.backgroundColor = .
        self.imageView.clipsToBounds = true
        self.addSubview(imageView)

        self.progressLayer = ProgressLayer(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.layer.addSublayer(self.progressLayer)
        self.progressLayer.isHidden = true
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.progressLayer.position = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
    }

    func resizeContent() {
        if let image = self.imageView.image {
            //图片宽度优先填充屏幕
            let imageSize = image.size
            let width = self.frame.width - 2*PhotoViewPadding
            let height = width * (imageSize.height/imageSize.width)

            self.imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)

            if height <= self.bounds.height {
                self.imageView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
            } else {
                self.imageView.center = CGPoint(x: self.bounds.width/2, y: height/2)
            }

            if width / height > 2 {
                self.maximumZoomScale = self.bounds.height / height
            }

        } else {
            let width = self.frame.width - PhotoViewPadding * 2
            self.imageView.frame = CGRect(x: 0, y: 0, width: width, height: 100)
            self.imageView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        }

        self.contentSize = self.imageView.frame.size
        self.zoomScale = 1.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func cancelCurrentImageLoad() {
        PhotoDelegate?.cancelImageRequest(withImageView: self.imageView)
        self.progressLayer.stopSpin()
    }


    //MARK: - UIScrollViewDelegate
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = scrollView.bounds.width > scrollView.contentSize.width ? (scrollView.bounds.width - scrollView.contentSize.width)/2 : 0
        let offsetY = scrollView.bounds.height > scrollView.contentSize.height ? (scrollView.bounds.height - scrollView.contentSize.height)/2 : 0
        self.imageView.center = CGPoint(x: self.contentSize.width/2 + offsetX, y: self.contentSize.height/2 + offsetY)
    }


    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.panGestureRecognizer {
            if gestureRecognizer.state == .possible {
                if self.isScrollViewOnTopOrBottom() {
                    return false
                }
            }
        }
        return true
    }

    func isScrollViewOnTopOrBottom() -> Bool {
        let translation = self.panGestureRecognizer.translation(in: self)
        if translation.y > 0 && self.contentOffset.y <= 0 {
            return true
        }

        let maxOffsetY = floor(self.contentSize.height - self.bounds.height)
        if translation.y < 0 && self.contentOffset.y >= maxOffsetY {
            return true
        }
        return false
    }
}

