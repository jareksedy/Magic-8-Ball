//
//  Extensions.swift
//  m8ball
//
//  Created by Ярослав on 27.06.2021.
//

import UIKit

func getCircularAnimationPoints(centerPoint: CGPoint, radius: CGFloat, steps: Int)->[CGPoint] {
    let result: [CGPoint] = stride(from: 0.0, to: 360.0, by: Double(360 / steps)).map {
        let radians = CGFloat($0) * .pi / 180
        let x = centerPoint.x + radius * cos(radians) * 0.85 // old = 0.5
        let y = centerPoint.y + radius * sin(radians)
        return CGPoint(x: x, y: y)
    }
    return result
}

extension Array where Element == CGPoint {
    func getTop (_ shift: Int = 0) -> Int {
        return self.map{$0.y}.firstIndex(of: self.min{ $0.y < $1.y }!.y)! + shift
    }
    
    func getBottom (_ shift: Int = 0) -> Int {
        return self.map{$0.y}.firstIndex(of: self.max{ $0.y < $1.y }!.y)! + shift
    }
    func getCurrent (point: CGPoint) -> Int? {
        return self.firstIndex(of: point)
    }
}

extension Array {
    func shifted(by shiftAmount: Int) -> Array<Element> {
        guard self.count > 0, (shiftAmount % self.count) != 0 else { return self }

        let moduloShiftAmount = shiftAmount % self.count
        let negativeShift = shiftAmount < 0
        let effectiveShiftAmount = negativeShift ? moduloShiftAmount + self.count : moduloShiftAmount

        let shift: (Int) -> Int = { return $0 + effectiveShiftAmount >= self.count ? $0 + effectiveShiftAmount - self.count : $0 + effectiveShiftAmount }

        return self.enumerated().sorted(by: { shift($0.offset) < shift($1.offset) }).map { $0.element }
    }
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

extension CGFloat {
    func roundTo(places: Int) -> CGFloat {
        let divisor = pow(10.0, Double(places))
        return CGFloat((Double(self) * divisor).rounded() / divisor)
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
