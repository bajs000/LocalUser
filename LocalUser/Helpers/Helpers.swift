//
//  Helpers.swift
//  LocalUser
//
//  Created by YunTu on 2016/12/20.
//  Copyright © 2016年 果儿. All rights reserved.
//

import Foundation

class Helpers : NSObject {
    
    public class func screanSize() -> CGSize{
        return UIScreen.main.bounds.size
    }
    
    public class func baseImgUrl() -> String {
        return "http://cdelivery.cq1b1.com/"
    }
    
    public class func findSuperViewClass(_ className:AnyClass,with view:UIView) -> UIView? {
        var superView:UIView? = view
        for _ in 0...10 {
            superView = superView?.superview
            if superView!.isKind(of: className) {
                return superView
            }
        }
        return superView
    }
    
}
