//
//  ViewController.swift
//  m8ball
//
//  Created by Ярослав on 22.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
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
    
    let ballSize: CGFloat = 500
    let ballNumberCircleSize: CGFloat = 275
    
    // MARK: - Animation timing.
    
    let animationDuration: TimeInterval = 2.5
    
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
        //initialAnimations()
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

        //UIView.animate(withDuration: 3) {
        //    self.ballNumberCircle.transform = CGAffineTransform(rotationAngle: .pi)
        //}
        
        ballNumber.center = CGPoint(x: ballNumberCircle.bounds.midX, y: ballNumberCircle.bounds.midY)
        
        transform.m34 = -1 / 300
        transform = CATransform3DRotate(transform, CGFloat(0 * Double.pi / 180), 1, 0, 0)
        
        ballNumberCircle.layer.transform = transform
        
        bgView.addSubview(ball)
        ball.addSubview(ballNumberCircle)
        ballNumberCircle.addSubview(ballNumber)
    }
    
    /*
    func initialViewSetup_old() {
        
        bgView.backgroundColor = viewBgColor
        ball.backgroundColor = ballColor
        ballNumberCircle.backgroundColor = ballNumberCircleColor
        ballNumber.textColor = ballNumberColor
        
        ball.frame = CGRect(x: 0, y: 0, width: ballSize, height: ballSize)
        ballNumberCircle.frame = CGRect(x: 0, y: 0, width: ballNumberCircleSize, height: ballNumberCircleSize)
        
        ball.center = CGPoint(x: bgView.bounds.midX, y: bgView.bounds.maxY - ballSize / 4)
        ballNumberCircle.center = CGPoint(x: ball.bounds.midX, y: ball.bounds.maxY - ballNumberCircleSize - 140)
        
        ball.layer.cornerRadius = ballSize / 2
        ballNumberCircle.layer.cornerRadius = ballNumberCircleSize / 2

        ball.layer.masksToBounds = true
        
        ballNumber.frame = CGRect(x: 0, y: 0, width: ballNumberCircleSize, height: ballNumberCircleSize + 30)
        
        ballNumber.font = UIFont(name: "DINCondensed-Bold", size: 300.0)
        ballNumber.text = "8"
        ballNumber.textAlignment = .left
        ballNumber.center = ballNumberCircle.center
        ballNumber.center.x -= ballNumberCircleSize / 12 + 8
        ballNumber.center.y += 90
        
        transform.m34 = -1 / 300
        
        transform = CATransform3DRotate(transform, CGFloat(45 * Double.pi / 180), 1, 0, 0)
        
        ballNumberCircle.layer.transform = transform
        
        bgView.addSubview(ball)
        ball.addSubview(ballNumberCircle)
        ballNumberCircle.addSubview(ballNumber)
    }
    */
    
    func initialAnimations() {
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: [],
                       animations: {
                        self.ballNumberCircle.center.y -= 100
                        self.transform = CATransform3DRotate(self.transform, CGFloat(45 * Double.pi / 180), 1, 0, 0)
                        self.ballNumberCircle.layer.transform = self.transform
                       },
                       completion: nil)
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
