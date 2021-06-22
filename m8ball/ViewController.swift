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
        
        ballOuter.backgroundColor = UIColor.black
        ballInner.backgroundColor = UIColor.white
        
        ballOuter.frame = CGRect(x: 0, y: 0, width: ballOuterSize, height: ballOuterSize)
        ballInner.frame = CGRect(x: 0, y: 0, width: ballInnerSize, height: ballInnerSize)
        
        ballOuter.center = CGPoint(x: bgView.bounds.midX, y: bgView.bounds.maxY - ballOuterSize / 4)
        ballInner.center = CGPoint(x: ballOuter.bounds.midX, y: ballOuter.bounds.minY + ballInnerSize / 2 - 10)
        
        ballOuter.layer.cornerRadius = ballOuterSize / 2
        ballInner.layer.cornerRadius = ballInnerSize / 2

        ballOuter.layer.masksToBounds = true
        
        ballInner.transform = CGAffineTransform(scaleX: 1, y: 0.85)
        
        bgView.addSubview(ballOuter)
        ballOuter.addSubview(ballInner)
        
        
    }
}

