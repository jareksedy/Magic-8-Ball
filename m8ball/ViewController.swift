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
    let predictionView = UIView()
    
    // MARK: - Debug info.
    
    let debugInfoLabel = UILabel()
    
    // MARK: - Colors.
    
    let viewBgColor = UIColor(red: 0.40, green: 0.13, blue: 0.80, alpha: 1.00)
    let ballColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
    let ballNumberColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
    let ballNumberCircleColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
    let predictionViewColor = UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.00)
    
    // MARK: - Sizes.
    
    let ballSize: CGFloat = 500.0
    let ballNumberCircleSize: CGFloat = 275.0
    let predictionViewSize: CGFloat = 275.0
    
    // MARK: - Angles, boudaries & perspective control.
    
    let ballTopBottomBoundary: CGFloat = 90.0
    let shiftIndex: Int = 3
    
    // MARK: - Animation data & options.
    
    let animationDuration: TimeInterval = 2.0
    let initialDelay: TimeInterval = 0.5
    let springDamping: CGFloat = 0.30
    let springVelocity: CGFloat = 0.10
    
    let circularAnimationSteps: Int = 64
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
        predictionView.backgroundColor = predictionViewColor
        
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
        predictionView.frame = CGRect(x: 0, y: 0, width: predictionViewSize, height: predictionViewSize)
        
        ball.center = CGPoint(x: bgView.bounds.midX, y: bgView.bounds.midY/*maxY - ballSize / 2 - 50*/)
        ballNumberCircle.center = CGPoint(x: ball.bounds.midX, y: ball.bounds.midY)
        predictionView.center = CGPoint(x: ball.bounds.midX, y: ball.bounds.midY)
        
        ball.layer.cornerRadius = ballSize / 2
        //ball.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        ballNumberCircle.layer.cornerRadius = ballNumberCircleSize / 2
        predictionView.layer.cornerRadius = predictionViewSize / 2
        
        ball.layer.masksToBounds = true
        
        ballNumber.image = UIImage(named: "8")!
            .scalePreservingAspectRatio(targetSize: CGSize(width: ballNumberCircleSize, height: ballNumberCircleSize - ballSize / 7))
            .withRenderingMode(.alwaysTemplate)
        
        ballNumber.tintColor = ballNumberColor
        ballNumber.sizeToFit()
        
        ballNumber.center = CGPoint(x: ballNumberCircle.bounds.midX, y: ballNumberCircle.bounds.midY)
        
        ballNumberCircle.layer.transform = getTransform(CGPoint(x: ballNumberCircle.bounds.midX, y: ballNumberCircle.bounds.midY))
        predictionView.layer.transform = getTransform(CGPoint(x: ballNumberCircle.bounds.midX, y: ballNumberCircle.bounds.midY))
        
        bgView.addSubview(ball)
        ball.addSubview(ballNumberCircle)
        ball.addSubview(predictionView)
        ballNumberCircle.addSubview(ballNumber)
        
        buildCircleAnimationPoints()
        //drawAnimationPath(circularAnimationPoints)
        
        moveTo(view: ballNumberCircle, point: circularAnimationPoints[circularAnimationPoints.getBottom(shiftIndex)])
        moveTo(view: predictionView, point: circularAnimationPoints[circularAnimationPoints.getBottom(shiftIndex)])
        
    }
    
    // MARK: - 3d functions.
    
    func getTransform(_ point: CGPoint) -> CATransform3D {
        
        var transform: CATransform3D = CATransform3DIdentity
        var rotationAngleX: CGFloat = 0.0
        var rotationAngleY: CGFloat = 0.0
        
        let divider = ballNumberCircleSize / 75
        let multiplier = 195 / ballSize
        let pF = ballNumberCircleSize / 11
        
        rotationAngleX = (point.y - ballNumberCircleSize + pF) / divider * -1
        rotationAngleY = (point.x - ballNumberCircleSize + pF) / divider
        
        transform.m34 = -1 / (pF + ballNumberCircleSize)
        
        let sF = multiplier * (point.y - ballSize * 2) / 360
        transform = CATransform3DScale(transform, sF, sF, sF)
        
        transform = CATransform3DRotate(transform, rotationAngleX * .pi / 180, 1, 0, 0)
        transform = CATransform3DRotate(transform, rotationAngleY * .pi / 180, 0, 1, 0)
        //transform = CATransform3DRotate(transform, -rotationAngleY * .pi / 45, 0, 0, 1)
        
        // DEBUG INFO
        
//        debugInfoLabel.text = "A(X): \(rotationAngleX.roundTo(places: 2))° A(Y): \(rotationAngleY.roundTo(places: 2))° C.X: \(ballNumberCircle.center.x.roundTo(places: 2)) C.Y: \(ballNumberCircle.center.y.roundTo(places: 2))"
//        debugInfoLabel.center.x = bgView.bounds.midX
//        debugInfoLabel.sizeToFit()
        
        // END DEBUG INFO
        
        return transform
    }
    
    // MARK: - Ball move functions.
    
    func moveTo(view: UIView, point: CGPoint) {
        view.center = point
        view.layer.transform = getTransform(CGPoint(x: view.center.x, y: view.center.y))
    }
    
    // MARK: - Animation points functions.
    
    func buildCircleAnimationPoints() {        
        circularAnimationPoints = getCircularAnimationPoints(centerPoint: CGPoint(x: ball.bounds.midX, y: ball.bounds.midY),
                                                             radius: ballSize / 2.0,
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
    
    func shiftAnimate(view: UIView, to distance: Int, duration: TimeInterval? = nil, completionHandler: ((Bool) -> ())? = nil, withSpringEffect: Bool? = false) {
        
        func calculateShiftIndex(index: inout Int, signum: Int, upperBound: Int) {
            if signum > 0 {
                index = index < upperBound - 1 ? index + signum : 0
            } else {
                index = index > 0 ? index + signum : upperBound - 1
            }
        }
        
        var addDistance: Int = 0
        let springIntervals = [15, -25, 10]
        
        if withSpringEffect != nil && withSpringEffect == true {
            addDistance = springIntervals.map{abs($0)}.reduce(0,+)
        }
        
        var relStartTime: TimeInterval = 0.0
        let relDuration: TimeInterval = abs(1 / Double(distance + addDistance))
        
        let currentIndex = circularAnimationPoints.getCurrent(point: CGPoint(x: view.center.x, y: view.center.y)) ?? 0
        let shiftNegative = distance < 0
        
        moveTo(view: ballNumberCircle, point: circularAnimationPoints[currentIndex])
        
        UIView.animateKeyframes(withDuration: duration ?? Double(distance + addDistance) * 0.020, delay: 0, options: [.allowUserInteraction],
                                animations: {
                                    var index = currentIndex
                                    let toIndex = shiftNegative ? currentIndex - distance - 1 : currentIndex + distance - 1
                                    
                                    for _ in currentIndex...toIndex {
                                        
                                        if shiftNegative {
                                            index = index > 0 ? index - 1 : self.circularAnimationPoints.count - 1
                                        } else {
                                            index = index < self.circularAnimationPoints.count - 1 ? index + 1 : 0
                                        }
                                        
                                        UIView.addKeyframe(withRelativeStartTime: relStartTime, relativeDuration: relDuration, animations: {
                                            self.moveTo(view: view, point: self.circularAnimationPoints[index])
                                        })
                                        
                                        relStartTime += relDuration
                                    }
                                    
                                    if withSpringEffect != nil && withSpringEffect == true {
                                        
                                        springIntervals.forEach { interval in
                                            
                                            index = self.circularAnimationPoints.getCurrent(point: CGPoint(x: view.center.x, y: view.center.y)) ?? 0
                                            
                                            for _ in 0...abs(interval) - 1 {
                                                
                                                if shiftNegative {
                                                    calculateShiftIndex(index: &index,
                                                                        signum: interval.signum(),
                                                                        upperBound: self.circularAnimationPoints.count)
                                                } else {
                                                    calculateShiftIndex(index: &index,
                                                                        signum: interval.signum(),
                                                                        upperBound: self.circularAnimationPoints.count)
                                                }
                                                
                                                UIView.addKeyframe(withRelativeStartTime: relStartTime, relativeDuration: relDuration, animations: {
                                                    self.moveTo(view: view, point: self.circularAnimationPoints[index])
                                                })
                                                
                                                relStartTime += relDuration
                                            }
                                        }
                                    }
                                },
                                completion: completionHandler)
    }
    
    func animateToTop() {
        moveTo(view: ballNumberCircle, point: circularAnimationPoints[circularAnimationPoints.getBottom(shiftIndex)])
        moveTo(view: predictionView, point: circularAnimationPoints[circularAnimationPoints.getTop(shiftIndex)])
        
        let deltaIndex = circularAnimationPoints.getBottom(shiftIndex) - circularAnimationPoints.getTop(shiftIndex)
        
        shiftAnimate(view: ballNumberCircle, to: -deltaIndex)
        shiftAnimate(view: predictionView, to: -deltaIndex)
    }
    
    func animateToBottom() {
        moveTo(view: ballNumberCircle, point: circularAnimationPoints[circularAnimationPoints.getTop(shiftIndex)])
        moveTo(view: predictionView, point: circularAnimationPoints[circularAnimationPoints.getBottom(shiftIndex)])
        
        let deltaIndex = circularAnimationPoints.getBottom(shiftIndex) - circularAnimationPoints.getTop(shiftIndex)
        
        shiftAnimate(view: ballNumberCircle, to: -deltaIndex)
        shiftAnimate(view: predictionView, to: -deltaIndex)
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
        ballNumberCircle.center == circularAnimationPoints[circularAnimationPoints.getTop(shiftIndex)] ? animateToBottom() : animateToTop()
        //moveTo(view: ballNumberCircle, point: CGPoint(x: ball.bounds.midX, y: ball.bounds.midY))
       //moveTo(view: ballNumberCircle, point: circularAnimationPoints[circularAnimationPoints.getTop(shiftIndex)])
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: view)
        
        recognizer.setTranslation(.zero, in: view)
        
        let pointX = ballNumberCircle.center.x + translation.x
        let pointY = ballNumberCircle.center.y + translation.y
        
        moveTo(view: ballNumberCircle, point: CGPoint(x: pointX, y: pointY))
        
        switch recognizer.state {
        
        case .ended:
            return
        //animateToOrigin()
        
        default:
            return
            
        }
    }
}
