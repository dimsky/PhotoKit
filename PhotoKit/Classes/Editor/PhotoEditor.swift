//
//  ImageEditor.swift
//  ImageEditor
//
//  Created by dimsky on 2019/11/25.
//  Copyright © 2019 dimsky. All rights reserved.
//

import UIKit

open class PhotoEditor: NSObject, PhotoEditActionBarDelegate, PhotoEditControllerDelegate {

    static let shared = PhotoEditor()
    var currentVC: UIViewController?
    var photoModel: PhotoModel?
    var editFinishHandler: ((PhotoModel) -> ())?

    public func actionBarShowIn(vc: UIViewController) -> PhotoEditActionBar {
        let imageEditActionBar = PhotoEditActionBar(frame: CGRect.zero)
        imageEditActionBar.backgroundColor = UIColor.white
        imageEditActionBar.delegate = self
        imageEditActionBar.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(imageEditActionBar)
        vc.view.bringSubviewToFront(imageEditActionBar)

        var height: CGFloat = 60
        if #available(iOS 11.0, *) {
            let safeBottom = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
            height += safeBottom
        }
        imageEditActionBar.leftAnchor.constraint(equalTo: vc.view.leftAnchor) .isActive = true
        imageEditActionBar.heightAnchor.constraint(equalToConstant: height).isActive = true
        imageEditActionBar.rightAnchor.constraint(equalTo: vc.view.rightAnchor, constant: 0).isActive = true
        imageEditActionBar.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor).isActive = true

        currentVC = vc
        return imageEditActionBar
    }

    func addEditFinishHandler(handler: @escaping ((PhotoModel) -> ())) {
        self.editFinishHandler = handler
    }



    //MARK: - DELEGATE
    func photoEditActionBar(_ photoEditActionBar: PhotoEditActionBar, didSelectType type: PhotoEditActionType) {
        guard let model = self.photoModel, model.image != nil else {
            return
        }
        let photoEditVC = type.editController
        photoEditVC.photoModel = model
        photoEditVC.delegate = self
        photoEditVC.modalPresentationStyle = .fullScreen
        currentVC?.present(photoEditVC, animated: false, completion: nil)
    }
    

    func photoEditDidFinish(finalPhoto: UIImage) {
        self.photoModel?.image = finalPhoto
        self.editFinishHandler?(self.photoModel!)
    }

}
