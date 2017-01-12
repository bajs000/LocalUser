//
//  OrderDetailViewController.swift
//  LocalUser
//
//  Created by 果儿 on 17/1/5.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class OrderDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var commitBtn: UIButton!
    
    var orderBaseInfo:NSDictionary?
    var orderInfo:NSDictionary?
    var cellIdentifys = ["senderCell","mapCell","goodsCell","placeCell","orderCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单详情"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.commitBtn.layer.cornerRadius = 16
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "投诉", style: .plain, target: self, action: #selector(complainBtnDidClick(_:)))
        self.requetOrderDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func complainBtnDidClick(_ sender:UIBarButtonItem) -> Void {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.orderInfo != nil {
            return 5
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifys[indexPath.section], for: indexPath)
        var dic:NSDictionary?
        switch indexPath.section {
        case 0:
            if self.orderInfo?["b_u_info"] != nil && !(self.orderInfo?["b_u_info"] as! NSObject).isKind(of: NSNull.self) {
                (cell as! SenderCell).fillData(self.orderInfo?["b_u_info"] as! NSDictionary)
            }
            break
        case 1:
            if self.orderInfo?["info"] != nil && !(self.orderInfo?["info"] as! NSObject).isKind(of: NSNull.self) {
                (cell as! MapCell).orderInfo = (self.orderInfo?["info"] as! NSDictionary)
            }
            break
        case 2:
            dic = self.orderInfo?["info"] as? NSDictionary
            (cell.viewWithTag(1) as! UILabel).text = dic?["goods_name"] as? String
            (cell.viewWithTag(2) as! UILabel).text = dic?["dilometers"] as! String + "km"
            (cell.viewWithTag(5) as! UILabel).text = ""
            var sum:Double = 0
            if dic?["money"] != nil && !(dic?["money"] as! NSObject).isKind(of: NSNull.self) && (dic?["money"] as! String).characters.count > 0 {
                sum = sum + Double(dic?["money"] as! String)!
                (cell.viewWithTag(4) as! UILabel).text = dic?["money"] as! String + "元"
            }else {
                (cell.viewWithTag(4) as! UILabel).text = "元"
            }
            if dic?["ds_money"] != nil && !(dic?["ds_money"] as! NSObject).isKind(of: NSNull.self) && (dic?["ds_money"] as! String).characters.count > 0 {
                sum = sum + Double(dic?["ds_money"] as! String)!
                (cell.viewWithTag(3) as! UILabel).text = dic?["ds_money"] as! String  + "元"
            }else{
                (cell.viewWithTag(3) as! UILabel).text = "元"
            }
            (cell.viewWithTag(6) as! UILabel).text = "应付：" + (NSString(format: "%.2f", sum) as String)
            break
        case 3:
            dic = self.orderInfo?["info"] as? NSDictionary
            if dic?["c_pick_time"] != nil && !(dic?["c_pick_time"] as! NSObject).isKind(of: NSNull.self) && (dic?["c_pick_time"] as! String).characters.count > 0 {
                (cell.viewWithTag(1) as! UILabel).text = "送达时间：" + (dic?["c_pick_time"] as! String)
            }else{
                (cell.viewWithTag(1) as! UILabel).text = "送达时间："
            }
            (cell.viewWithTag(2) as! UILabel).text = ((self.orderInfo?["u_info"] as! NSDictionary)["user_name"] as! String)
            (cell.viewWithTag(3) as! UILabel).text = ((self.orderInfo?["u_info"] as! NSDictionary)["user_phone"] as! String)
            if self.orderInfo?["b_u_info"] != nil && !(self.orderInfo?["b_u_info"] as! NSObject).isKind(of: NSNull.self) {
                (cell.viewWithTag(4) as! UILabel).text = ((self.orderInfo?["b_u_info"] as! NSDictionary)["for_address"] as! String)
                (cell.viewWithTag(5) as! UILabel).text = ((self.orderInfo?["b_u_info"] as! NSDictionary)["user_name"] as! String)
                (cell.viewWithTag(6) as! UILabel).text = ((self.orderInfo?["b_u_info"] as! NSDictionary)["user_phone"] as! String)
            }
            (cell.viewWithTag(7) as! UILabel).text = (dic?["buy_address"] as! String)
            break
        case 4:
            dic = self.orderInfo?["info"] as? NSDictionary
            (cell.viewWithTag(1) as! UILabel).text = "订单编号：" + (dic?["order_number"] as! String)
            if dic?["payment"] != nil && !(dic?["payment"] as! NSObject).isKind(of: NSNull.self) && !(dic?["payment"] as! NSObject).isKind(of: NSNull.self){
                (cell.viewWithTag(2) as! UILabel).text = "支付方式：" + (dic?["payment"] as! String)
            }else{
                (cell.viewWithTag(2) as! UILabel).text = "支付方式："
            }
            (cell.viewWithTag(3) as! UILabel).text = "下单时间：" + (dic?["time"] as! String)
            if dic?["remarks"] != nil && !(dic?["remarks"] as! NSObject).isKind(of: NSNull.self) && (dic?["remarks"] as! String).characters.count > 0 {
                (cell.viewWithTag(4) as! UILabel).text = "订单备注：" + (dic?["remarks"] as! String)
            }else{
                (cell.viewWithTag(4) as! UILabel).text = "订单备注："
            }
            break
        default:
            break
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

    func requetOrderDetail() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["order_number":self.orderBaseInfo?["order_number"] as! String], url: "/user_order_details") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                self.orderInfo = (dic as! NSDictionary)
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
                var sum:Double = 0
                let dict = self.orderInfo?["info"] as? NSDictionary
                if dict?["money"] != nil && (dict?["money"] as! String).characters.count > 0 {
                    sum = sum + Double(dict?["money"] as! String)!
                }
                if dict?["ds_money"] != nil && !(dict?["ds_money"] as! NSObject).isKind(of: NSNull.self) && (dict?["ds_money"] as! String).characters.count > 0 {
                    sum = sum + Double(dict?["ds_money"] as! String)!
                }
                self.moneyLabel.text = "实付款：" + (NSString(format: "%.2f", sum) as String)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
}
