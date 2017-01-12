//
//  CustomAlert.swift
//  LocalUser
//
//  Created by YunTu on 2016/12/20.
//  Copyright © 2016年 果儿. All rights reserved.
//

import UIKit

class CustomAlert: UIView {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var textField: UITextField!
    var block:((Int) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.isEnabled = false
        self.alertView.layer.cornerRadius = 8
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: ({
            self.alertView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }), completion: {(_ finish:Bool) -> Void in
            UIView.animate(withDuration: 0.23, delay: 0, options: .curveEaseInOut, animations: ({
                self.alertView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }), completion: {(_ finish:Bool) -> Void in
                UIView.animate(withDuration: 0.09, delay: 0.02, options: .curveEaseInOut, animations: ({
                    self.alertView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }), completion: {(_ finish:Bool) -> Void in
                    UIView.animate(withDuration: 0.05, delay: 0.02, options: .curveEaseInOut, animations: ({
                        self.alertView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }), completion: {(_ finish:Bool) -> Void in
                        
                    })
                })
            })
        })
    }
    
    @IBAction func cancelBtnDidClick(_ sender: UIButton) {
        self.removeFromSuperview()
        self.block!(sender.tag)
    }
    
    @IBAction func sureBtnDidClick(_ sender: UIButton) {
        self.removeFromSuperview()
        self.block!(sender.tag)
    }
    
    func showAlert(_ address:String?,block:((_ tag:Int) -> Void)?) -> Void {
        self.block = block
        self.textField.text = address
        let window:UIWindow = ((UIApplication.shared.delegate?.window)!)! as UIWindow
        self.frame = window.frame
        window.addSubview(self)
        window.bringSubview(toFront: self)
        self.layoutIfNeeded()
    }

}
