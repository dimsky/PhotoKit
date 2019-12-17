//
//  BundleHelper.swift
//  PhotoKit
//
//  Created by dimsky on 2019/12/13.
//

import UIKit

class _BundleHelper {}


extension Bundle {

    public class var pod: Bundle {
        let url = Bundle(for: _BundleHelper.self).url(forResource: "PhotoKit", withExtension: "bundle")
        return Bundle(url: url!)!
    }
}

extension UIImage {
    convenience init?(podAssetName: String) {
        self.init(named: podAssetName, in: Bundle.pod, compatibleWith: nil)
    }
}
