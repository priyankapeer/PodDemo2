//
//  File.swift
//  PBLoaderView
//
//  Created by Peerbits 8 on 23/10/18.
//  Copyright © 2018 Peerbits. All rights reserved.
//

import Foundation
import UIKit

class PBLoaderView : UIView
{
    
    let screenSize = UIScreen.main.bounds
    
    var img = UIImage()
    
    var imgView : UIImageView!
    
    var rootView : UIView!
    
    
    var loaderView : PBLoaderView!
    
    

    
    
    public enum AnimationType {
        
        case flipLeftRight
        
        case flipTopBottom
        
        case flipBothSide
        
        case circleSpin
        
    }
    
    
    
    
    
    override init(frame : CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func show1(vc:UIView,image : UIImage,animation: AnimationType)
    {
        let frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        loaderView = PBLoaderView(frame: frame)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = loaderView.bounds
        img = image
        let actualSize = img.size
        var height = actualSize.height
        var width = actualSize.width
        if height > 100
        {
            height = 100
            width = 100
        }
        if height <= 20
        {
            height = 50
            width = 50
        }
        let imgFrame = CGRect(x: ((screenSize.width/2)-(height/2))-10, y: ((screenSize.height/2)-(width/2))-10, width: width+10, height: height+10)
        let imgParentView = UIView(frame: imgFrame)
        imgView = UIImageView(frame: CGRect(x: 5, y: 5, width: imgFrame.width-10, height: imgFrame.height-10))
        imgView.contentMode = .scaleAspectFit
        imgView.image = image
        let imgBlur = UIVisualEffectView()
        imgView.addSubview(imgBlur)
        imgBlur.frame = imgView.bounds
        imgView.clipsToBounds = true
        imgView.layer.masksToBounds = true
        imgParentView.addSubview(imgView)
        imgView.layer.cornerRadius = imgView.frame.width/2
        imgParentView.backgroundColor = .white
        imgParentView.layer.cornerRadius = imgParentView.frame.width/2
        imgParentView.layer.shadowOpacity = 0.5
        imgParentView.layer.shadowRadius = 5
        imgParentView.layer.shadowColor = UIColor.black.cgColor
        loaderView.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 0.8)
        blurEffectView.contentView.addSubview(imgParentView)
        loaderView.addSubview(imgParentView)
        vc.addSubview(loaderView)
        let rotationAnimationY = CABasicAnimation(keyPath: "transform.rotation.y")
        if animation == .flipLeftRight
        {
            UIView.animate(withDuration: 0.2, delay: 15, options: .transitionCrossDissolve, animations: {
                rotationAnimationY.fromValue = 0
                rotationAnimationY.toValue = 180
                rotationAnimationY.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
                let innerAnimationDurationY : CGFloat = 50
                rotationAnimationY.duration = Double(innerAnimationDurationY)
                rotationAnimationY.repeatCount = .infinity
                imgParentView.layer.cornerRadius = imgParentView.frame.width/2
                imgParentView.layer.add(rotationAnimationY, forKey: "rotateY")
            }, completion: {
                (value: Bool) in
                UIView.animate(withDuration: 15, delay: 25, options: .curveLinear, animations: {
                    rotationAnimationY.autoreverses = true
                }
                    , completion: {
                        (value: Bool) in
                })
            })
        }
           
        else if animation == .flipTopBottom
        {
            let rotationAnimationX = CABasicAnimation(keyPath: "transform.rotation.x")
            UIView.animate(withDuration: 0.2, delay: 15, options: .curveLinear, animations: {
                rotationAnimationX.fromValue = 0
                rotationAnimationX.toValue = 180
                let innerAnimationDurationX : CGFloat = 50
                rotationAnimationX.duration = Double(innerAnimationDurationX)
                rotationAnimationX.repeatCount = .infinity
                imgParentView.layer.cornerRadius = imgParentView.frame.width/2
                imgParentView.layer.add(rotationAnimationX, forKey: "rotateX")
            }, completion: {
                (value: Bool) in
                UIView.animate(withDuration: 15, delay: 25, options: .curveLinear, animations: {
                    rotationAnimationX.autoreverses = true
                }
                    , completion: {
                        (value: Bool) in
                })
            })
        }
        else if animation == .flipBothSide{
            let duration: CFTimeInterval = 3
            let timingFunction = CAMediaTimingFunction(controlPoints: 0.09, 0.07, 0.9, 0.9)
            let animation = CAKeyframeAnimation(keyPath: "transform")
            animation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
            animation.timingFunctions = [timingFunction, timingFunction, timingFunction, timingFunction]
            animation.values = [
               // NSValue(caTransform3D: CATransform3DConcat(createRotateXTransform(angle: 0), createRotateYTransform(angle: 0))),
               // NSValue(caTransform3D: CATransform3DConcat(createRotateXTransform(angle: CGFloat(Double.pi)), createRotateYTransform(angle: 0))),
                NSValue(caTransform3D: CATransform3DConcat(createRotateXTransform(angle: CGFloat(Double.pi)), createRotateYTransform(angle: CGFloat(Double.pi)))),
                NSValue(caTransform3D: CATransform3DConcat(createRotateXTransform(angle: 0), createRotateYTransform(angle: CGFloat(Double.pi)))),
                NSValue(caTransform3D: CATransform3DConcat(createRotateXTransform(angle: 0), createRotateYTransform(angle: 0)))
            ]
            animation.duration = duration
            animation.repeatCount = .infinity
            animation.isRemovedOnCompletion = false
            imgParentView.layer.cornerRadius = imgParentView.frame.width/2
            imgParentView.layer.add(animation, forKey: "rotateXY")
        }
        
        
        else if animation == .circleSpin{
            let beginTime: Double = 0.5
            let strokeStartDuration: Double = 1.2
            let strokeEndDuration: Double = 0.7
            
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.byValue = Float.pi * 2
            #if swift(>=4.2)
            rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
            #else
            rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            #endif
            
            let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
            strokeEndAnimation.duration = strokeEndDuration
            strokeEndAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
            strokeEndAnimation.fromValue = 0
            strokeEndAnimation.toValue = 1
            
            let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
            strokeStartAnimation.duration = strokeStartDuration
            strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
            strokeStartAnimation.fromValue = 0
            strokeStartAnimation.toValue = 1
            strokeStartAnimation.beginTime = beginTime
            
            let groupAnimation = CAAnimationGroup()
            groupAnimation.animations = [rotationAnimation, strokeEndAnimation, strokeStartAnimation]
            groupAnimation.duration = strokeStartDuration + beginTime
            groupAnimation.repeatCount = .infinity
            groupAnimation.isRemovedOnCompletion = false
            #if swift(>=4.2)
            groupAnimation.fillMode = .forwards
            #else
            groupAnimation.fillMode = kCAFillModeForwards
            #endif
            
            let layer: CAShapeLayer = CAShapeLayer()
            let path: UIBezierPath = UIBezierPath()
            
            let size = CGSize(width: imgParentView.frame.width, height: imgParentView.frame.height)//imgParentView.frame.size
            let color = UIColor.lightGray
            
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: -(.pi / 2),
                        endAngle: .pi + .pi / 2,
                        clockwise: true)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = 2
            layer.backgroundColor = nil
            layer.path = path.cgPath
            layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            
            let circle = layer
            let frame = CGRect(
                x: (layer.bounds.width - size.width) / 2,
                y: (layer.bounds.height - size.height) / 2,
                width: size.width,
                height: size.height
            )
            
            circle.frame = frame
            circle.add(groupAnimation, forKey: "animation")
            imgParentView.layer.addSublayer(circle)
        }
        
    }
        
        
     
    func createRotateXTransform(angle: CGFloat) -> CATransform3D {
        var transform = CATransform3DMakeRotation(angle, 1, 0, 0)
        
        transform.m34 = CGFloat(-1) / 100
        
        return transform
    }
    
    func createRotateYTransform(angle: CGFloat) -> CATransform3D {
        var transform = CATransform3DMakeRotation(angle, 0, 1, 0)
        
        transform.m34 = CGFloat(-1) / 100
        
        return transform
    }
        
        //self.perform(#selector(self.hide), with: self, afterDelay: 2)
        
    
    
    @objc func hide()
    {
        imgView.layer.removeAnimation(forKey: "fadeInNewView")
        imgView.layer.removeAnimation(forKey: "rotateX")
        imgView.layer.removeAnimation(forKey: "rotateY")
        imgView.layer.removeAnimation(forKey: "rotateXY")
        for subView in window?.rootViewController?.view.subviews ?? [UIView()]
        {
            if subView.isKind(of: PBLoaderView.self)
            {
                subView.removeFromSuperview()
            }
        }
        loaderView.removeFromSuperview()
    }
    
    
}
