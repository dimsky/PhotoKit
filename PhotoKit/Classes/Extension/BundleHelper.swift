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
        return Bundle(for: _BundleHelper.self)
    }
}

extension UIImage {
    convenience init?(podAssetName: String) {
        self.init(named: podAssetName, in: Bundle.pod, compatibleWith: nil)
    }
}
