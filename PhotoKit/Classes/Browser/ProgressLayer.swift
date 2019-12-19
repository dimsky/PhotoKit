//
//  ProgressLayer.swift
//  ImageEditor
//
//  Created by dimsky on 2019/12/4.
//  Copyright © 2019 dimsky. All rights reserved.
//

import UIKit

class ProgressLayer: CAShapeLayer {


    var isSpinning = false

    var progress: CGFloat = 0.0 {
        didSet {
//            self.strokeEnd = progress
            self.strokeEnd = max(progress, 0.01)
        }
    }

    init(frame: CGRect) {
        super.init()
        self.frame = frame
        self.cornerRadius = 20
        self.fillColor = UIColor.clear.cgColor
        self.strokeColor = UIColor.white.cgColor
        self.lineWidth = 4
        self.lineCap = .round
        self.strokeStart = 0
        self.strokeEnd = 0.01
        self.backgroundColor = UIColor(white: 0, alpha: 0.5).cgColor

        let path = UIBezierPath(roundedRect: self.bounds.inset(by: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)), cornerRadius: 20-2)
        self.path = path.cgPath


        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(layer: Any) {
           super.init(layer: layer)
    }


    @objc func applicationDidBecomeActive(_ noti: Notification) {
        if self.isSpinning {
            self.startSpin()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func startSpin() {
        self.isSpinning = true
        self.spinWithAngle(angle: CGFloat.pi)
    }

    func spinWithAngle(angle: CGFloat) {
        self.strokeEnd = 0.33
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = CGFloat.pi - 0.5
        animation.duration = 0.4
        animation.isCumulative = true
        animation.repeatCount = HUGE
        self.add(animation, forKey: nil)
    }

    func stopSpin() {
        self.isSpinning = false
        self.removeAllAnimations()
    }
}
