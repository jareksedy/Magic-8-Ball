//
//  Extensions.swift
//  m8ball
//
//  Created by Ярослав on 27.06.2021.
//

import UIKit

func getCircleAnimationPoints(centerPoint: CGPoint, radius: CGFloat, steps: Int)->[CGPoint] {
    let result: [CGPoint] = stride(from: 270.0, to: 630.0, by: Double(360 / steps)).map {
        let bearing = CGFloat($0) * .pi / 180
        let x = centerPoint.x + radius * cos(bearing)
        let y = centerPoint.y + radius * sin(bearing)
        return CGPoint(x: x, y: y)
    }
    return result
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }
}
