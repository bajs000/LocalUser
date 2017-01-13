//
//  HistoryOrderViewController.swift
//  LocalUser
//
//  Created by YunTu on 2017/1/13.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

class HistoryOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var totalNum: UILabel!
    @IBOutlet weak var finishNum: UILabel!
    @IBOutlet weak var cancelNum: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sureTime: UIButton!
    @IBOutlet var timeInputView: UIView!
    @IBOutlet weak var beginText: UITextField!
    @IBOutlet weak var endText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var showMore = false
    var orderList:[NSDictionary] = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "历史订单"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.sureTime.layer.cornerRadius = 4
        
        self.beginText.inputView = self.timeInputView
        self.endText.inputView = self.timeInputView
        
        let btn = Helpers.findClass(UIButton.self, at: self.searchBar) as! UIButton
        btn.setTitle("高级筛选", for: .normal)
        btn.isUserInteractionEnabled = true
        btn.isEnabled = true
        
        self.requestHistory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func inputViewBtnDidClick(_ sender: UIButton) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showMore = !showMore
        UIView.animate(withDuration: 0.5) {
            if self.showMore {
                self.headerViewHeight.constant = 200
            }else{
                self.headerViewHeight.constant = 114
            }
            self.view.layoutIfNeeded()
        }
    }
    
    
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.orderList.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = self.orderList[indexPath.section]
        if dic["rec_time"] != nil && !(dic["rec_time"] as! NSObject).isKind(of: NSNull.self) {
            (cell.viewWithTag(1) as! UILabel).text = dic["rec_time"] as! String + "送达"
        }else{
            (cell.viewWithTag(1) as! UILabel).text = "未知时间送达"
        }
        var img:UIImage?
        var typeName = ""
        var typeColor:UIColor?
        if Int(dic["type"] as! String) == 0 {
            img = UIImage(named: "main-btn-0")
            typeName = "代购"
            typeColor = UIColor.colorWithHexString(hex: "54ccff")
        }else if Int(dic["type"] as! String) == 1 {
            img = UIImage(named: "main-btn-1")
            typeName = "配送"
            typeColor = UIColor.colorWithHexString(hex: "ff9b2b")
        }else{
            img = UIImage(named: "main-btn-2")
            typeName = "定制"
            typeColor = UIColor.colorWithHexString(hex: "f76969")
        }
        (cell.viewWithTag(2) as! UIImageView).image = img
        (cell.viewWithTag(3) as! UILabel).text = typeName
        (cell.viewWithTag(3) as! UILabel).textColor = typeColor
        if dic["remarks"] != nil && !(dic["remarks"] as! NSObject).isKind(of: NSNull.self){
            (cell.viewWithTag(4) as! UILabel).text = (dic["remarks"] as! String)
        }else{
            (cell.viewWithTag(4) as! UILabel).text = ""
        }
        if dic["buy_address"] != nil && !(dic["buy_address"] as! NSObject).isKind(of: NSNull.self){
            (cell.viewWithTag(5) as! UILabel).text = "始发地：" + (dic["buy_address"] as! String)
        }else{
            (cell.viewWithTag(5) as! UILabel).text = "始发地："
        }
        if dic["de_address"] != nil && !(dic["de_address"] as! NSObject).isKind(of: NSNull.self){
            (cell.viewWithTag(6) as! UILabel).text = "目的地：" + (dic["de_address"] as! String)
        }else{
            (cell.viewWithTag(6) as! UILabel).text = "目的地："
        }
        if dic["money"] != nil && !(dic["money"] as! NSObject).isKind(of: NSNull.self){
            (cell.viewWithTag(7) as! UILabel).text = "应付：" + (dic["money"] as! String) + "元"
            let tempStr = NSMutableAttributedString(string: ((cell.viewWithTag(7) as! UILabel).text)!)
            tempStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithHexString(hex: "ff7800"), range: NSMakeRange(3, ((cell.viewWithTag(7) as! UILabel).text?.characters.count)! - 3))
            (cell.viewWithTag(7) as! UILabel).attributedText = tempStr
        }else{
            (cell.viewWithTag(7) as! UILabel).text = "应付："
        }
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func requestHistory() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["b_user_id":UserModel.shareInstance.userId], url: "/store_order_list") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                self.orderList = (dic as! NSDictionary)["list"] as! [NSDictionary]
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
                self.totalNum.text = String(self.orderList.count)
                if (dic as! NSDictionary)["ok_num"] != nil && !((dic as! NSDictionary)["ok_num"] as! NSObject).isKind(of: NSNull.self){
                    self.finishNum.text = (dic as! NSDictionary)["ok_num"] as? String
                }else{
                    self.finishNum.text = "0"
                }
                if (dic as! NSDictionary)["cancell_sum"] != nil && !((dic as! NSDictionary)["cancell_sum"] as! NSObject).isKind(of: NSNull.self){
                    self.cancelNum.text = (dic as! NSDictionary)["cancell_sum"] as? String
                }else{
                    self.cancelNum.text = "0"
                }
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }

}
