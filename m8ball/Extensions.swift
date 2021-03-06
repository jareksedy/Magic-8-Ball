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
        let x = centerPoint.x + radius * cos(radians) * 0.65 // default: 0.65
        let y = centerPoint.y + radius * sin(radians) + (radius / 3.0) // default: 3.25
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

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}
