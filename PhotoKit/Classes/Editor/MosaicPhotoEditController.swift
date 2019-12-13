//
//  MosaicPhotoEditController.swift
//  ImageEditor
//
//  Created by dimsky on 2019/11/27.
//  Copyright © 2019 dimsky. All rights reserved.
//

import UIKit




class MosaicPhotoEditController: PhotoEditController {


    //MARK: - VIEW
    let mosaicEditBar: UIView = UIView()
    let blurButton = UIButton()
    let mosaicButton = UIButton()
    let undoButton = UIButton()



    //MARK: - DATA
    var brushs: [UIButton] = []

    var currentBrush: PhotoEditMosaicType = .mosaic

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.mosaicEditBar)
        self.mosaicButton.setImage(UIImage(podAssetName: "icon_mosaic_normal"), for: .normal)
        self.mosaicButton.setImage(UIImage(podAssetName: "icon_mosaic_selected"), for: .selected)
        self.mosaicButton.tag = 1000
        self.blurButton.setImage(UIImage(podAssetName: "icon_mosaic_normal"), for: .normal)
        self.blurButton.tag = 2000
        self.blurButton.setImage(UIImage(podAssetName: "icon_mosaic_selected"), for: .selected)
        self.undoButton.setImage(UIImage(podAssetName: "icon_redo_normal"), for: .normal)
        self.mosaicEditBar.addSubview(self.mosaicButton)
        self.mosaicEditBar.addSubview(self.blurButton)
        self.mosaicEditBar.addSubview(self.undoButton)
        self.mosaicButton.addTarget(self, action: #selector(changeCurrentBrush(_:)), for: .touchUpInside)
        self.blurButton.addTarget(self, action: #selector(changeCurrentBrush(_:)), for: .touchUpInside)
        self.undoButton.addTarget(self, action: #selector(undoAction), for: .touchUpInside)

        let rectHeight: CGFloat = 44
        self.mosaicEditBar.backgroundColor = UIColor.white
        self.mosaicEditBar.frame = CGRect(x: 0, y: self.bottomView.frame.minY - rectHeight, width: self.view.bounds.width, height: rectHeight)

        self.mosaicButton.frame = CGRect(x: 50, y: 0, width: rectHeight, height: rectHeight)
        self.blurButton.frame = CGRect(x: self.mosaicButton.frame.maxX + 20, y: 0, width: rectHeight, height: rectHeight)
        self.undoButton.frame = CGRect(x: self.mosaicEditBar.bounds.width - 20 - rectHeight, y: 0, width: rectHeight, height: rectHeight)

        brushs = [self.mosaicButton, self.blurButton]

        let cgImage = PhotoEditMosaicType.mosaic.mosaicImage(image: photoModel!.image!)
        let uiImage = UIImage(cgImage: cgImage!)
        self.photoView.effectImage = uiImage

        photoView.addDrawBeganHandler { [weak self] in
            self?.mosaicEditBar.alpha = 0
            self?.bottomView.alpha = 0
        }

        photoView.addDrawEndHandler { [weak self] in
            self?.mosaicEditBar.alpha = 1
            self?.bottomView.alpha = 1
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


    @objc func changeCurrentBrush(_ sender: UIButton) {
        for btn in brushs {
            btn.isSelected = false
        }
        sender.isSelected = true

        var uiImage: UIImage?
        if sender.tag == 1000 {
            let cgImage = PhotoEditMosaicType.mosaic.mosaicImage(image: photoModel!.image!)
            uiImage = UIImage(cgImage: cgImage!)
        } else if sender.tag == 2000 {
            let cgImage = PhotoEditMosaicType.blur.mosaicImage(image: photoModel!.image!)
            uiImage = UIImage(cgImage: cgImage!)
        }

        self.photoView.effectImage = uiImage!
    }

    @objc func undoAction() {
        print("undo")
        self.photoView.undo()
    }

}

enum PhotoEditMosaicType {
    case mosaic
    case blur

    var mosaicImage: UIImage {
        switch self {
        case .mosaic:
            return UIImage()
        case .blur:
            return UIImage()
        }
    }

    var ciContext: CIContext {
        let context = CIContext(options: nil)
        return context
    }

    func mosaicImage(image: UIImage) -> CGImage? {
        guard let ciImage = CIImage(image: image) else {
            return nil
        }

        let scale = 40
        var filterStr = "CIPixellate"
        var param = ["inputScale": scale]
        switch self {
        case .mosaic:
            filterStr = "CIPixellate"
            param = ["inputScale": scale]
        case .blur:
            filterStr = "CIGaussianBlur"
            param = ["inputRadius": 20]
        }

        let cImage = ciImage.clampedToExtent().applyingFilter(filterStr, parameters: param).cropped(to: ciImage.extent)

        let cgImage = ciContext.createCGImage(cImage, from: cImage.extent)
        return cgImage

    }
}
