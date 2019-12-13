//
//  PhotoEditView.swift
//  ImageEditor
//
//  Created by dimsky on 2019/11/26.
//  Copyright © 2019 dimsky. All rights reserved.
//

import UIKit

class PhotoEditView: UIScrollView, UIScrollViewDelegate {

    //MARK: - VIEW

    //原图
    var imageView: UIImageView = UIImageView()

    //背景效果
    var effectImageLayer: CALayer?

    //前景遮罩
    var maskShapeLayer: CAShapeLayer?

    //MARK: - DATA
    var model: PhotoModel? {
        didSet {
            self.imageView.image = model?.image
            self.originImage = model!.image!
            self.editFinalImage = self.originImage
            self.editManager = PhotoEditManager(originalImage: self.originImage)
            self.editManager.cacheImage(image: self.model!.image!)
            self.resizeContent()
        }
    }

    //原图
    var originImage: UIImage = UIImage()

    //最后编辑图
    var editFinalImage: UIImage = UIImage()

    //背景效果图
    var effectImage: UIImage? {
        didSet {
            self.resetPhoto()
        }
    }

    var bezierPath: UIBezierPath = UIBezierPath()
    var brushWidth: CGFloat = 20
    var currentBrushWidth: CGFloat = 20
    var currentPath: PhotoEditPath?
    var pathArray: [PhotoEditPath] = []

    var editManager: PhotoEditManager!

    var drawBeganHandler: (() -> Void)?
    var drawEndHandler: (() -> Void)?


    //MARK: - OVERRIDE
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.bouncesZoom = true
        self.maximumZoomScale = PhotoViewMaxScale
        self.showsHorizontalScrollIndicator = true
        self.showsVerticalScrollIndicator = true
        self.delegate = self
//        self.isScrollEnabled = false

        if #available(iOS 11.0, *) {
//            self.scrollView.setContentOffset(CGPoint(x: 0, y: UIApplication.shared.keyWindow!.safeAreaInsets.top) , animated: false)
            self.contentInsetAdjustmentBehavior = .never
//            if UIApplication.shared.delegate!.window!!.safeAreaInsets.top > 0 {
//                self.scrollView.setContentOffset(CGPoint(x: 0, y: 20) , animated: false)
//            }
        }

        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        self.addSubview(imageView)

        self.imageView.image = self.originImage
        self.editFinalImage = self.originImage

        self.panGestureRecognizer.minimumNumberOfTouches = 2;


        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        panGesture.maximumNumberOfTouches = 1
        self.imageView.addGestureRecognizer(panGesture)
        self.imageView.isUserInteractionEnabled = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - PRIVATE
    func resizeContent() {
        if let image = self.imageView.image {
            //图片宽度优先填充屏幕
            let imageSize = image.size
            let width = self.frame.width
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
            let width = self.frame.width
            self.imageView.frame = CGRect(x: 0, y: 0, width: width, height: width * 2.0 / 3)
            self.imageView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        }

        self.contentSize = self.imageView.frame.size
        self.zoomScale = 1.0
    }

    func resetPhoto() {
        self.bezierPath = UIBezierPath()

        self.imageView.image = self.editFinalImage

        self.pathArray.removeAll()

        self.maskShapeLayer?.removeFromSuperlayer()
        self.maskShapeLayer = nil

        self.effectImageLayer?.removeFromSuperlayer()
        self.effectImageLayer = nil

        if let effectImage = effectImage {
            self.effectImageLayer = CALayer()
            self.effectImageLayer?.frame = self.imageView.bounds
            self.imageView.layer.addSublayer(self.effectImageLayer!)
            self.effectImageLayer?.contents = effectImage.cgImage!
        }
        self.maskShapeLayer = CAShapeLayer()
        self.maskShapeLayer?.frame = self.imageView.bounds
        self.maskShapeLayer?.lineCap = .round
        self.maskShapeLayer?.lineJoin = .round
        self.maskShapeLayer?.lineWidth = self.currentBrushWidth
        self.maskShapeLayer?.strokeColor = UIColor.blue.cgColor
        self.maskShapeLayer?.fillColor = nil
        self.imageView.layer.addSublayer(self.maskShapeLayer!)
        self.effectImageLayer?.mask = self.maskShapeLayer
    }

    func undo() {
        guard let image = self.editManager.undo() else {
            return
        }
        self.editFinalImage = image
        self.resetPhoto()
    }

    func redo() {
        guard let image = self.editManager.redo() else {
            return
        }
        self.editFinalImage = image
        self.resetPhoto()
    }

    //MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = scrollView.bounds.width > scrollView.contentSize.width ? (scrollView.bounds.width - scrollView.contentSize.width)/2 : 0
        let offsetY = scrollView.bounds.height > scrollView.contentSize.height ? (scrollView.bounds.height - scrollView.contentSize.height)/2 : 0
        self.imageView.center = CGPoint(x: self.contentSize.width/2 + offsetX, y: self.contentSize.height/2 + offsetY)

