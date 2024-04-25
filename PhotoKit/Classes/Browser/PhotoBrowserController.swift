//
//  PhotoBrowserController.swift
//  ImageEditor
//
//  Created by dimsky on 2019/11/26.
//  Copyright © 2019 dimsky. All rights reserved.
//

import UIKit


class PhotoBrowserController: UIViewController, UIScrollViewDelegate, UIViewControllerTransitioningDelegate, CAAnimationDelegate {

    //MARK: - VIEW
    let scrollView: UIScrollView = UIScrollView()
    let backgroundView: UIVisualEffectView = UIVisualEffectView()
    let pageControl: UIPageControl =  {
        let control = UIPageControl()
        return control
    }()
    let pageLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let navigationView: NavigationView = NavigationView()

    var visibleItemViews: [PhotoViewCell] = []
    var reusableItemViews: Set<PhotoViewCell> = []

    var editBar: PhotoEditActionBar?

    //MARK: - Public Data
    var photos: [PhotoModel]
    var currentIndex: Int
    var pageControlType: PhotoBrowserPageControlType
    var backgroundStyleType: PhotoBrowserBackgroundStyleType
    var maxPageControlCount: Int = 16
    var canEdit: Bool = false
    var canSelect: Bool = false
    var isComfirm = false
    var confirmFinishHandler: (([PhotoModel]) -> Void)?


    var startFrame: CGRect = .zero
    var startLocation: CGPoint = .zero
    var startSourceView: UIImageView?

    let animationDuration: TimeInterval = 0.22

