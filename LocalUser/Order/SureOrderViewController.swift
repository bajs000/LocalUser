//
//  SureOrderViewController.swift
//  LocalUser
//
//  Created by YunTu on 2017/1/6.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

class SureOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet var dateInputView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var textView:UITextView?
    var placeholder:UILabel?
    var timeText:UITextField?
    
    var orderId:String?
    var orderType:String?
    var buyPlaceDic:NSDictionary?
    var accpetPlaceDic:NSDictionary?
    var ticketDic:NSDictionary?
    
    @IBAction func dateActionDidClick(_ sender: UIButton) {
        if sender.tag == 2 {
            let format = DateFormatter.init()
            format.dateFormat = "yyyy-MM-dd"
            self.timeText?.text = format.string(from: datePicker.date)
        }
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "确认订单"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.commitBtn.layer.cornerRadius = 16
        self.bottomViewHeight.constant = 49
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "other-notice"), style: .plain, target: self, action: #selector(noticeBtnDidClick(_:)))
        self.datePicker.minimumDate = Date()
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
            self.bottomViewHeight.constant = keyboardRect.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardHide(_ notification:Notification) -> Void {
        UIView.animate(withDuration: 0.75, animations: ({
            self.bottomViewHeight.constant = 49
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
        // Dispose of any resources that can be recreated.
    }
    
    func noticeBtnDidClick(_ sender: UIBarButtonItem) -> Void {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 2
        case 5:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = ""
        if indexPath.section < 2 {
            cellIdentify = "normalCell"
        }else if indexPath.section == 2 {
            cellIdentify = "timeCell"
        }else if indexPath.section == 3 {
            cellIdentify = "remarkCell"
        }else if indexPath.section == 4 {
            if indexPath.row == 0 {
                cellIdentify = "acceptCell"
            }else {
                cellIdentify = "ticketCell"
            }
        }else if indexPath.section == 5 {
            cellIdentify = "infoCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.section == 0 {
            cell.viewWithTag(5)?.isHidden = true
            if indexPath.row == 0 {
                (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "order-user-icon")
                (cell.viewWithTag(2) as! UILabel).text = "用户名称"
                (cell.viewWithTag(3) as! UITextField).text = self.accpetPlaceDic?["consignee"] as? String
                cell.viewWithTag(6)?.isHidden = false
            }else{
                (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "order-id")
                (cell.viewWithTag(2) as! UILabel).text = "订单号"
                (cell.viewWithTag(3) as! UITextField).text = self.orderId
                cell.viewWithTag(6)?.isHidden = true
            }
        }else if indexPath.section == 1 {
            cell.viewWithTag(5)?.isHidden = false
            if indexPath.row == 0 {
                (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "other-location")
                (cell.viewWithTag(2) as! UILabel).text = "始发地"
                (cell.viewWithTag(3) as! UITextField).text = self.buyPlaceDic?.allKeys[0] as? String
                cell.viewWithTag(4)?.isHidden = true
                cell.viewWithTag(6)?.isHidden = false
            }else if indexPath.row == 1 {
                (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "other-location")
                (cell.viewWithTag(2) as! UILabel).text = "目的地"
                (cell.viewWithTag(3) as! UITextField).text = self.accpetPlaceDic?["address"] as?  String
                cell.viewWithTag(4)?.isHidden = true
                cell.viewWithTag(6)?.isHidden = false
            }else{
                (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "order-accept-user")
                (cell.viewWithTag(2) as! UILabel).text = "收件人"
                (cell.viewWithTag(3) as! UITextField).text = self.accpetPlaceDic?["consignee"] as? String
                (cell.viewWithTag(4) as! UILabel).text = self.accpetPlaceDic?["contact_phone"] as? String
                cell.viewWithTag(4)?.isHidden = false
                cell.viewWithTag(5)?.isHidden = true
                cell.viewWithTag(6)?.isHidden = true
            }
        }else if indexPath.section == 2 {
            self.timeText = cell.viewWithTag(2) as? UITextField
            self.timeText?.inputView = self.dateInputView
        }else if indexPath.section == 3 {
            self.textView = cell.viewWithTag(1) as? UITextView
            self.textView?.delegate = self
            self.placeholder = cell.viewWithTag(2) as? UILabel
        }else if indexPath.section == 4 {
            if indexPath.row == 1 {
                if self.ticketDic != nil {
                    (cell.viewWithTag(3) as! UILabel).text = self.ticketDic?["name"] as? String
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if  indexPath.row == 0 {
                self.performSegue(withIdentifier: "mapPush", sender: indexPath)
            }else{
                self.performSegue(withIdentifier: "placePush", sender: indexPath)
            }
        }else if indexPath.section == 4 {
            if indexPath.row == 1 {
                self.performSegue(withIdentifier: "tiketPush", sender: indexPath)
            }
        }
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
    
    @IBAction func payBtnDidClick(_ sender: Any) {
        self.requestSureOrder()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapPush" {
            let vc = segue.destination as! MapLocationViewController
            vc.completeChoseLocation = {(_ locationName:String, location:CLLocationCoordinate2D) -> Void in
                self.buyPlaceDic = [locationName:location]
                self.tableView.reloadData()
            }
        }else if segue.identifier == "placePush"{
            let vc = segue.destination as! PlaceViewController
            vc.completeSelectPlace = {(dic) -> Void in
                self.accpetPlaceDic = dic
                self.tableView.reloadData()
            }
        }else if segue.identifier == "tiketPush" {
            let vc = segue.destination as! TicketViewController
            vc.completeChoseTicket = {(dic) -> Void in
                self.ticketDic = dic
                self.tableView.reloadData()
            }
        }else if segue.identifier == "payPush" {
            let vc = segue.destination as! OrderPayViewController
            vc.payDic = (sender as! NSDictionary)
            vc.orderId = self.orderId
        }
    }
    
    func requestSureOrder() -> Void {
        SVProgressHUD.show()
        let location:CLLocationCoordinate2D = self.buyPlaceDic?.allValues[0] as! CLLocationCoordinate2D
        var dic = ["order_number":(self.orderId)!,
                   "t_longitude":(self.accpetPlaceDic?["longitude"] as! String),
                   "t_latitude":(self.accpetPlaceDic?["latitude"] as! String),
                   "longitude":String(location.longitude),
                   "latitude":String(location.latitude),
                   "type":(self.orderType)!]
        if self.ticketDic != nil {
            dic["coup_id"] = (self.ticketDic?["coup_id"] as! String)
        }
        NetworkModel.request(dic as NSDictionary, url: "/order_cost") { (dic) in
                                    SVProgressHUD.dismiss()
                                    print(dic)
                                self.performSegue(withIdentifier: "payPush", sender: dic)
        }
    }
    
    
}
