//
//  ExpressViewController.swift
//  LocalUser
//
//  Created by YunTu on 2016/12/28.
//  Copyright © 2016年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

class ExpressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet var dateInputView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var totalMoney: UILabel!
    
    var textView:UITextView?
    var placeholder:UILabel?
    var buyPlaceDic:NSDictionary?
    var accpetPlaceDic:NSDictionary?
    var timeStr:String?
    var preparePay = "0"
    var consignor:UITextField?
    var consignee:UITextField?
    var goodsKind:UITextField?
    
    @IBAction func cancelBtnDidClick(_ sender: Any) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    @IBAction func sureBtnDidClick(_ sender: Any) {
        UIApplication.shared.keyWindow?.endEditing(true)
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        timeStr = formatter.string(from: self.datePicker.date)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "配送"
        self.commitBtn.layer.cornerRadius = 16
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        self.datePicker.minimumDate = Date()
        let temp = NSMutableAttributedString.init(string: "费用0.00元起")
        temp.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithHexString(hex: "ff9000"), range: NSMakeRange(2, 4))
        self.totalMoney.attributedText = temp
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
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
        var cellIndentify = "placeCell"
        switch indexPath.section {
        case 0:
            break
        case 1:
            cellIndentify = "detailCell"
            break
        case 2:
            cellIndentify = "sortCell"
            break
        case 3:
            cellIndentify = "remarkCell"
            break
        case 4:
            cellIndentify = "requireCell"
            break
        case 5:
            cellIndentify = "timeCell"
            break
        default:
            break
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentify, for: indexPath)
        if indexPath.section == 3 {
            textView = cell.viewWithTag(1) as? UITextView
            textView?.delegate = self
            placeholder = cell.viewWithTag(2) as? UILabel
        }else if indexPath.section == 0 {
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
            
        }else if indexPath.section == 5 {
            if self.timeStr != nil {
                (cell.viewWithTag(2) as! UITextField).text = self.timeStr
            }else{
                (cell.viewWithTag(2) as! UITextField).placeholder = "请选择发货时间"
            }
            (cell.viewWithTag(2) as! UITextField).inputView = self.dateInputView
        }else if indexPath.section == 4 {
            (cell.viewWithTag(99) as! UIButton).addTarget(self, action: #selector(preparePayBtnDidClick(_:)), for: .touchUpInside)
        }else if indexPath.section == 1 {
            self.consignor = cell.viewWithTag(11) as? UITextField
            self.consignee = cell.viewWithTag(12) as? UITextField
        }else if indexPath.section == 2 {
            self.goodsKind = cell.viewWithTag(11) as? UITextField
        }
        return cell
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 0 {
            placeholder?.isHidden = true
        }else{
            placeholder?.isHidden = false
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func preparePayBtnDidClick(_ sender:UIButton) -> Void {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.preparePay = "1"
        }else{
            self.preparePay = "0"
        }
    }
    
    @IBAction func commitBtnDidClick(_ sender: Any) {
        if self.buyPlaceDic == nil {
            SVProgressHUD.showError(withStatus: "请选择发货地")
            return
        }
        if self.accpetPlaceDic == nil {
            SVProgressHUD.showError(withStatus: "请选择目的地")
            return
        }
        if self.consignor?.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入发货人电话")
            return
        }
        if self.consignee?.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入收货人电话")
            return
        }
        if self.goodsKind?.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入物品类型")
            return
        }
        if self.timeStr?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请选择发货时间")
            return
        }
        self.requestBuyByOther()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placePush" {
            let vc = segue.destination as! MapLocationViewController
            vc.completeChoseLocation = {(_ locationName:String, location:CLLocationCoordinate2D) -> Void in
                self.buyPlaceDic = [locationName:location]
                self.tableView.reloadData()
            }
        }else if segue.identifier == "purposePush" {
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
            vc.orderType = "2"
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
        NetworkModel.request(["t_longitude":(self.accpetPlaceDic?["longitude"] as! String),"t_latitude":(self.accpetPlaceDic?["latitude"] as! String),"longitude":String(location.longitude),"latitude":String(location.latitude),"type":"2","charge_money":"0"], url: "/calculating_cost") { (dic) in
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
                        "rec_time":(self.timeStr)!,
                        "consignor":(self.consignor?.text)!,
                        "consignee":(self.consignee?.text)!,
                        "dilometers":(dictionary["distance"] as! NSNumber).stringValue,
                        "de_address":address,
                        "is_colle_pay":self.preparePay,
                        "type":"2"]
            NetworkModel.request(dict as NSDictionary, url: "/cart_add_distribution", complete: {(dic) in
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
