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
    
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let ballOuterSize: CGFloat = 500
        let ballInnerSize: CGFloat = 275
        
        let ballOuter = UIView()
        let ballInner = UIView()
        let no8 = UILabel()
        
        ballOuter.backgroundColor = UIColor.black
        ballInner.backgroundColor = UIColor.white
        
        ballOuter.frame = CGRect(x: 0, y: 0, width: ballOuterSize, height: ballOuterSize)
        ballInner.frame = CGRect(x: 0, y: 0, width: ballInnerSize, height: ballInnerSize)
        
        ballOuter.center = CGPoint(x: bgView.bounds.midX, y: bgView.bounds.maxY - ballOuterSize / 4)
        ballInner.center = CGPoint(x: ballOuter.bounds.midX, y: ballOuter.bounds.minY + ballInnerSize / 2 - 15)
        
        ballOuter.layer.cornerRadius = ballOuterSize / 2
        ballInner.layer.cornerRadius = ballInnerSize / 2

        ballOuter.layer.masksToBounds = true
        
        ballInner.transform = CGAffineTransform(scaleX: 1, y: 0.85)
        
        no8.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        no8.font = UIFont(name: "DINCondensed-Bold", size: 300.0)
        no8.text = "8"
        no8.textAlignment = .left
        no8.textColor = UIColor.black
        no8.center = ballInner.center
        no8.center.x += 80
        no8.center.y += 20
        
        no8.transform = CGAffineTransform(scaleX: 1, y: 0.85)
        
        
        bgView.addSubview(ballOuter)
        ballOuter.addSubview(ballInner)
        ballInner.addSubview(no8)
        
        /*
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
        print("------------------------------")
        print("Font Family Name = [\(familyName)]")
        let names = UIFont.fontNames(forFamilyName: familyName)
        print("Font Names = [\(names)]")
        }
         */
        
        
    }
}

