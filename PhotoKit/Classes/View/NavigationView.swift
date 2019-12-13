//
//  NavigationView.swift
//  ImageEditor
//
//  Created by dimsky on 2019/12/12.
//  Copyright © 2019 dimsky. All rights reserved.
//

import UIKit

class NavigationView: UIView {

    let leftButton: UIButton = UIButton()
    let rightButton: UIButton = UIButton()
    let titleLabel: UILabel = UILabel()

    let contentView: UIView = UIView()

    var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(contentView)
        contentView.addSubview(leftButton)
        contentView.addSubview(rightButton)
        contentView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        leftButton.setImage(UIImage(podAssetName: "icon_close"), for: .normal)
        rightButton.setTitleColor(UIColor.black, for: .normal)
        rightButton.setTitle("确定", for: .normal)
        self.setupFrames()
    }

    func setupFrames() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 44).isActive = true

        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        leftButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20).isActive = true
        leftButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true

        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        rightButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
