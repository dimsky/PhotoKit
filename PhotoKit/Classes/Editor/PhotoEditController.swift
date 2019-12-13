//
//  PhotoEditController.swift
//  ImageEditor
//
//  Created by dimsky on 2019/11/26.
//  Copyright © 2019 dimsky. All rights reserved.
//

import UIKit

class PhotoEditController: UIViewController {

    var photoModel: PhotoModel?

    var bottomView: UIView = UIView()
    var cancelButton: UIButton!
    var confirmButton: UIButton!
    weak var delegate: PhotoEditControllerDelegate?

    var photoView: PhotoEditView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black

        photoView = PhotoEditView(frame: self.view.bounds)
        if let model = self.photoModel {
            photoView.model = model
        }

        self.view.addSubview(photoView)

        cancelButton = UIButton(frame: .zero)
        cancelButton.setTitle("取消", for: .normal)
        confirmButton = UIButton(frame: .zero)
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)

        bottomView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.4)

        self.view.addSubview(bottomView)
        bottomView.addSubview(cancelButton)
        bottomView.addSubview(confirmButton)

        self.setupFrames()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        self.bottomView.alpha = 0
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.bottomView.alpha = 1
    }

    func setupFrames() {
        var rectHeight: CGFloat = 44
        var rectY = self.view.bounds.height - rectHeight

        cancelButton.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width/2, height: rectHeight)
        confirmButton.frame = CGRect(x: self.view.bounds.width/2, y: 0, width: self.view.bounds.width/2, height: rectHeight)

        if #available(iOS 11.0, *) {
            let safeBottom = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
            rectY -= safeBottom
            rectHeight += safeBottom
        }
        bottomView.frame = CGRect(x: 0, y: rectY, width: self.view.bounds.width, height: rectHeight)
    }

    @objc func cancelAction() {
        self.dismiss(animated: false, completion: nil)
    }

    @objc func confirmAction() {
        let image = self.photoView.editFinalImage
        delegate?.photoEditDidFinish(finalPhoto: image)
        self.dismiss(animated: false, completion: nil)

    }
}

protocol PhotoEditControllerDelegate: NSObjectProtocol {
    func photoEditDidFinish(finalPhoto: UIImage)
}
