//
//  HUDHelper.swift
//  XPhotoKit
//
//  Created by dimsky on 2020/4/13.
//

import UIKit


private var mainBounds: CGRect {
    if #available(iOS 13, *) {
        for scene in UIApplication.shared.connectedScenes {
            if scene.activationState == .foregroundActive {
                if let delegate = scene.delegate as? UIWindowSceneDelegate {
                    if let frame = delegate.window??.bounds {
                        return frame
                    }
                }
            }
        }
    }
    return UIApplication.shared.windows[0].bounds
}

var hud: HUDHelper = HUDHelper.shared
private var hudWindow: UIWindow?

class HUDHelper {
    static let shared: HUDHelper = HUDHelper()

    init() {
        createHUDWindowIfNeeded()
    }

    var hudDidHide: (() -> Void)?

    func createHUDWindowIfNeeded() {
        if hudWindow == nil {

            let window = UIWindow(frame: CGRect(x: mainBounds.midX - 25, y: mainBounds.midY - 25, width: 50, height: 50))
            window.alpha = 1
            window.isHidden = false
            window.windowLevel = .alert
            let layer = ProgressLayer(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            window.layer.addSublayer(layer)
            hudDidHide = {
                hudWindow = nil
            }
            hudWindow = window
            layer.startSpin()
        }
    }

    func loading() {
        createHUDWindowIfNeeded()

    }

    func hide() {
        hudDidHide?()
    }


}
