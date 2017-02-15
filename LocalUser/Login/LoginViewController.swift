//
//  LoginViewController.swift
//  LocalUser
//
//  Created by YunTu on 2016/12/20.
//  Copyright © 2016年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD
import ReactiveCocoa

class LoginViewController: UIViewController, TencentSessionDelegate {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var phoneNum: PhoneTextField!
    @IBOutlet weak var password: PhoneTextField!
    var tencentOAuth:TencentOAuth?
    
    @IBAction func backBtnDidClick(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backgroundViewDidTap(_ sender: Any) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    @IBAction func loginChoseBtnDidClick(_ sender: UIButton) {
        var tag = 1
        if sender.tag == 1{
            tag = 2
        }
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        (sender.superview?.viewWithTag(tag) as! UIButton).titleLabel?.font = UIFont.systemFont(ofSize: 22)
        
    }
    
    @IBAction func loginBtnDidClick(_ sender: Any) {
        if self.phoneNum.text?.characters.count != 11 {
            SVProgressHUD.showError(withStatus: "请正确输入手机号")
            return
        }
        if (self.password.text?.characters.count)! < 6 {
            SVProgressHUD.showError(withStatus: "密码不能少于6位")
            return
        }
        self.requestLogin()
    }
    
    @IBAction func wxLoginBtnDidClick(_ sender: Any) {
        let req = SendAuthReq.init()
        req.state = "xxx"
        req.scope = "snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
        req.openID = "wx20166b5769c1f389"
        WXApi.sendAuthReq(req, viewController: self, delegate: UIApplication.shared.delegate as! WXApiDelegate!)
    }
    
    @IBAction func qqLoginBtnDidClick(_ sender: Any) {
//100556074
//        tencentOAuth?.redirectURI = "http://jyfinance.gicp.net:8080/USALive"
        tencentOAuth?.sessionDelegate = self
        tencentOAuth?.authorize([kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,kOPEN_PERMISSION_GET_INFO,kOPEN_PERMISSION_ADD_SHARE])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginBtn.layer.cornerRadius = 20
        tencentOAuth = TencentOAuth.init(appId: "100556074", andDelegate: self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tencentDidLogin() {
//        print(tencentOAuth?.accessToken ?? "")
        SVProgressHUD.show()
        tencentOAuth?.getUserInfo()
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        
    }
    
    func tencentDidNotNetWork() {
        
    }
    
    func getUserInfoResponse(_ response: APIResponse!) {
        if response.retCode == 0 {
            NetworkModel.request(["openid":((tencentOAuth?.accessToken)! as String),"category":"qq","head_graphic":(response.jsonResponse["figureurl_qq_2"] as! String)], url: "/logo", complete: { (dic) in
                if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                    SVProgressHUD.dismiss()
                    print(dic)
                    UserDefaults.standard.set((dic as! NSDictionary)["user_id"], forKey: "USERID")
                    UserDefaults.standard.set((dic as! NSDictionary)["mnique"], forKey: "MNIQUE")
                    UserDefaults.standard.synchronize()
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
                }
            })
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
    
    func requestLogin() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["user_phone":phoneNum.text ?? "","password":password.text ?? "","is_bess":"1"], url: "/logo", complete: {(dic) -> Void in
            SVProgressHUD.dismiss()
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                UserDefaults.standard.set((dic as! NSDictionary)["user_id"], forKey: "USERID")
                UserDefaults.standard.set((dic as! NSDictionary)["mnique"], forKey: "MNIQUE")
                UserDefaults.standard.synchronize()
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        })
    }

}
