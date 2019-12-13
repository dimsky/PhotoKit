//
//  PhotoEditActionBar.swift
//  PhotoEditor
//
//  Created by dimsky on 2019/11/25.
//  Copyright © 2019 dimsky. All rights reserved.
//

import UIKit

public class PhotoEditActionBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    let defaultActions: [PhotoEditActionType] = [.mosaic]
    var actionBarCollectionView: UICollectionView!
    var actionDetailView: UIView!
    var itemSize = CGSize(width: 60, height: 60)

    weak var delegate: PhotoEditActionBarDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = itemSize
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10;
        actionBarCollectionView = UICollectionView(frame: .zero, collectionViewLayout:
            flowLayout)
        actionBarCollectionView.showsHorizontalScrollIndicator = false
        actionBarCollectionView.backgroundColor = UIColor.white
        actionBarCollectionView.delegate = self
        actionBarCollectionView.dataSource = self

        actionBarCollectionView.register(ActionBarCell.self, forCellWithReuseIdentifier: "ActionBarCell")
        self.addSubview(actionBarCollectionView)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        actionBarCollectionView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 60)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaultActions.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionBarCell", for: indexPath) as! ActionBarCell
        cell.actionType = defaultActions[indexPath.item]
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.photoEditActionBar(self, didSelectType: defaultActions[indexPath.item])
    }
}

class ActionBarCell: UICollectionViewCell {


    var actionType: PhotoEditActionType = .mosaic {
        didSet {
            imageButton.setImage(actionType.icon, for: .normal)
            imageButton.setImage(actionType.iconSelected, for: .selected)
            label.text = actionType.title
        }
    }

    let imageButton: UIButton = UIButton()
    let label: UILabel = UILabel()

    override var isSelected: Bool {
        didSet {
//            imageButton.isSelected = self.isSelected
//            print("选择 \(isSelected)")
        }
    }


    override var isHighlighted: Bool {
        didSet {
//            print("高亮 \(isHighlighted)")
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubView()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    func createSubView() {
        self.contentView.addSubview(imageButton)
        self.contentView.addSubview(label)
        imageButton.isUserInteractionEnabled = false
        imageButton.frame = CGRect(x: 9, y: 0, width: self.contentView.bounds.width - 18, height: self.contentView.bounds.width - 18)
        label.frame = CGRect(x: 0, y: self.contentView.bounds.width - 18, width: self.contentView.bounds.width, height: 8)
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.black
        label.textAlignment = .center
    }
}

enum PhotoEditActionType {
    case mosaic     //马赛克
    case crop       //裁剪
    case text       //文字
    case filter     //滤镜
    case sticker    //贴纸


    var icon: UIImage {
        switch self {
            case .mosaic:
                return UIImage(podAssetName: "icon_mosaic_normal")!
            case .crop:
                return UIImage(podAssetName: "icon_mosaic_normal")!
            case .text:
                return UIImage(podAssetName: "icon_mosaic_normal")!
            case .filter:
                return UIImage(podAssetName: "icon_mosaic_normal")!
            case .sticker:
                return UIImage(podAssetName: "icon_mosaic_normal")!
        }
    }
    var iconSelected: UIImage {
        switch self {
            case .mosaic:
                return UIImage(podAssetName: "icon_mosaic_selected")!
            case .crop:
                return UIImage(podAssetName: "icon_mosaic_selected")!
            case .text:
                return UIImage(podAssetName: "icon_mosaic_selected")!
            case .filter:
                return UIImage(podAssetName: "icon_mosaic_selected")!
            case .sticker:
                return UIImage(podAssetName: "icon_mosaic_selected")!
        }

    }

    var title: String {
        switch self {
            case .mosaic:
                return "马赛克"
            case .crop:
                return "裁剪"
            case .text:
                return "文字"
            case .filter:
                return "滤镜"
            case .sticker:
                return "贴图"
        }
    }

    var editController: PhotoEditController {
        switch self {
            case .mosaic:
                return MosaicPhotoEditController()
            case .crop:
                return PhotoEditController()
            case .text:
                return PhotoEditController()
            case .filter:
                return PhotoEditController()
            case .sticker:
                return PhotoEditController()
        }
    }

    func photoEditController() -> PhotoEditController {
        switch self {
            case .mosaic:
                return MosaicPhotoEditController()
            case .crop:
                return PhotoEditController()
            case .text:
                return PhotoEditController()
            case .filter:
                return PhotoEditController()
            case .sticker:
                return PhotoEditController()
        }
    }
}

protocol PhotoEditActionBarDelegate: NSObjectProtocol {
//    func photoViewActionBar(_ photoEditActionBar: PhotoEditActionBar, didSelectType type: PhotoEditActionType)


    func photoEditActionBar(_ photoEditActionBar: PhotoEditActionBar, didSelectType type: PhotoEditActionType)
}
