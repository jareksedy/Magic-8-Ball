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
    let pValue: CGFloat = 300.0
    
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
        //drawAnimationPath(circularAnimationPoints)
        
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
        
//        let scaleFactor: CGFloat = 0.40 * (point.y - ballSize * 2) / 360
//        transform = CATransform3DScale(transform, scaleFactor, scaleFactor, scaleFactor)
        
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
                                                             radius: ballSize / 2.80,
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
    
    func shiftAnimate(to distance: Int, duration: TimeInterval? = nil, completionHandler: ((Bool) -> ())? = nil, withSpringEffect: Bool? = false) {
        
        func calculateShiftIndex(index: inout Int, signum: Int, upperBound: Int) {
            if signum > 0 {
                index = index < upperBound - 1 ? index + signum : 0
            } else {
                index = index > 0 ? index + signum : upperBound - 1
            }
        }
        
        var addDistance: Int = 0
        let springIntervals = [5, -15, 10]
        
        if withSpringEffect != nil && withSpringEffect == true {
            addDistance = springIntervals.map{abs($0)}.reduce(0,+)
        }
        
        var relStartTime: TimeInterval = 0.0
        let relDuration: TimeInterval = abs(1 / Double(distance + addDistance))
        
        let currentIndex = circularAnimationPoints.getCurrent(point: CGPoint(x: ballNumberCircle.center.x, y: ballNumberCircle.center.y)) ?? 0
        let shiftNegative = distance < 0
        
        moveTo(circularAnimationPoints[currentIndex])
        
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
                                            self.moveTo(self.circularAnimationPoints[index])
                                        })
                                        
                                        relStartTime += relDuration
                                    }
                                    
                                    if withSpringEffect != nil && withSpringEffect == true {

                                        springIntervals.forEach { interval in

                                            index = self.circularAnimationPoints.getCurrent(point: CGPoint(x: self.ballNumberCircle.center.x, y: self.ballNumberCircle.center.y)) ?? 0

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
                                                    self.moveTo(self.circularAnimationPoints[index])
                                                })

                                                relStartTime += relDuration
                                            }
                                        }
                                    }
                                },
                                completion: completionHandler)
    }
    
    func animateToTop() {
        moveTo(circularAnimationPoints[circularAnimationPoints.getBottom()])
        let deltaIndex = circularAnimationPoints.getBottom() - circularAnimationPoints.getTop()
        shiftAnimate(to: -deltaIndex)
    }
    
    func animateToBottom() {
        moveTo(circularAnimationPoints[circularAnimationPoints.getTop()])
        let deltaIndex = circularAnimationPoints.getBottom() - circularAnimationPoints.getTop()
        shiftAnimate(to: -deltaIndex)
    }
    
    func animateFullCircle() {
        shiftAnimate(to: circularAnimationSteps)
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
        //animateFullCircle()
        //ballNumberCircle.center == circularAnimationPoints[circularAnimationPoints.getTop()] ? animateToBottom() : animateToTop()
        shiftAnimate(to: -circularAnimationPoints.count, duration: 2.0, withSpringEffect: false)
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
