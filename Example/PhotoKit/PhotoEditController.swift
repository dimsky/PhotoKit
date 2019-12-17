//
//  PhotoEditController.swift
//  PhotoKit_Example
//
//  Created by dimsky on 2019/12/13.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import XPhotoKit

class PhotoEditController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        let rightButton = UIBarButtonItem(title: "下一步", style: .plain, target: self, action: #selector(nextAction))
        self.navigationItem.rightBarButtonItem = rightButton
    }

    @objc func nextAction() {
        var models: [PhotoModel] = []
        for url in imageUrls {
            let model = PhotoModel(urlString: url)
            models.append(model)
        }

        PhotoBrowser.confirm(photos: models, selectedIndex: 0, showIn: self) { (models) in
            print(models.count)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
