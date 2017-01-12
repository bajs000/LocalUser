//
//  RegistViewController.swift
//  LocalUser
//
//  Created by YunTu on 2016/12/27.
//  Copyright © 2016年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegistViewController: UIViewController {

    @IBOutlet weak var registBtn: UIButton!
    @IBOutlet weak var detailHeight: NSLayoutConstraint!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var phoneNum: PhoneTextField!
    @IBOutlet weak var verifyText: CodeTextField!
    
    var bess:String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registBtn.layer.cornerRadius = 20
        
        self.verifyText.sendCodeBtn?.addTarget(self, action: #selector(verifyBtnDidClick), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardShow(_ notification:Notification) -> Void {
        let keyboardRect:CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.bottom.constant = keyboardRect.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardHide(_ notification:Notification) -> Void {
        UIView.animate(withDuration: 0.75, animations: ({
            self.bottom.constant = 0
            self.view.layoutIfNeeded()
        }), completion: {(_ finish:Bool) -> Void in
            
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func verifyBtnDidClick() -> Void {
        self.requestVerify()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapDidClick(_ sender: Any) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    @IBAction func backBtnDidClick(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func registTypeChoseBtnDidClick(_ sender: UIButton) {
        sender.isSelected = true
        if sender.tag == 1 {
            (sender.superview?.viewWithTag(2) as! UIButton).isSelected = false
            UIView.animate(withDuration: 0.5, animations: {
                self.detailHeight.constant = 164
                self.view.layoutIfNeeded()
            })
            bess = "1"
        }else{
            (sender.superview?.viewWithTag(1) as! UIButton).isSelected = false
            UIView.animate(withDuration: 0.5, animations: {
                self.detailHeight.constant = 0
                self.view.layoutIfNeeded()
            })
            bess = "0"
        }
    }
    
    @IBAction func sexBtnDidClick(_ sender: UIButton) {
        sender.isSelected = true
        if sender.tag == 1 {
            (sender.superview?.viewWithTag(2) as! UIButton).isSelected = false
        }else{
            (sender.superview?.viewWithTag(1) as! UIButton).isSelected = false
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func requestRegist() -> Void {
        if bess == "0" {
            
        }
        SVProgressHUD.show()
//        NetworkModel.request(["user_phone":], url: "/register") { (dic) in
//            SVProgressHUD.dismiss()
//        }
    }

    func requestVerify() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["phone":phoneNum.text ?? ""], url: "/verify") { (dic) in
            SVProgressHUD.dismiss()
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                self.verifyText.startCount()
                print(dic)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
}
