//
//  BubbleView.swift
//  LocalUser
//
//  Created by YunTu on 2016/12/22.
//  Copyright © 2016年 果儿. All rights reserved.
//

import UIKit

class BubbleView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1)
//        context!.setStrokeColor(red: 221.0/255.0,green: 221.0/255.0,blue: 221.0/255.0,alpha: 1)
        context?.setStrokeColor(red: 1,green: 0,blue: 0,alpha: 1)
        context?.setFillColor(UIColor.white.cgColor)
        context?.move(to: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height - 1))
        context?.addLine(to: CGPoint(x: self.frame.size.width / 2 + 4,y:self.frame.size.height - 4))
        context?.addLine(to: CGPoint(x: self.frame.size.width - 3,y:self.frame.size.height - 4))
        context?.addArc(tangent1End: CGPoint(x:self.frame.size.width,y:self.frame.size.height - 4), tangent2End: CGPoint(x:self.frame.size.width - 1,y:self.frame.size.height - 8), radius: 3)
        context?.addLine(to: CGPoint(x: self.frame.size.width - 1,y:5))
        context?.addArc(tangent1End: CGPoint(x:self.frame.size.width,y:0), tangent2End: CGPoint(x:self.frame.size.width - 4,y:1), radius: 3)
        context?.addLine(to: CGPoint(x: 5,y:1))
        context?.addArc(tangent1End: CGPoint(x:0,y:0), tangent2End: CGPoint(x:1,y:4), radius: 3)
        context?.addLine(to: CGPoint(x: 1,y:self.frame.size.height - 8))
        context?.addArc(tangent1End: CGPoint(x:0,y:self.frame.size.height - 4), tangent2End: CGPoint(x:4,y:self.frame.size.height - 4), radius: 3)
        context?.addLine(to: CGPoint(x: self.frame.size.width / 2 - 4,y:self.frame.size.height - 4))
        context?.addLine(to: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height - 1))
        context?.fillPath()
        context?.strokePath()
//        context?.closePath()
    }

}
