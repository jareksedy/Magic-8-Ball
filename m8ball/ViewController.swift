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
    
    let ballTopBottomBoundary: CGFloat = 90.0
    let pValue: CGFloat = 400.0
//    let rotationAngle: Double = -45.0
//    var panRotationAngleX: Double = 0.0
//    var panRotationAngleY: Double = 0.0
    
    // MARK: - Animation options.
    
    let animationDuration: TimeInterval = 1.75
    let initialDelay: TimeInterval = 0.5
    let springDamping: CGFloat = 0.30
    let springVelocity: CGFloat = 0.10
    
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
        createTapGestureRecognizer(targetView: ball)
        animateToOrigin(initialDelay)
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
        ballNumberCircle.center = CGPoint(x: ball.bounds.midX + 200 * CGFloat(Bool.random() ? 1.0 : -1.0),
                                          y: ball.bounds.minY - 100)
        
        ball.layer.cornerRadius = ballSize / 2
        ballNumberCircle.layer.cornerRadius = ballNumberCircleSize / 2

        ball.layer.masksToBounds = true
        
        ballNumber.image = UIImage(named: "8")
        ballNumber.sizeToFit()
        
        ballNumber.center = CGPoint(x: ballNumberCircle.bounds.midX, y: ballNumberCircle.bounds.midY)

        ballNumberCircle.layer.transform = getTransform(ballNumberCircle)
        
        bgView.addSubview(ball)
        ball.addSubview(ballNumberCircle)
        ballNumberCircle.addSubview(ballNumber)

    }
    
    // MARK: - 3d operations.
    
    func getTransform(_ ball: UIView) -> CATransform3D {
        
        var transform: CATransform3D = CATransform3DIdentity
        var panRotationAngleX = 0.0
        var panRotationAngleY = 0.0
        
        panRotationAngleX -= Double((ball.center.y - ball.bounds.width + 25) / 3.5)
        panRotationAngleY += Double((ball.center.x - ball.bounds.height + 25) / 3.5)
        
        transform = CATransform3DIdentity
        transform.m34 = -1 / pValue
        
        transform = CATransform3DRotate(transform, CGFloat(panRotationAngleX * .pi / 180), 1, 0, 0)
        transform = CATransform3DRotate(transform, CGFloat(panRotationAngleY * .pi / 180), 0, 1, 0)
        
        return transform
    }
    
    // MARK: - Animations.
    
    func moveToTop() {
        ballNumberCircle.center.y = ball.bounds.minY + ballTopBottomBoundary
        ballNumberCircle.center.x = ball.bounds.midX
        ballNumberCircle.layer.transform = getTransform(ballNumberCircle)
    }
    
    func moveTo(point: CGPoint) {
        ballNumberCircle.center = point
        ballNumberCircle.layer.transform = getTransform(ballNumberCircle)
    }
    
    func animateToOrigin(_ delay: TimeInterval = 0.0) {
        UIView.animate(withDuration: animationDuration,
                       delay: delay,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: springVelocity,
                       options: [.allowUserInteraction, .curveEaseInOut],
                       animations: {
                        self.ballNumberCircle.center.x = self.ball.bounds.midX
                        self.ballNumberCircle.center.y = self.ball.bounds.minY + self.ballTopBottomBoundary
                        self.ballNumberCircle.layer.transform = self.getTransform(self.ballNumberCircle)
                       },
                       completion: nil)
    }
    
    // MARK: - Gestures.
    
    func createPanGestureRecognizer(targetView: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        targetView.addGestureRecognizer(panGesture)
    }
    
    func createTapGestureRecognizer(targetView: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        targetView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: animationDuration / 2,
                       delay: 0,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: springVelocity,
                       options: [.curveEaseInOut],
                       animations: {
                        self.moveTo(point: CGPoint(x: CGFloat.random(in: 100...300), y: CGFloat.random(in: 100...300)))
                       },
                       completion: {_ in
                        self.animateToOrigin()
                       })
    }

    @objc func handlePan(recognizer: UIPanGestureRecognizer) {

        let translation = recognizer.translation(in: view)
        
        recognizer.setTranslation(.zero, in: view)
        
        ballNumberCircle.center.x += translation.x
        ballNumberCircle.center.y += translation.y
        
        ballNumberCircle.layer.transform = getTransform(ballNumberCircle)
        
        // DEBUG INFO
        
//        debugInfoLabel.text = "A(X): \(panRotationAngleX.roundTo(places: 2))° A(Y): \(panRotationAngleY.roundTo(places: 2))° C.X: \(Double(ballNumberCircle.center.x).roundTo(places: 2)) C.Y: \(Double(ballNumberCircle.center.y).roundTo(places: 2))"
//        debugInfoLabel.center.x = bgView.bounds.midX
//        debugInfoLabel.sizeToFit()
        
        // END DEBUG INFO
        
        switch recognizer.state {
        
        case .ended:
            animateToOrigin()
            
        default:
            return
            
        }
    }
}
