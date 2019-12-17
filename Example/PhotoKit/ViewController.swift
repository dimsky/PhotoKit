//
//  ViewController.swift
//  PhotoKit
//
//  Created by dimsky@163.com on 12/13/2019.
//  Copyright (c) 2019 dimsky@163.com. All rights reserved.
//

import UIKit

import SDWebImage
import XPhotoKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    let data: [(String, UIViewController)] = [
        ("图片预览", PhotoPreviewTestController()),
        ("图片编辑", PhotoEditController()),
        ("图片选择", PhotoPreviewTestController()),

    ]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)

        cell.textLabel?.text = data[indexPath.item].0
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(data[indexPath.row].1, animated: true)
    }

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "PhotoKit"
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")

        self.view.addSubview(tableView)
    }

}
