//
//  PhotoEditManager.swift
//  ImageEditor
//
//  Created by dimsky on 2019/11/28.
//  Copyright © 2019 dimsky. All rights reserved.
//

import UIKit

class PhotoEditManager: NSObject {
    var cacheArray: [UIImage] = []
    let originalImage: UIImage

    var currentIndex: Int = -1
    var actionCount: Int = 0

    init(originalImage: UIImage) {
        self.originalImage = originalImage
        super.init()
    }

    func redo() -> UIImage {
        if currentIndex + 1  < cacheArray.count {
            currentIndex += 1
        }
        return cacheArray[currentIndex]
    }

    func undo() -> UIImage {
        if currentIndex - 1 >= 0 {
            currentIndex -= 1
        }
        return cacheArray[currentIndex]
    }

    func cacheImage(image: UIImage) {

        if currentIndex < cacheArray.count-1 {
            cacheArray.removeSubrange(currentIndex+1...cacheArray.count-1)
        }
        currentIndex += 1
        cacheArray.append(image)
        actionCount = currentIndex
    }


    func clearCache() {
        self.cacheArray.removeAll()
        currentIndex = 0
    }

}

