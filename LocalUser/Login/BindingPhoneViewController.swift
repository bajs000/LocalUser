//
//  BindingPhoneViewController.swift
//  LocalUser
//
//  Created by YunTu on 2017/2/15.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

class BindingPhoneViewController: UIViewController {
    
    @IBOutlet weak var phoneNum: PhoneTextField!
    @IBOutlet weak var verifyText: CodeTextField!
    @IBOutlet weak var nextBtn: UIButton!
    var verify:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.layer.cornerRadius = 20
        self.verifyText.sendCodeBtn?.addTarget(self, action: #selector(verifyBtnDidClick), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public class func getInstance() -> BindingPhoneViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "bindPhone")
        return vc as! BindingPhoneViewController
    }
    
    @IBAction func backBtnDidClick(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func nextBtnDidClick(_ sender: Any) {
        if self.verify == self.verifyText.text {
            _ = self.navigationController?.popToRootViewController(animated: true)
        }else{
            SVProgressHUD.showError(withStatus: "验证码错误")
        }
    }
    
    func verifyBtnDidClick() -> Void {
        if self.phoneNum.text?.characters.count != 11 {
            SVProgressHUD.showError(withStatus: "请正确输入手机号")
            return
        }
        self.requestVerify()
    }
    
    func requestVerify() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["phone":phoneNum.text ?? ""], url: "/verify") { (dic) in
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
    
    func requestBinding() {
        SVProgressHUD.show()
        NetworkModel.request(["user_phone":phoneNum.text!,"mnique":UserModel.shareInstance.mnique], url: "/user_edit") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                _ = self.navigationController?.popToRootViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
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

}