//        self
        currentBrushWidth = self.brushWidth / scrollView.zoomScale


        self.maskShapeLayer?.lineWidth = currentBrushWidth
    }

//    var touch: UITouch? = nil

    func addDrawBeganHandler(handler: @escaping ()->Void) {
        self.drawBeganHandler = handler
    }

    func addDrawEndHandler(handler: @escaping ()->Void) {
        self.drawEndHandler = handler
    }

    @objc func panGestureAction(_ gesture: UIGestureRecognizer) {
        let location = gesture.location(in: self.imageView)

        switch gesture.state {
        case .began:
            self.drawBeganHandler?()
            self.drawBegan(location: location)
        case .changed:
            self.drawChanged(location: location)
        case .ended:
            self.drawEndHandler?()
            self.drawEnded(location: location)
        case .possible:
            print("possible")
        case .cancelled, .failed:
            self.drawEndHandler?()
            print("failed")
        @unknown default:
            print("failed")
        }
    }

    func drawBegan(location: CGPoint) {
        self.bezierPath.move(to: location)
        self.maskShapeLayer?.path = self.bezierPath.cgPath

        let size = self.imageView.image!.size
        let rate = size.width / self.imageView.bounds.width
        let path = UIBezierPath()
        path.move(to: CGPoint(x: location.x * rate, y: location.y * rate))

        self.currentPath = PhotoEditPath(width: self.currentBrushWidth)
        self.currentPath?.path = path
    }

    func drawChanged(location: CGPoint) {
        self.bezierPath.addLine(to: location)
        self.maskShapeLayer?.path = self.bezierPath.cgPath

        let size = self.imageView.image!.size
        let rate = size.width / self.imageView.bounds.width
        self.currentPath?.path?.addLine(to: CGPoint(x: location.x * rate, y: location.y * rate))
    }

    func drawEnded(location: CGPoint) {
        guard let currentPath = self.currentPath else {
            return
        }

        let size = self.imageView.image!.size
        let rate = size.width / self.imageView.bounds.width

        UIGraphicsBeginImageContext(size)
        self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let context = UIGraphicsGetCurrentContext()

        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        context?.setBlendMode(.clear)
        context?.setLineWidth(currentPath.width * rate)
        context?.addPath(currentPath.path!.cgPath)
        context?.strokePath()
        let finalPathImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        UIGraphicsBeginImageContextWithOptions(size, true, 1)
        self.effectImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        finalPathImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.editFinalImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        self.pathArray.append(currentPath)
        self.editManager.cacheImage(image: self.editFinalImage)
        self.resetPhoto()
    }


    func resizepath(fitin size : CGSize , path : CGPath) -> CGPath{
            let boundingBox = path.boundingBox
            let boundingBoxAspectRatio = boundingBox.width / boundingBox.height
            let viewAspectRatio = frame.width  / frame.height
            var scaleFactor : CGFloat = 1.0
            if (boundingBoxAspectRatio > viewAspectRatio) {
                // Width is limiting factor

                scaleFactor = frame.width / boundingBox.width
            } else {
                // Height is limiting factor
                scaleFactor = frame.height / boundingBox.height
            }


            var scaleTransform = CGAffineTransform.identity
            scaleTransform = scaleTransform.scaledBy(x: scaleFactor, y: scaleFactor)
            scaleTransform.translatedBy(x: -boundingBox.minX, y: -boundingBox.minY)

        let scaledSize = boundingBox.size.applying(CGAffineTransform (scaleX: scaleFactor, y: scaleFactor))
       let centerOffset = CGSize(width: (frame.width - scaledSize.width ) / scaleFactor * 2.0, height: (frame.height - scaledSize.height) /  scaleFactor * 2.0 )
        scaleTransform = scaleTransform.translatedBy(x: centerOffset.width, y: centerOffset.height)
        //CGPathCreateCopyByTransformingPath(path, &scaleTransform)
        let  scaledPath = path.copy(using: &scaleTransform)

        return scaledPath!
    }

//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
//            return false
//        }
//
//        return true
//    }


}


class PhotoEditPath {
    var blendMode: CGBlendMode = .clear
    var width: CGFloat
    var startPoint: CGPoint?
    var endPoint: CGPoint?
    var pathPointArray: [CGPoint]?
    var path: UIBezierPath?

    init(width: CGFloat) {
        self.width = width
    }
}
