//
//  ProgressLayer.swift
//  ImageEditor
//
//  Created by dimsky on 2019/12/4.
//  Copyright © 2019 dimsky. All rights reserved.
//

import UIKit


class NVActivityIndicatorAnimationPacman {

    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        circleInLayer(layer, size: size, color: color)
        pacmanInLayer(layer, size: size, color: color)
    }

    func pacmanInLayer(_ layer: CALayer, size: CGSize, color: UIColor) {
        let pacmanSize = 2 * size.width / 3
        let pacmanDuration: CFTimeInterval = 0.5
        #if swift(>=4.2)
        let timingFunction = CAMediaTimingFunction(name: .default)
        #else
        let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        #endif

        // Stroke start animation
        let strokeStartAnimation = CAKeyframeAnimation(keyPath: "strokeStart")

        strokeStartAnimation.keyTimes = [0, 0.5, 1]
        strokeStartAnimation.timingFunctions = [timingFunction, timingFunction]
        strokeStartAnimation.values = [0.125, 0, 0.125]
        strokeStartAnimation.duration = pacmanDuration

        // Stroke end animation
        let strokeEndAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")

        strokeEndAnimation.keyTimes = [0, 0.5, 1]
        strokeEndAnimation.timingFunctions = [timingFunction, timingFunction]
        strokeEndAnimation.values = [0.875, 1, 0.875]
        strokeEndAnimation.duration = pacmanDuration

        // Animation
        let animation = CAAnimationGroup()

        animation.animations = [strokeStartAnimation, strokeEndAnimation]
        animation.duration = pacmanDuration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false

        // Draw pacman
        let pacman = pacmanLayer(size: CGSize(width: pacmanSize, height: pacmanSize), color: color)
        let frame = CGRect(
            x: (layer.bounds.size.width - size.width) / 2,
            y: (layer.bounds.size.height - pacmanSize) / 2,
            width: pacmanSize,
            height: pacmanSize
        )

        pacman.frame = frame
        pacman.add(animation, forKey: "animation")
        layer.addSublayer(pacman)
    }

    func circleInLayer(_ layer: CALayer, size: CGSize, color: UIColor) {
        let circleSize = size.width / 5
        let circleDuration: CFTimeInterval = 1

        // Translate animation
        let translateAnimation = CABasicAnimation(keyPath: "transform.translation.x")

        translateAnimation.fromValue = 0
        translateAnimation.toValue = -size.width / 2
        translateAnimation.duration = circleDuration

        // Opacity animation
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")

        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0.7
        opacityAnimation.duration = circleDuration

        // Animation
        let animation = CAAnimationGroup()

        animation.animations = [translateAnimation, opacityAnimation]
        #if swift(>=4.2)
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        #else
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        #endif
        animation.duration = circleDuration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false

        // Draw circles


        let circle = circleLayer(size: CGSize(width: circleSize, height: circleSize), color: color)
        let frame = CGRect(
            x: (layer.bounds.size.width - size.width) / 2 + size.width - circleSize,
            y: (layer.bounds.size.height - circleSize) / 2,
            width: circleSize,
            height: circleSize
        )

        circle.frame = frame
        circle.add(animation, forKey: "animation")
        layer.addSublayer(circle)
    }

    func circleLayer(size: CGSize, color: UIColor) -> CAShapeLayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)
        layer.fillColor = color.cgColor

        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        return layer
    }

    func pacmanLayer(size: CGSize, color: UIColor) -> CAShapeLayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 4,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: true)
        layer.fillColor = nil
        layer.strokeColor = color.cgColor
        layer.lineWidth = size.width / 2

        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        return layer
    }
}



class ProgressView: UIView {



    public var color: UIColor? = UIColor.white
    /// Current status of animation, read-only.
    private(set) public var isAnimating: Bool = false

    public init(frame: CGRect, color: UIColor? = nil) {
        super.init(frame: frame)
        self.color = color
        isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var bounds: CGRect {
          didSet {
              // setup the animation again for the new bounds
              if oldValue != bounds && isAnimating {
                  setUpAnimation()
              }
          }
      }

    /**
    Start animating.
    */
    public final func startAnimating() {
      guard !isAnimating else {
          return
      }
      isHidden = false
      isAnimating = true
      layer.speed = 1
      setUpAnimation()
    }

    /**
    Stop animating.
    */
    public final func stopAnimating() {
      guard isAnimating else {
          return
      }
      isHidden = true
      isAnimating = false
      layer.sublayers?.removeAll()
    }

    private final func setUpAnimation() {
        let animation = NVActivityIndicatorAnimationPacman()
        let padding: CGFloat = 5.0
        #if swift(>=4.2)
        var animationRect = frame.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        #else
        var animationRect = UIEdgeInsetsInsetRect(frame, UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        #endif
        let minEdge = min(animationRect.width, animationRect.height)

        layer.sublayers = nil
        layer.cornerRadius = 10
        layer.backgroundColor = UIColor(white: 0, alpha: 0.5).cgColor
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        animation.setUpAnimation(in: layer, size: animationRect.size, color: UIColor.white)
    }
}


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
        self.speed = 1
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
        self.isHidden = true
    }
}