    var optionViewIsHidden = false {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.navigationView.isHidden = self.optionViewIsHidden
                self.setStatusBarHidden(hidden: self.optionViewIsHidden)
                self.editBar?.isHidden = self.optionViewIsHidden
            }

        }
    }
    //MARK: - Override

    init(photos: [PhotoModel], selectedIndex: Int) {
        self.photos = photos
        self.currentIndex = selectedIndex
        self.pageControlType = .text
        self.backgroundStyleType = .black
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .custom
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSubViews()
        self.setupFrames()
        self.addGesture()

        if canEdit {
            let index = self.currentIndex
            let photoModel = self.photos[index]
            editBar = PhotoEditor.shared.actionBarShowIn(vc: self)
            PhotoEditor.shared.photoModel = photoModel
            PhotoEditor.shared.addEditFinishHandler { [weak self](model) in
                guard let s = self else {
                    return
                }
                s.photos[index] = model
                s.scrollViewDidScroll(s.scrollView)
            }
        }

        if isComfirm {
            self.navigationView.rightButton.setTitle("确定", for: .normal)
            self.navigationView.rightButton.photoKit_setEventHandler(event: .touchUpInside) { [weak self] (uibutton) in
                guard let s = self else {
                    return
                }
                s.startDismissAnimation()
                s.confirmFinishHandler?(s.photos)
            }
        } else {
            self.navigationView.rightButton.setTitle("", for: .normal)
        }


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.backgroundView.alpha = 1;
        let photo = photos[self.currentIndex]
        guard let photoView = self.photoViewForPage(page: self.currentIndex) else {
            return
        }


        photoView.photoView.imageView.image = photo.thumbImage
        photoView.photoView.resizeContent()

        if self.presentedViewController != nil {
            photoView.model = photo
            return
        }

        if let sourceView = photo.imageView, self.presentingViewController != nil {
            self.startSourceView = photo.imageView
//            sourceView.alpha = 0
            self.startSourceView?.alpha = 0
            let endRect = photoView.photoView.imageView.frame
            let sourceRect = sourceView.superview!.convert(sourceView.frame, to: photoView)
            photoView.photoView.imageView.frame = sourceRect
            let startBounds = CGRect(x: 0, y: 0, width: sourceRect.width, height: sourceRect.height)
            let endBounds = CGRect(x: 0, y: 0, width: endRect.width, height: endRect.height)
            let startPath = UIBezierPath(roundedRect: startBounds, cornerRadius: max(sourceView.layer.cornerRadius, 0.1))
            let endPath = UIBezierPath(roundedRect: endBounds, cornerRadius: 0.1)
            let maskLayer = CAShapeLayer()
            maskLayer.frame = endBounds
            photoView.photoView.imageView.layer.mask = maskLayer

            let maskAnimation = CABasicAnimation(keyPath: "path")
            maskAnimation.duration = animationDuration
            maskAnimation.fromValue = startPath.cgPath
            maskAnimation.toValue = endPath.cgPath
            maskAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            maskLayer.add(maskAnimation, forKey: nil)
            maskLayer.path = endPath.cgPath

            UIView.animate(withDuration: animationDuration, animations: {
                photoView.photoView.imageView.frame = endRect
                self.backgroundView.alpha = 1
                self.startSourceView?.alpha = 0
                self.navigationView.alpha = 0.8
            }) { (finished) in
                photoView.model = photo
//                self.setStatusBarHidden(hidden: true)
                photoView.photoView.imageView.layer.mask = nil
                self.startSourceView?.alpha = 0

            }
        } else {
            photoView.alpha = 0
            UIView.animate(withDuration: animationDuration, animations: {
                self.backgroundView.alpha = 1
                photoView.alpha = 1
                self.navigationView.alpha = 0.8
            }) { (finished) in
                photoView.model = photo
//                self.setStatusBarHidden(hidden: true)
                self.startSourceView?.alpha = 0
            }
        }

        self.navigationView.title = "\(self.currentIndex + 1)/\(self.photos.count)"
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.setupFrames()
    }

    //MARK: - Private
    func setupSubViews() {
        self.backgroundView.effect = UIBlurEffect(style: .dark)
        self.view.backgroundColor = UIColor.clear
        self.backgroundView.contentMode = .scaleAspectFill
        self.view.addSubview(self.backgroundView)

        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)

        self.pageLabel.font = UIFont.systemFont(ofSize: 16)
        self.pageLabel.textColor = UIColor.white
        self.pageLabel.textAlignment = .center
        switch self.pageControlType {
        case .dot:
            if photos.count < maxPageControlCount && photos.count > 1 {
                self.pageControl.currentPage = currentIndex
                self.pageControl.numberOfPages = photos.count
                self.view.addSubview(self.pageControl)
            } else {
                self.navigationView.title = "\(self.currentIndex + 1)/\(self.photos.count)"
            }
        case .text:
            self.navigationView.title = "\(self.currentIndex + 1)/\(self.photos.count)"
        }

        self.view.addSubview(self.navigationView)
        self.navigationView.backgroundColor = UIColor.white
        self.navigationView.alpha = 0
        self.navigationView.translatesAutoresizingMaskIntoConstraints = false
        self.navigationView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.navigationView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.navigationView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        var height: CGFloat = 44
        if #available(iOS 11.0, *) {
            let safeTop = UIApplication.shared.keyWindow!.safeAreaInsets.top
            height = safeTop > 0 ? height + safeTop : height + 20
        } else {
            height = height + 20
        }

        self.navigationView.heightAnchor.constraint(equalToConstant: height).isActive = true

        self.navigationView.leftButton.photoKit_setEventHandler(event: .touchUpInside) { [weak self] (button) in
            self?.startDismissAnimation()
        }
    }

    func setupFrames() {
        var rect = self.view.bounds
        self.backgroundView.frame = rect

        // 图片与图片之
        rect.origin.x -= PhotoViewPadding
        rect.size.width += 2.0 * PhotoViewPadding
        self.scrollView.frame = rect

        let pageRect = CGRect(x: 0, y: 20, width: self.view.bounds.width, height: 40)
        self.pageControl.frame = pageRect
        self.pageLabel.frame = pageRect

        for photoView in visibleItemViews {
            var rect = self.scrollView.bounds
            rect.origin.x = CGFloat(photoView.tag)  * self.scrollView.bounds.width
            photoView.frame = rect
            photoView.photoView.resizeContent()
        }

        let contentOffset = CGPoint(x: self.scrollView.frame.width * CGFloat(self.currentIndex), y: 0)
        self.scrollView.contentOffset = contentOffset
        if contentOffset.x == 0 {
            self.scrollViewDidScroll(self.scrollView)
        }

        let contentSize = CGSize(width: rect.width * CGFloat(photos.count), height: rect.height)
        self.scrollView.contentSize = contentSize


    }

    func setStatusBarHidden(hidden: Bool) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        if hidden {
            window.windowLevel = .statusBar + 1
        } else {
            window.windowLevel = .normal
        }
    }


    func addGesture() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(doubleTap)

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(didSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.require(toFail: doubleTap)
        self.scrollView.addGestureRecognizer(singleTap)

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        self.view.addGestureRecognizer(longPress)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        pan.maximumNumberOfTouches = 1
        self.view.addGestureRecognizer(pan)

    }

    //MARK: - UIScrollview item 重用
    var dequeueReusableItemView: PhotoViewCell {
        if let photoView = self.reusableItemViews.first {
            self.reusableItemViews.remove(photoView)
            photoView.tag = -1
            return photoView
        } else {
            let photoView = PhotoViewCell(frame: self.scrollView.bounds)
            photoView.tag = -1
            return photoView
        }
    }

    func photoViewForPage(page: Int) -> PhotoViewCell? {
        for photoView in visibleItemViews {
            if photoView.tag == page {
                return photoView
            }
        }
        return nil
    }

    func updateResuableItemViews() {
        for photoView in self.visibleItemViews {
            if photoView.tag + 1 < self.currentIndex || photoView.tag > self.currentIndex + 1 {
                photoView.removeFromSuperview()
                photoView.model = nil
                self.visibleItemViews.removeAll{$0 == photoView}
                self.reusableItemViews.insert(photoView)
            }
        }
    }

    func configItemViews() {
        let page = Int(self.scrollView.contentOffset.x / self.scrollView.frame.width + 0.5)
        for i in stride(from: page - 1, to: page + 2, by: 1) {
            if i < 0 || i >= photos.count {
                continue
            }
            var photoView = self.photoViewForPage(page: i)
            if photoView  == nil {
                photoView = self.dequeueReusableItemView
                var rect = self.scrollView.bounds
                rect.origin.x = CGFloat(i) * self.scrollView.bounds.width
                photoView?.frame = rect
                photoView?.tag = i
                self.scrollView.addSubview(photoView!)
                self.visibleItemViews.append(photoView!)
            }
            if photoView?.model == nil {
                photoView?.model = photos[i]
            }
        }

        if self.currentIndex != page && page >= 0 && page < photos.count {
            self.currentIndex = page
            // todo didselectedItemChange
            self.startSourceView?.alpha = 1
            self.startSourceView = photos[self.currentIndex].imageView
            self.startSourceView?.alpha = 0
            print("selectedIndex Change \(self.currentIndex)")
            self.indexDidChange(currentIndex: self.currentIndex)
        }
    }

    func reloadData() {
        self.scrollViewDidScroll(self.scrollView)
    }

    func indexDidChange(currentIndex: Int) {
        PhotoEditor.shared.photoModel = self.photos[currentIndex]
        self.navigationView.title = "\(self.currentIndex + 1)/\(self.photos.count)"

    }

    //MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateResuableItemViews()
        self.configItemViews()
    }

    //MARK: - UIGestureRecognizer

    @objc func didDoubleTap(_ gesture: UIGestureRecognizer) {
        guard let photoView = self.photoViewForPage(page: self.currentIndex) else {
            return
        }

        if photoView.photoView.zoomScale > CGFloat(1.0) {
            photoView.photoView.setZoomScale(1, animated: true)
        } else {
            let location = gesture.location(in: photoView)
            let maxZoomScale = photoView.photoView.maximumZoomScale
            let width = self.view.bounds.width / maxZoomScale
            let height = self.view.bounds.height / maxZoomScale
            photoView.photoView.zoom(to: CGRect(x: location.x - width/2, y: location.y - height/2, width: width, height: height), animated: true)
        }
    }

    @objc func didSingleTap(_ gesture: UITapGestureRecognizer) {
//        self.startDismissAnimation()
        optionViewIsHidden = !optionViewIsHidden


    }

    // 解决 modalPresentationStyle = .custom 或者 overfullscreen 情况下 UIActivityViewController将本页面dissmiss 的问题
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let vc = self.presentedViewController as? UIActivityViewController {
            vc.dismiss(animated: flag, completion: completion)
            return
        }
        super.dismiss(animated: flag, completion: completion)
    }

    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard let photoView = self.photoViewForPage(page: self.currentIndex) else {
            return
        }
        let image = photoView.photoView.imageView.image
        let activityVC = UIActivityViewController(activityItems: [image as Any], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityVC.popoverPresentationController?.sourceView = gesture.view
            let point = gesture.location(in: gesture.view!)
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: point.x, y: point.y, width: 1, height: 1)
        }
        self.present(activityVC, animated: true, completion: nil)
    }


    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
        guard self.isComfirm == false else {
            return
        }
        guard let photoView = self.photoViewForPage(page: self.currentIndex) else {
            return
        }
        if photoView.photoView.zoomScale > 1.1 {
            return
        }
        let point = gesture.translation(in: self.view)
        let location = gesture.location(in: photoView)
        let velocity = gesture.velocity(in: self.view)

        switch gesture.state {
        case .began:
            self.startFrame = photoView.photoView.imageView.frame
            self.startLocation = location
            self.photos[self.currentIndex].imageView?.alpha = 0
            self.optionViewIsHidden = true
            photoView.photoView.cancelCurrentImageLoad()
        case .changed:
            let percent = 1.0 - abs(point.y) / self.view.frame.height
            let s = max(percent, 0.3)

            let width = self.startFrame.width * s
            let height = self.startFrame.height * s

            let rateX = (self.startLocation.x - self.startFrame.minX) / self.startFrame.width
            let x = location.x - width * rateX
            let rateY = (self.startLocation.y - self.startFrame.minY) / self.startFrame.height
            let y = location.y - height * rateY

            photoView.photoView.imageView.frame = CGRect(x: x, y: y, width: width, height: height)
            self.backgroundView.alpha = percent
        case .cancelled, .ended:
            if abs(point.y) > 100 || abs(velocity.y) > 500 {
                self.startDismissAnimation()
            } else {
                self.startCancelAnimation()
            }
        default:
            break
        }
    }


    func customDismiss(animated: Bool) {
        for photoView in self.visibleItemViews {
            photoView.photoView.cancelCurrentImageLoad()
        }
        let photo = photos[self.currentIndex]
        if animated {
            UIView.animate(withDuration: animationDuration) {
                photo.imageView?.alpha = 1
            }
        } else {
            photo.imageView?.alpha = 1
        }
        self.startSourceView?.alpha = 1
        self.dismiss(animated: false, completion: nil)
    }

    func startDismissAnimation() {
        print("dismiss")
        let photo = photos[self.currentIndex]
        guard let photoView = self.photoViewForPage(page: self.currentIndex) else {
            return
        }
        photoView.photoView.cancelCurrentImageLoad()
        self.setStatusBarHidden(hidden: false)

        if let sourceView = photo.imageView, let sourceSuperView = sourceView.superview {
            sourceView.alpha = 0
            let sourceRect = sourceSuperView.convert(sourceView.frame, to: photoView)
            let startRect = photoView.photoView.imageView.frame
            let endBounds = CGRect(x: 0, y: 0, width: sourceRect.width, height: sourceRect.height)
            let startBounds = CGRect(x: 0, y: 0, width: startRect.width, height: startRect.height)
            let startPath = UIBezierPath(roundedRect: startBounds, cornerRadius: 0.1)
            let endPath = UIBezierPath(roundedRect: endBounds, cornerRadius: max(sourceView.layer.cornerRadius, 0.1))
            let maskLayer = CAShapeLayer()

            maskLayer.frame = endBounds
            photoView.photoView.imageView.layer.mask = maskLayer

            let maskAnimation = CABasicAnimation(keyPath: "path")
            maskAnimation.duration = animationDuration
            maskAnimation.fromValue = startPath.cgPath
            maskAnimation.toValue = endPath.cgPath
            maskAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            maskLayer.add(maskAnimation, forKey: nil)
            maskLayer.path = endPath.cgPath

            UIView.animate(withDuration: animationDuration, animations: {
                photoView.photoView.imageView.frame = sourceRect
                self.backgroundView.alpha = 0
                self.navigationView.alpha = 0
                self.editBar?.alpha = 0
            }) { (finished) in
                self.customDismiss(animated: false)
            }
        } else {
            UIView.animate(withDuration: animationDuration, animations: {
                self.view.alpha = 0
            }) { (finished) in
                self.customDismiss(animated: false)
            }
        }
    }

    func startCancelAnimation() {
        print("cancel")
        let photoView = self.photoViewForPage(page: self.currentIndex)
        let photo = photos[self.currentIndex]
//        photo.imageView?.alpha = 1

        UIView.animate(withDuration: animationDuration, animations: {
            photoView?.photoView.imageView.frame = self.startFrame
            self.backgroundView.alpha = 1
        }) { (finished) in
//            self.setStatusBarHidden(hidden: true)
            self.optionViewIsHidden = false
            photoView?.model = photo
        }
    }
}






