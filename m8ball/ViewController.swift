//
//  ViewController.swift
//  m8ball
//
//  Created by Ярослав on 22.06.2021.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Views.
    
    let ball = UIView()
    let ballNumberCircle = UIView()
    let ballNumber = UIImageView()
    
    // MARK: - Colors.
    
    let viewBgColor = UIColor.systemPink
    let ballColor = UIColor.black
    let ballNumberCircleColor = UIColor.white
    let ballNumberColor = UIColor.black
    
    // MARK: - Sizes.
    
    let ballSize: CGFloat = 500.0
    let ballNumberCircleSize: CGFloat = 275.0
    
    // MARK: - Angles, boundaries & stuff.
    
    let ballTopBottomBoundary: CGFloat = 90.0
    let rotationAngle: Double = 0.0
    let pValue: CGFloat = 400.0
    
    // MARK: - Animation timing.
    
    let animationDuration: TimeInterval = 1.5
    
    // MARK: - Outlets.
            
    @IBOutlet weak var bgView: UIView!
    
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
    }
    
    func initialViewSetup() {
        
        bgView.backgroundColor = viewBgColor
        ball.backgroundColor = ballColor
        ballNumberCircle.backgroundColor = ballNumberCircleColor
        
        ball.frame = CGRect(x: 0, y: 0, width: ballSize, height: ballSize)
        ballNumberCircle.frame = CGRect(x: 0, y: 0, width: ballNumberCircleSize, height: ballNumberCircleSize)
        
        ball.center = CGPoint(x: bgView.bounds.midX, y: bgView.bounds.midY)
        ballNumberCircle.center = CGPoint(x: ball.bounds.midX, y: ball.bounds.midY)
        
        ball.layer.cornerRadius = ballSize / 2
        ballNumberCircle.layer.cornerRadius = ballNumberCircleSize / 2

        ball.layer.masksToBounds = true
        
        //ballNumber.backgroundColor = UIColor.systemBlue
        
        ballNumber.image = UIImage(named: "8")
        ballNumber.sizeToFit()
        
        ballNumber.center = CGPoint(x: ballNumberCircle.bounds.midX, y: ballNumberCircle.bounds.midY)
        
        transform.m34 = -1 / pValue
        
//      transform = CATransform3DRotate(transform, CGFloat(-rotationAngle * .pi / 180), 1, 0, 0)
//      ballNumberCircle.center.y = ball.bounds.maxY - ballTopBottomBoundary
        
        transform = CATransform3DRotate(transform, CGFloat(rotationAngle * .pi / 180), 1, 0, 0)
        //ballNumberCircle.center.y = ball.bounds.minY + ballTopBottomBoundary
        
        ballNumberCircle.layer.transform = transform
        
        bgView.addSubview(ball)
        ball.addSubview(ballNumberCircle)
        ballNumberCircle.addSubview(ballNumber)
        
//        UIView.animate(withDuration: animationDuration) {
//            self.ballNumberCircle.center.y = self.ball.bounds.maxY - self.ballTopBottomBoundary
//            self.transform = CATransform3DRotate(self.transform, CGFloat(-self.rotationAngle * 2 * .pi / 180), 1, 0, 0)
//            self.ballNumberCircle.layer.transform = self.transform
//        }
    }
    
    func initialAnimations() {
    }
    
    func createPanGestureRecognizer(targetView: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        targetView.addGestureRecognizer(panGesture)
    }

    @objc func handlePan(recognizer: UIPanGestureRecognizer) {

        let translation = recognizer.translation(in: view)
        var panRotationAngle: Double = 0.0
        
        recognizer.setTranslation(.zero, in: view)
        
        ballNumberCircle.center.y += translation.y
        panRotationAngle -= Double((ballNumberCircle.center.y - ballNumberCircleSize + 30) / 3.5)
        
        transform = CATransform3DIdentity
        transform.m34 = -1 / pValue
        
        //let panRotationAngle = rotationAngle - Double(ballNumberCircle.center.y - ballNumberCircleSize)
        //print(ballNumberCircle.center.y)
        //Double(ballNumberCircle.center.y - ballNumberCircleSize)
        //panRotationAngle /= 2
        
        transform = CATransform3DRotate(transform, CGFloat(panRotationAngle * .pi / 180), 1, 0, 0)
        ballNumberCircle.layer.transform = transform
        
        switch recognizer.state {
        
        case .ended:
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.75,
                           initialSpringVelocity: 0.5,
                           options: [],
                           animations: {
                            self.transform = CATransform3DIdentity
                            self.transform.m34 = -1 / self.pValue
                            self.transform = CATransform3DRotate(self.transform, CGFloat(self.rotationAngle * .pi / 180), 1, 0, 0)
                            self.ballNumberCircle.layer.transform = self.transform
                            self.ballNumberCircle.center.y = self.ball.bounds.midY //+ ballTopBottomBoundary
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
