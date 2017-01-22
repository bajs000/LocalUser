//
//  BuyByOtherViewController.swift
//  LocalUser
//
//  Created by YunTu on 2016/12/27.
//  Copyright © 2016年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

class BuyByOtherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commitOrderBtn: UIButton!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var totalMoney: UILabel!
    
    var textView:UITextView?
    var remarkTextView:UITextView?
    var placeholder:UILabel?
    var remarkPlaceholder:UILabel?
    var buyPlaceDic:NSDictionary?
    var accpetPlaceDic:NSDictionary?
    var phoneNumText:UITextField?
    var moneyText:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "代购"
        self.commitOrderBtn.layer.cornerRadius = 16
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        let temp = NSMutableAttributedString.init(string: "费用0.00元起")
        temp.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithHexString(hex: "ff9000"), range: NSMakeRange(2, 4))
        self.totalMoney.attributedText = temp
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
            self.tableViewBottom.constant = keyboardRect.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardHide(_ notification:Notification) -> Void {
        UIView.animate(withDuration: 0.75, animations: ({
            self.tableViewBottom.constant = 49
            self.view.layoutIfNeeded()
        }), completion: {(_ finish:Bool) -> Void in
            
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = "headerCell"
        if indexPath.section == 1 {
            cellIdentify = "placeCell"
        }else if indexPath.section == 2 {
            cellIdentify = "detailCell"
        }else if indexPath.section == 3{
            cellIdentify = "remarkCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.section == 0 {
            textView = cell.viewWithTag(1) as? UITextView
            textView?.delegate = self
            placeholder = cell.viewWithTag(2) as? UILabel
        }else if indexPath.section == 1 {
            if self.buyPlaceDic != nil {
                (cell.viewWithTag(11) as! UILabel).text = self.buyPlaceDic?.allKeys[0] as? String
                (cell.viewWithTag(11) as! UILabel).textColor = UIColor.colorWithHexString(hex: "333333")
            }else {
                (cell.viewWithTag(11) as! UILabel).textColor = UIColor.colorWithHexString(hex: "CCCCCC")
            }
            if self.accpetPlaceDic != nil {
                (cell.viewWithTag(12) as! UILabel).text = self.accpetPlaceDic?["address"] as? String
                (cell.viewWithTag(12) as! UILabel).textColor = UIColor.colorWithHexString(hex: "333333")
            }else {
                (cell.viewWithTag(12) as! UILabel).textColor = UIColor.colorWithHexString(hex: "CCCCCC")
            }
            
            (cell.viewWithTag(21) as! UIButton).addTarget(self, action: #selector(mapLocationDidClick(_ :)), for: .touchUpInside)
            (cell.viewWithTag(22) as! UIButton).addTarget(self, action: #selector(placeListPush(_ :)), for: .touchUpInside)
        }else if indexPath.section == 2 {
            self.phoneNumText = (cell.viewWithTag(11) as! UITextField)
            self.moneyText = (cell.viewWithTag(12) as! UITextField)
            (cell.viewWithTag(99) as! UIButton).addTarget(self, action: #selector(dontKownMoneyBtnDidClick(_:)), for: .touchUpInside)
        }else {
            self.remarkTextView = cell.viewWithTag(1) as? UITextView
            self.remarkTextView?.delegate = self
            self.remarkPlaceholder = cell.viewWithTag(2) as? UILabel
        }
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    func mapLocationDidClick(_ sender:UIButton) {
        self.performSegue(withIdentifier: "mapLocationPush", sender: sender)
    }
    
    func placeListPush(_ sender:UIButton) -> Void {
        self.performSegue(withIdentifier: "placePush", sender: sender)
    }
    
    func dontKownMoneyBtnDidClick(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.moneyText?.text = "0"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.textView {
            if textView.text.characters.count > 0 {
                placeholder?.isHidden = true
            }else{
                placeholder?.isHidden = false
            }
        }else {
            if textView.text.characters.count > 0 {
                remarkPlaceholder?.isHidden = true
            }else{
                remarkPlaceholder?.isHidden = false
            }
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    @IBAction func sureBtnDidClick(_ sender: Any) {
        if self.textView?.text.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入购买内容")
            return
        }
        if self.buyPlaceDic == nil {
            SVProgressHUD.showError(withStatus: "请选择购买地")
            return
        }
        if self.accpetPlaceDic == nil {
            SVProgressHUD.showError(withStatus: "请选择送货地")
            return
        }
        if self.phoneNumText?.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入联系人电话")
            return
        }
        if self.moneyText?.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入金额")
            return
        }
        self.requestBuyByOther()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapLocationPush" {
            let vc = segue.destination as! MapLocationViewController
            vc.completeChoseLocation = {(_ locationName:String, location:CLLocationCoordinate2D) -> Void in
                self.buyPlaceDic = [locationName:location]
                self.tableView.reloadData()
            }
        }else if segue.identifier == "placePush" {
            let vc = segue.destination as! PlaceViewController
            vc.completeSelectPlace = {(dic) -> Void in
                self.accpetPlaceDic = dic
                self.tableView.reloadData()
            }
        }else if segue.identifier == "surePush" {
            let vc = segue.destination as! SureOrderViewController
            vc.orderId = (sender as! NSDictionary)["order_number"] as? String
            vc.accpetPlaceDic = self.accpetPlaceDic
            vc.buyPlaceDic = self.buyPlaceDic
            vc.orderType = "1"
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
    
    func requestBuyByOther() -> Void {
        SVProgressHUD.show()
        let location:CLLocationCoordinate2D = self.buyPlaceDic?.allValues[0] as! CLLocationCoordinate2D
        NetworkModel.request(["t_longitude":(self.accpetPlaceDic?["longitude"] as! String),"t_latitude":(self.accpetPlaceDic?["latitude"] as! String),"longitude":String(location.longitude),"latitude":String(location.latitude),"type":"1","charge_money":((self.moneyText?.text)!)], url: "/calculating_cost") { (dic) in
            let dictionary = (dic as! NSDictionary)
            let address = (self.accpetPlaceDic?["add_province"] as! String) + (self.accpetPlaceDic?["add_city"] as! String) + (self.accpetPlaceDic?["add_area"] as! String) + (self.accpetPlaceDic?["address"] as! String)
            let dict = ["money":(dictionary["money"] as! String),
                        "t_longitude":(self.accpetPlaceDic?["longitude"] as! String),
                        "t_latitude":(self.accpetPlaceDic?["latitude"] as! String),
                        "longitude":String(location.longitude),
                        "latitude":String(location.latitude),
                        "user_id":UserModel.shareInstance.userId,
                        "addre_id":(self.accpetPlaceDic?["addre_id"] as! String),
                        "goods_name":(self.textView?.text)!,
                        "buy_address":(self.buyPlaceDic?.allKeys[0] as! String),
                        "dilometers":(dictionary["distance"] as! NSNumber).stringValue,
                        "de_address":address,
                        "charge_money":(self.moneyText?.text)!,
                        "contact_number":(self.phoneNumText?.text)!,
                        "type":"1"]
            NetworkModel.request(dict as NSDictionary, url: "/cart_add_purchasing", complete: {(dic) in
                if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "surePush", sender: dic)
                }else{
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
                }
            })
            
        }
    }

}
