//
//  ViewController.swift
//  m8ball
//
//  Created by Ярослав on 22.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets.
            
    @IBOutlet weak var bgView: UIView!
    
    // MARK: - Views.
    
    let ball = UIView()
    let ballNumberCircle = UIView()
    let ballNumber = UIImageView()

    // MARK: - Debug info.
    
    let debugInfoLabel = UILabel()
    
    // MARK: - Colors.
    
    let viewBgColor = UIColor.systemPink
    let ballColor = UIColor.black
    let ballNumberCircleColor = UIColor.white
    let ballNumberColor = UIColor.black
    
    // MARK: - Sizes.
    
    let ballSize: CGFloat = 500.0
    let ballNumberCircleSize: CGFloat = 275.0
    
    // MARK: - Angles, boudaries & perspective control.
    
    let ballTopBottomBoundary: CGFloat = 90.0
    let pValue: CGFloat = 400.0
    
    // MARK: - Animation data & options.
    
    let animationDuration: TimeInterval = 1.75
    let initialDelay: TimeInterval = 0.5
    let springDamping: CGFloat = 0.30
    let springVelocity: CGFloat = 0.10
    
    let circularAnimationSteps: Int = 90
    var circularAnimationPoints = [CGPoint]()
    var circularAnimationIndex = 0
    
    // MARK: - Transforms.
    
    var transform = CATransform3DIdentity
    
    // MARK: - Code.
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        initialViewSetup()
        createPanGestureRecognizer(targetView: bgView)
        createTapGestureRecognizer(targetView: ball)
        animateToTop()
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
        
        ball.center = CGPoint(x: bgView.bounds.midX, y: bgView.bounds.midY /*bgView.bounds.maxY - ballSize / 2 + 100*/)
        ballNumberCircle.center = CGPoint(x: ball.bounds.midX, y: ball.bounds.minY + ballTopBottomBoundary)
        
        ball.layer.cornerRadius = ballSize / 2
        ballNumberCircle.layer.cornerRadius = ballNumberCircleSize / 2

        ball.layer.masksToBounds = true
        
        ballNumber.image = UIImage(named: "8")
        ballNumber.sizeToFit()
        
        ballNumber.center = CGPoint(x: ballNumberCircle.bounds.midX, y: ballNumberCircle.bounds.midY)

        ballNumberCircle.layer.transform = getTransform(CGPoint(x: ballNumberCircle.bounds.midX, y: ballNumberCircle.bounds.midY))
        
        bgView.addSubview(ball)
        ball.addSubview(ballNumberCircle)
        ballNumberCircle.addSubview(ballNumber)
        
        buildCircleAnimationPoints()
        drawAnimationPath(circularAnimationPoints)
        
        moveTo(circularAnimationPoints[circularAnimationPoints.getBottom()])

    }
    
    // MARK: - 3d functions.
    
    func getTransform(_ point: CGPoint) -> CATransform3D {
        
        var transform: CATransform3D = CATransform3DIdentity
        var rotationAngleX: CGFloat = 0.0
        var rotationAngleY: CGFloat = 0.0
        
        rotationAngleX = (point.y - ballNumberCircleSize + 25) / 3.5 * -1
        rotationAngleY = (point.x - ballNumberCircleSize + 25) / 3.5
        
        transform = CATransform3DIdentity
        transform.m34 = -1 / pValue
        
        transform = CATransform3DRotate(transform, rotationAngleX * .pi / 180, 1, 0, 0)
        transform = CATransform3DRotate(transform, rotationAngleY * .pi / 180, 0, 1, 0)
        
        let scaleFactor: CGFloat = 1.0
        
        transform = CATransform3DScale(transform, scaleFactor, scaleFactor, scaleFactor)
        
        return transform
    }
    
    // MARK: - Ball move functions.
    
    func moveTo(_ point: CGPoint) {
        ballNumberCircle.center = point
        ballNumberCircle.layer.transform = getTransform(CGPoint(x: ballNumberCircle.center.x, y: ballNumberCircle.center.y))
    }
    
    // MARK: - Animation points functions.
    
    func buildCircleAnimationPoints() {        
        circularAnimationPoints = getCircularAnimationPoints(centerPoint: CGPoint(x: ball.bounds.midX, y: ball.bounds.midY),
                                                             radius: ballSize / 3.0,
                                                             steps: circularAnimationSteps)
    }
    
    func drawAnimationPath(_ pointArray: [CGPoint]) {
        let path = UIBezierPath()
        path.move(to: pointArray[0])
        pointArray.forEach { point in path.addLine(to: point) }
        path.close()
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        
        layer.strokeColor = UIColor.yellow.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 3.0
        
        ball.layer.addSublayer(layer)
    }
    
    // MARK: - Animation functions.
    
    func initialAnimations() {
        var relStartTime: TimeInterval = 0.0
        let relDuration: TimeInterval = 1 / Double(circularAnimationSteps)
        
        UIView.animateKeyframes(withDuration: 1.0,
                                delay: 0,
                                options: [],
                                animations: {

                                    for i in 0...self.circularAnimationSteps - 1 {

                                        UIView.addKeyframe(withRelativeStartTime: relStartTime,
                                                           relativeDuration: relDuration,
                                                           animations: {
                                                            self.moveTo(self.circularAnimationPoints[i])
                                                           })
                                        
                                        relStartTime += relDuration
                                    }

                                },
                                completion: nil)
    }
    
    func animateToTop() {
        var relStartTime: TimeInterval = 0.0
        let relDuration: TimeInterval = 1 / Double(circularAnimationSteps)
        
        moveTo(circularAnimationPoints[circularAnimationPoints.getBottom()])
        
        UIView.animateKeyframes(withDuration: 1.25, delay: 0, options: [],
                                animations: {
                                    var index = self.circularAnimationPoints.getBottom()
                                    for _ in self.circularAnimationPoints.getBottom()...self.circularAnimationPoints.getTop() - 1 {
                                        if index < self.circularAnimationPoints.count - 1 {
                                            index += 1
                                        } else {
                                            index = 0
                                        }
                                        UIView.addKeyframe(withRelativeStartTime: relStartTime, relativeDuration: relDuration, animations: {
                                            self.moveTo(self.circularAnimationPoints[index])
                                        })
                                        relStartTime += relDuration
                                    }
                                },
                                completion: nil)
    }
    
    func animateToBottom() {
        var relStartTime: TimeInterval = 0.0
        let relDuration: TimeInterval = 1 / Double(circularAnimationSteps)
        
        moveTo(circularAnimationPoints[circularAnimationPoints.getTop()])
        
        UIView.animateKeyframes(withDuration: 1.25, delay: 0, options: [],
                                animations: {
                                    var index = self.circularAnimationPoints.getTop()
                                    for _ in self.circularAnimationPoints.getBottom()...self.circularAnimationPoints.getTop() - 1 {
                                        if index < self.circularAnimationPoints.count - 1 {
                                            index += 1
                                        } else {
                                            index = 0
                                        }
                                        UIView.addKeyframe(withRelativeStartTime: relStartTime, relativeDuration: relDuration, animations: {
                                            self.moveTo(self.circularAnimationPoints[index])
                                        })
                                        relStartTime += relDuration
                                    }
                                },
                                completion: nil)
    }
    
    // MARK: - Create gestures.
    
    func createPanGestureRecognizer(targetView: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        targetView.addGestureRecognizer(panGesture)
    }
    
    func createTapGestureRecognizer(targetView: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        targetView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Handle gestures.
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        
        ballNumberCircle.center == circularAnimationPoints[circularAnimationPoints.getTop()] ? animateToBottom() : animateToTop()

    }

    @objc func handlePan(recognizer: UIPanGestureRecognizer) {

        let translation = recognizer.translation(in: view)
        
        recognizer.setTranslation(.zero, in: view)

            let pointX = ballNumberCircle.center.x + translation.x
            let pointY = ballNumberCircle.center.y + translation.y
        
            moveTo(CGPoint(x: pointX, y: pointY))
            

        // DEBUG INFO
        
//        debugInfoLabel.text = "A(X): \(panRotationAngleX.roundTo(places: 2))° A(Y): \(panRotationAngleY.roundTo(places: 2))° C.X: \(Double(ballNumberCircle.center.x).roundTo(places: 2)) C.Y: \(Double(ballNumberCircle.center.y).roundTo(places: 2))"
//        debugInfoLabel.center.x = bgView.bounds.midX
//        debugInfoLabel.sizeToFit()
        
        // END DEBUG INFO
        
        switch recognizer.state {
        
        case .ended:
            return
            //animateToOrigin()
            
        default:
            return
            
        }
    }
}
