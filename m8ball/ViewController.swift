//
//  ViewController.swift
//  m8ball
//
//  Created by Ярослав on 22.06.2021.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Debug info.
    
    let debugInfoLabel = UILabel()
    
    // MARK: - Views.
    
    let ball = UIView()
    let ballNumberCircle = UIView()
    let ballNumber = UIImageView()
    
    // MARK: - Outlets.
            
    @IBOutlet weak var bgView: UIView!
    
    // MARK: - Colors.
    
    let viewBgColor = UIColor.systemPink
    let ballColor = UIColor.black
    let ballNumberCircleColor = UIColor.white
    let ballNumberColor = UIColor.black
    
    // MARK: - Sizes.
    
    let ballSize: CGFloat = 500.0
    let ballNumberCircleSize: CGFloat = 275.0
    
    // MARK: - Angles, boundaries & stuff.
    
    let ballTopBottomBoundary: CGFloat = 85.0
    let rotationAngle: Double = -45.0
    let pValue: CGFloat = 400.0
    
    // MARK: - Animation options.
    
    let animationDuration: TimeInterval = 0.5
    let initialDelay: TimeInterval = 0.05
    let springDamping: CGFloat = 0.65
    let springVelocity: CGFloat = 0.25
    
    // MARK: - Transforms.
    
    var transform = CATransform3DIdentity
    
    // MARK: - Code.
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initialViewSetup()
        createPanGestureRecognizer(targetView: bgView)
        initialAnimations()
    }
    
    func initialViewSetup() {
        
        bgView.backgroundColor = viewBgColor
        ball.backgroundColor = ballColor
        ballNumberCircle.backgroundColor = ballNumberCircleColor
        
        // DEBUG INFO
        
//        debugInfoLabel.text = ""
//        debugInfoLabel.font = UIFont.monospacedSystemFont(ofSize: 10, weight: UIFont.Weight.regular)
//        debugInfoLabel.sizeToFit()
//        debugInfoLabel.textColor = UIColor.white
//        debugInfoLabel.textAlignment = .center
//        debugInfoLabel.center.x = bgView.bounds.midX
//        debugInfoLabel.center.y = bgView.bounds.minY + 50
//        bgView.addSubview(debugInfoLabel)
        
        // END DEBUG INFO
        
        ball.frame = CGRect(x: 0, y: 0, width: ballSize, height: ballSize)
        ballNumberCircle.frame = CGRect(x: 0, y: 0, width: ballNumberCircleSize, height: ballNumberCircleSize)
        
        ball.center = CGPoint(x: bgView.bounds.midX, y: bgView.bounds.midY)
        ballNumberCircle.center = CGPoint(x: ball.bounds.midX, y: ball.bounds.midY)
        
        ball.layer.cornerRadius = ballSize / 2
        ballNumberCircle.layer.cornerRadius = ballNumberCircleSize / 2

        ball.layer.masksToBounds = true
        
        ballNumber.image = UIImage(named: "8")
        ballNumber.sizeToFit()
        
        ballNumber.center = CGPoint(x: ballNumberCircle.bounds.midX, y: ballNumberCircle.bounds.midY)
        
        transform.m34 = -1 / pValue
        
        transform = CATransform3DRotate(transform, CGFloat(rotationAngle * .pi / 180), 1, 0, 0)
        ballNumberCircle.layer.transform = transform
        ballNumberCircle.center.y = ball.bounds.maxY - ballTopBottomBoundary
        
        bgView.addSubview(ball)
        ball.addSubview(ballNumberCircle)
        ballNumberCircle.addSubview(ballNumber)

    }
    
    func initialAnimations() {
        UIView.animate(withDuration: animationDuration,
                       delay: initialDelay,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: springVelocity,
                       options: [.allowUserInteraction],
                       animations: {
                        self.transform = CATransform3DIdentity
                        self.transform.m34 = -1 / self.pValue
                        self.transform = CATransform3DRotate(self.transform, CGFloat(45 * Double.pi / 180), 1, 0, 0)
                        self.ballNumberCircle.layer.transform = self.transform
                        self.ballNumberCircle.center.y = self.ball.bounds.minY + self.ballTopBottomBoundary
                       },
                       completion: nil)
    }
    
    func createPanGestureRecognizer(targetView: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        targetView.addGestureRecognizer(panGesture)
    }

    @objc func handlePan(recognizer: UIPanGestureRecognizer) {

        let translation = recognizer.translation(in: view)
        var panRotationAngleX: Double = 0.0
        var panRotationAngleY: Double = 0.0
        
        recognizer.setTranslation(.zero, in: view)
        
        ballNumberCircle.center.y += translation.y
        ballNumberCircle.center.x += translation.x
        
        panRotationAngleX -= Double((ballNumberCircle.center.y - ballNumberCircleSize + 25) / 3.5)
        panRotationAngleY += Double((ballNumberCircle.center.x - ballNumberCircleSize + 25) / 3.5)
        
        transform = CATransform3DIdentity
        transform.m34 = -1 / pValue
        
        transform = CATransform3DRotate(transform, CGFloat(panRotationAngleX * .pi / 180), 1, 0, 0)
        transform = CATransform3DRotate(transform, CGFloat(panRotationAngleY * .pi / 180), 0, 1, 0)
        
        ballNumberCircle.layer.transform = transform
        
        // DEBUG INFO
        
//        debugInfoLabel.text = "ANGLE: \(panRotationAngle.roundTo(places: 2))° C.Y: \(Double(ballNumberCircle.center.y).roundTo(places: 2))"
//        debugInfoLabel.center.x = bgView.bounds.midX
//        debugInfoLabel.sizeToFit()
        
        // END DEBUG INFO
        
        switch recognizer.state {
        
        case .ended:
            
            UIView.animate(withDuration: animationDuration,
                           delay: 0,
                           usingSpringWithDamping: springDamping,
                           initialSpringVelocity: springVelocity,
                           options: [.allowUserInteraction],
                           animations: {
                            self.transform = CATransform3DIdentity
                            self.transform.m34 = -1 / self.pValue
                            self.transform = CATransform3DRotate(self.transform, CGFloat(45 * Double.pi / 180), 1, 0, 0)
                            self.ballNumberCircle.layer.transform = self.transform
                            self.ballNumberCircle.center.y = self.ball.bounds.minY + self.ballTopBottomBoundary
                            self.ballNumberCircle.center.x = self.ball.bounds.midX
                           },
                           completion: nil)
            
        default: return
        }
    }
}


/*
let fontFamilyNames = UIFont.familyNames
for familyName in fontFamilyNames {
print("------------------------------")
print("Font Family Name = [\(familyName)]")
let names = UIFont.fontNames(forFamilyName: familyName)
print("Font Names = [\(names)]")
}
*/
