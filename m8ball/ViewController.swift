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
    
    let ball = UIButton()
    let ballNumberCircle = UIButton()
    let ballNumber = UIImageView()
    let predictionView = UIButton()
    let predictionTriangle = UIImageView()
    
    // MARK: - Predictions.
    
    struct Prediction {
        let id: Int
        let imageName: String
    }
    
    let predictions: [Prediction] = [Prediction(id: 0, imageName: "p_09"),
                                     Prediction(id: 0, imageName: "p_07"),
                                     Prediction(id: 0, imageName: "p_08"),
                                     Prediction(id: 0, imageName: "p_14"),
                                     Prediction(id: 0, imageName: "p_03"),
                                     Prediction(id: 0, imageName: "p_16"),
                                     Prediction(id: 0, imageName: "p_17"),
                                     Prediction(id: 0, imageName: "p_06"),
                                     Prediction(id: 0, imageName: "p_19"),
    ]
    
    // MARK: - Colors.
    
    let viewBgColor = UIColor(red: 0.00, green: 0.18, blue: 0.65, alpha: 1.00)
    let ballColor = UIColor(red: 0.00, green: 0.18, blue: 0.65, alpha: 1.00)
    let ballNumberColor = UIColor(red: 0.00, green: 0.18, blue: 0.65, alpha: 1.00)
    let ballNumberCircleColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
    let predictionViewColor = UIColor(red: 0.00, green: 0.18, blue: 0.65, alpha: 1.00)
    let predictionTriangleColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
    
    // MARK: - Sizes.
    
    var ballSize: CGFloat = 500.0
    var ballNumberCircleSize: CGFloat = 275.0
    var predictionViewSize: CGFloat = 275.0
    
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
        ball.addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        ball.addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
        ballNumberCircle.addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        ballNumberCircle.addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
        //createTapGestureRecognizer(targetView: ball)
        animateToTop()
    }
    
    @objc func animateDown() {
        
        UIView.animate(withDuration: 0.70,
                       delay: 0,
                       usingSpringWithDamping: 0.70,
                       initialSpringVelocity: 0.10,
                       options: [.allowUserInteraction],
                       animations: {
                        self.ball.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                       },
                       completion: nil)
    }
    
    @objc func animateUp() {
        
        if ballNumberCircle.center == circularAnimationPoints[circularAnimationPoints.getTop(shiftIndex)] {
            
            predictionTriangle.image = UIImage(named: predictions[Int.random(in: 0...predictions.count - 1)].imageName)!
                .scalePreservingAspectRatio(targetSize: CGSize(width: predictionViewSize / 1.10, height: predictionViewSize / 1.10))
                .withRenderingMode(.alwaysTemplate)
            
            animateToBottom()
        } else {
            animateToTop()
        }
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 0.15,
                       options: [.allowUserInteraction],
                       animations: {
                        self.ball.transform = CGAffineTransform(scaleX: 3, y: 3)
                        self.ball.transform = .identity
                       },
                       completion: nil)
    }
    
    func initialViewSetup() {
        
        bgView.backgroundColor = viewBgColor
        ball.backgroundColor = ballColor
        ballNumberCircle.backgroundColor = ballNumberCircleColor
        predictionView.backgroundColor = predictionViewColor
        
        ballSize = bgView.bounds.width - 20
        ballNumberCircleSize = (bgView.bounds.width - 20) * 0.55
        predictionViewSize = (bgView.bounds.width - 20) * 0.55
        
        ball.frame = CGRect(x: 0, y: 0, width: ballSize, height: ballSize)
        ballNumberCircle.frame = CGRect(x: 0, y: 0, width: ballNumberCircleSize, height: ballNumberCircleSize)
        predictionView.frame = CGRect(x: 0, y: 0, width: predictionViewSize, height: predictionViewSize)
        
        ball.center = CGPoint(x: bgView.bounds.midX, y: bgView.bounds.maxY - ballSize / 2 - 20)
        ballNumberCircle.center = CGPoint(x: ball.bounds.midX, y: ball.bounds.midY)
        predictionView.center = CGPoint(x: ball.bounds.midX, y: ball.bounds.midY)
        
        ball.layer.cornerRadius = ballSize / 2
        //ball.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        ball.layer.borderWidth = 1.0
        ball.layer.borderColor = UIColor.white.cgColor
        ballNumberCircle.layer.cornerRadius = ballNumberCircleSize / 2
        predictionView.layer.cornerRadius = predictionViewSize / 2
        
        ball.layer.masksToBounds = true
        
        ballNumber.image = UIImage(named: "8")!
            .scalePreservingAspectRatio(targetSize: CGSize(width: ballNumberCircleSize, height: ballNumberCircleSize - ballSize / 7))
            .withRenderingMode(.alwaysTemplate)
        
        ballNumber.tintColor = ballNumberColor
        ballNumber.sizeToFit()
        
        ballNumber.center = CGPoint(x: ballNumberCircle.bounds.midX, y: ballNumberCircle.bounds.midY)
        ballNumber.transform = CGAffineTransform(rotationAngle: 145 * .pi / 180)
        
        predictionTriangle.image = UIImage(named: "p_09")!
            .scalePreservingAspectRatio(targetSize: CGSize(width: predictionViewSize / 1.0, height: predictionViewSize / 1.0))
            .withRenderingMode(.alwaysTemplate)
        
        predictionTriangle.tintColor = predictionTriangleColor
        predictionTriangle.sizeToFit()
        
        predictionTriangle.center = CGPoint(x: predictionView.bounds.midX, y: predictionView.bounds.midY)
        predictionTriangle.transform = CGAffineTransform(rotationAngle: 180 * .pi / 180)
        
        ballNumberCircle.layer.transform = getTransform(CGPoint(x: ballNumberCircle.bounds.midX, y: ballNumberCircle.bounds.midY))
        predictionView.layer.transform = getTransform(CGPoint(x: ballNumberCircle.bounds.midX, y: ballNumberCircle.bounds.midY))
        
        bgView.addSubview(ball)
        ball.addSubview(ballNumberCircle)
        ball.addSubview(predictionView)
        ballNumberCircle.addSubview(ballNumber)
        predictionView.addSubview(predictionTriangle)
        
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
        let multiplier = 200 / ballSize
        let pF = ballNumberCircleSize / 11
        let sF = multiplier * (point.y - ballSize * 2) / 360
        
        rotationAngleX = (point.y - ballNumberCircleSize + pF) / divider * -1
        rotationAngleY = (point.x - ballNumberCircleSize + pF) / divider
        
        transform.m34 = -1 / (pF + ballNumberCircleSize) * 1.15
        
        transform = CATransform3DScale(transform, sF, sF, sF)
        
        transform = CATransform3DRotate(transform, rotationAngleX * .pi / 180, 1, 0, 0)
        transform = CATransform3DRotate(transform, rotationAngleY * .pi / 180, 0, 1, 0)
        transform = CATransform3DRotate(transform, -(rotationAngleY - 22) * .pi / 140, 0, 0, 1)
        
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
    
    func shiftAnimate(view: UIView, to distance: Int, duration: TimeInterval? = nil, completionHandler: ((Bool) -> ())? = nil) {
        
        var relStartTime: TimeInterval = 0.0
        let relDuration: TimeInterval = abs(1 / Double(distance))
        
        let currentIndex = circularAnimationPoints.getCurrent(point: CGPoint(x: view.center.x, y: view.center.y)) ?? 0
        let shiftNegative = distance < 0
        
        moveTo(view: ballNumberCircle, point: circularAnimationPoints[currentIndex])
        
        UIView.animateKeyframes(withDuration: duration ?? Double(distance) * 0.020, delay: 0, options: [.allowUserInteraction],
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
    
    func createTapGestureRecognizer(targetView: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        targetView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Handle gestures.
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        
        if ballNumberCircle.center == circularAnimationPoints[circularAnimationPoints.getTop(shiftIndex)] {
            animateToBottom()
        } else {
            animateToTop()
        }
        
        UIView.animate(withDuration: 1.25,
                       delay: 0,
                       usingSpringWithDamping: 0.77,
                       initialSpringVelocity: 0.10,
                       options: [.allowUserInteraction],
                       animations: {
                        self.ball.transform = CGAffineTransform(scaleX: 3, y: 3)
                        self.ball.transform = .identity
                       },
                       completion: nil)
        
        //moveTo(view: ballNumberCircle, point: CGPoint(x: ball.bounds.midX, y: ball.bounds.midY))
        //moveTo(view: ballNumberCircle, point: circularAnimationPoints[circularAnimationPoints.getTop(shiftIndex)])
    }
}
