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
    
    let ballOuter = UIView()
    let ballInner = UIView()
    let no8 = UILabel()
    
    // MARK: - Colors.
    
    let viewBgColor = UIColor.systemPink
    let ballColor = UIColor.systemPink
    let ballNumberCircleColor = UIColor.yellow
    let ballNumberColor = UIColor.systemPink
    
    // MARK: - Sizes.
    
    let ballOuterSize: CGFloat = 500
    let ballInnerSize: CGFloat = 275
            
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initialSetup()
    }
    
    func initialSetup() {
        
        bgView.backgroundColor = viewBgColor
        ballOuter.backgroundColor = ballColor
        ballInner.backgroundColor = ballNumberCircleColor
        no8.textColor = ballNumberColor
        
        ballOuter.frame = CGRect(x: 0, y: 0, width: ballOuterSize, height: ballOuterSize)
        ballInner.frame = CGRect(x: 0, y: 0, width: ballInnerSize, height: ballInnerSize)
        
        ballOuter.center = CGPoint(x: bgView.bounds.midX, y: bgView.bounds.maxY - ballOuterSize / 4)
        ballInner.center = CGPoint(x: ballOuter.bounds.midX, y: ballOuter.bounds.maxY - ballInnerSize - 140)
        
        ballOuter.layer.cornerRadius = ballOuterSize / 2
        ballInner.layer.cornerRadius = ballInnerSize / 2

        ballOuter.layer.masksToBounds = true
        
        no8.frame = CGRect(x: 0, y: 0, width: ballInnerSize, height: ballInnerSize + 30)
        
        no8.font = UIFont(name: "DINCondensed-Bold", size: 300.0)
        no8.text = "8"
        no8.textAlignment = .left
        no8.center = ballInner.center
        no8.center.x -= ballInnerSize / 12 + 8
        no8.center.y += 90
        
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 300
        
        transform = CATransform3DRotate(transform, CGFloat(45 * Double.pi / 180), 1, 0, 0)
        
        ballInner.layer.transform = transform
        
        bgView.addSubview(ballOuter)
        ballOuter.addSubview(ballInner)
        ballInner.addSubview(no8)
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
