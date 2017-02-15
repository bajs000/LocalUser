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
    @IBOutlet weak var userName: PhoneTextField!
    @IBOutlet weak var passwordText: PhoneTextField!
    @IBOutlet weak var surePwdText: PhoneTextField!
    
    var bess:String = "0"
    var verify:String?
    var gender:String = "女士"
    
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
        if self.phoneNum.text?.characters.count != 11 {
            SVProgressHUD.showError(withStatus: "请正确输入手机号")
            return
        }
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
            userName.placeholder = "请输入商户名"
        }else{
            (sender.superview?.viewWithTag(1) as! UIButton).isSelected = false
            UIView.animate(withDuration: 0.5, animations: {
                self.detailHeight.constant = 0
                self.view.layoutIfNeeded()
            })
            userName.placeholder = "请输入用户名"
            bess = "0"
        }
    }
    
    @IBAction func registBtnDidClick(_ sender: Any) {
        if self.verify == nil {
            SVProgressHUD.showError(withStatus: "请先发送验证码")
            return
        }
        if self.verify != self.verifyText.text {
            SVProgressHUD.showError(withStatus: "请正确输入验证码")
            return
        }
        if bess == "1" {
            if (self.userName.text?.characters.count)! == 0 {
                SVProgressHUD.showError(withStatus: "请输入用户名")
                return
            }
            if (self.passwordText.text?.characters.count)! < 6 {
                SVProgressHUD.showError(withStatus: "请输入6位以上密码")
                return
            }
            if self.passwordText.text != self.surePwdText.text {
                SVProgressHUD.showError(withStatus: "两次密码不一致")
                return
            }
        }
        self.requestRegist()
    }
    
    @IBAction func sexBtnDidClick(_ sender: UIButton) {
        sender.isSelected = true
        if sender.tag == 1 {
            gender = "先生"
            (sender.superview?.viewWithTag(2) as! UIButton).isSelected = false
        }else{
            gender = "女士"
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
        var dic:NSDictionary?
        if bess == "0" {
            dic = ["phone":phoneNum.text!,"is_bess":bess]
        }else{
            dic = ["phone":phoneNum.text!,"is_bess":bess,"password":passwordText.text!,"gender":gender,"user_name":self.userName.text!]
        }
        SVProgressHUD.show()
        NetworkModel.request(dic!, url: "/register") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                UserDefaults.standard.set((dic as! NSDictionary)["user_id"], forKey: "USERID")
                UserDefaults.standard.set((dic as! NSDictionary)["mnique"], forKey: "MNIQUE")
                UserDefaults.standard.synchronize()
                _ = self.navigationController?.popToRootViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }

    func requestVerify() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["phone":phoneNum.text ?? "","is_bess":bess], url: "/verify") { (dic) in
            SVProgressHUD.dismiss()
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                self.verifyText.startCount()
                self.verify = (dic as! NSDictionary)["verify"] as? String
                print(dic)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
}
