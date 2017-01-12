//
//  OrderListViewController.swift
//  LocalUser
//
//  Created by YunTu on 2017/1/5.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class OrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectViewLeading: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    
    var orderList:[NSDictionary]?
    var currentSelectTag:Int = 0
    var currentBtn:UIButton?
    var page = 1
    
    @IBAction func menuBtnDidClick(_ sender: UIButton) {
        currentBtn = sender
        for i in 1...7 {
            (sender.superview?.viewWithTag(i) as! UIButton).isSelected = false
        }
        sender.isSelected = true
        UIView.animate(withDuration: 0.5) {
            self.selectViewLeading.constant = CGFloat((sender.tag - 1) * (Int(Helpers.screanSize().width) / 7))
            self.view.layoutIfNeeded()
        }
        self.requestOrderList(sender.tag - 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.title = "我的订单"
        if self.currentSelectTag == 0 {
            currentBtn = self.menuView.viewWithTag(1) as? UIButton
            self.requestOrderList(0)
        }else{
            self.menuBtnDidClick(self.menuView.viewWithTag(currentSelectTag) as! UIButton)
        }
        
        self.tableView.mj_header = MJRefreshHeader(refreshingBlock: {
            [unowned self] in
            self.page = 1
            self.requestOrderList((self.currentBtn?.tag)! - 1)
        })
        
        self.tableView.mj_footer = MJRefreshFooter(refreshingBlock: {
            [unowned self] in
            self.page = self.page + 1
            self.requestOrderList((self.currentBtn?.tag)! - 1)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.orderList == nil {
            return 0
        }
        return (self.orderList?.count)!
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
        let dic = self.orderList?[indexPath.section]
        var cellIdentify = ""
        var img:UIImage?
        var typeName = ""
        var typeColor:UIColor?
        if Int(dic?["type"] as! String) == 0 {
            cellIdentify = "sendCell"
            img = UIImage(named: "main-btn-0")
            typeName = "代购"
            typeColor = UIColor.colorWithHexString(hex: "54ccff")
        }else if Int(dic?["type"] as! String) == 1 {
            cellIdentify = "otherCell"
            img = UIImage(named: "main-btn-1")
            typeName = "配送"
            typeColor = UIColor.colorWithHexString(hex: "ff9b2b")
        }else{
            cellIdentify = "sendCell"
            img = UIImage(named: "main-btn-2")
            typeName = "定制"
            typeColor = UIColor.colorWithHexString(hex: "f76969")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = "订单编号：" + (dic?["order_number"] as! String)
        (cell.viewWithTag(2) as! UILabel).text = (dic?["state_var"] as? String)
        (cell.viewWithTag(3) as! UIImageView).image = img
        
        if Int(dic?["type"] as! String) == 1 {
            if dic?["remarks"] != nil && !(dic?["remarks"] as! NSObject).isKind(of: NSNull.self){
                (cell.viewWithTag(4) as! UILabel).text = "留言信箱：" + (dic?["remarks"] as! String)
            }else{
                (cell.viewWithTag(4) as! UILabel).text = "留言信箱："
            }
            if dic?["buy_address"] != nil && !(dic?["buy_address"] as! NSObject).isKind(of: NSNull.self){
                (cell.viewWithTag(5) as! UILabel).text = "始发地：" + (dic?["buy_address"] as! String)
            }else{
                (cell.viewWithTag(5) as! UILabel).text = "始发地："
            }
            if dic?["de_address"] != nil && !(dic?["de_address"] as! NSObject).isKind(of: NSNull.self){
                (cell.viewWithTag(6) as! UILabel).text = "目的地：" + (dic?["de_address"] as! String)
            }else{
                (cell.viewWithTag(6) as! UILabel).text = "目的地："
            }
            if dic?["contact_number"] != nil && !(dic?["contact_number"] as! NSObject).isKind(of: NSNull.self){
                (cell.viewWithTag(11) as! UILabel).text = "收件人：" + (dic?["contact_number"] as! String)
            }else{
                (cell.viewWithTag(11) as! UILabel).text = "收件人："
            }
        }else{
            if dic?["buy_address"] != nil && !(dic?["buy_address"] as! NSObject).isKind(of: NSNull.self){
                (cell.viewWithTag(4) as! UILabel).text = "始发地：" + (dic?["buy_address"] as! String)
            }else{
                (cell.viewWithTag(4) as! UILabel).text = "始发地："
            }
            if dic?["de_address"] != nil && !(dic?["de_address"] as! NSObject).isKind(of: NSNull.self){
                (cell.viewWithTag(5) as! UILabel).text = "目的地：" + (dic?["de_address"] as! String)
            }else{
                (cell.viewWithTag(5) as! UILabel).text = "目的地："
            }
            if dic?["contact_number"] != nil && !(dic?["contact_number"] as! NSString).isKind(of: NSNull.self){
                (cell.viewWithTag(6) as! UILabel).text = "收件人：" + (dic?["contact_number"] as! String)
            }else{
                (cell.viewWithTag(6) as! UILabel).text = "收件人："
            }
        }
        (cell.viewWithTag(7) as! UILabel).text = typeName
        (cell.viewWithTag(7) as! UILabel).textColor = typeColor
        let tempStr = NSMutableAttributedString.init(string: "应付：￥" + (dic?["money"] as! String))
        let range = NSMakeRange(3, (dic?["money"] as! String).characters.count + 1)
        tempStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithHexString(hex: "ff9b2b"), range: range)
        (cell.viewWithTag(8) as! UILabel).attributedText = tempStr
        cell.viewWithTag(9)?.layer.cornerRadius = 12
        cell.viewWithTag(10)?.layer.cornerRadius = 12
        let firstBtn = cell.viewWithTag(9) as! UIButton
        let secondBtn = cell.viewWithTag(10) as! UIButton
        
        if Int(dic?["state"] as! String) == 0 || Int(dic?["state"] as! String) == 1{//未支付
            firstBtn.isHidden = false
            secondBtn.isHidden = false
            firstBtn.setTitle("取消订单", for: .normal)
            secondBtn.setTitle("立即支付", for: .normal)
            firstBtn.setTitleColor(UIColor.colorWithHexString(hex: "666666"), for: .normal)
            secondBtn.setTitleColor(UIColor.white, for: .normal)
            firstBtn.backgroundColor = UIColor.clear
            secondBtn.backgroundColor = UIColor.colorWithHexString(hex: "fbb125")
            firstBtn.layer.borderWidth = 1
            secondBtn.layer.borderWidth = 0
            firstBtn.layer.borderColor = UIColor.colorWithHexString(hex: "d3d3d3").cgColor
            secondBtn.layer.borderColor = UIColor.clear.cgColor
            (cell.viewWithTag(2) as! UILabel).textColor = UIColor.colorWithHexString(hex: "ff9b2b")
            secondBtn.addTarget(self, action: #selector(payBtnDidClick(_:)), for: .touchUpInside)
            firstBtn.addTarget(self, action: #selector(cancelBtnDidClick(_:)), for: .touchUpInside)
        }else if Int(dic?["state"] as! String) == 2 {//已支付，待接单
            firstBtn.isHidden = true
            secondBtn.isHidden = false
            secondBtn.setTitle("取消订单", for: .normal)
            secondBtn.setTitleColor(UIColor.colorWithHexString(hex: "666666"), for: .normal)
            secondBtn.backgroundColor = UIColor.clear
            secondBtn.layer.borderWidth = 1
            secondBtn.layer.borderColor = UIColor.colorWithHexString(hex: "d3d3d3").cgColor
            (cell.viewWithTag(2) as! UILabel).textColor = UIColor.colorWithHexString(hex: "ff9b2b")
            secondBtn.addTarget(self, action: #selector(cancelBtnDidClick(_:)), for: .touchUpInside)
        }else if Int(dic?["state"] as! String) == 3 {//进行中
            firstBtn.isHidden = true
            secondBtn.isHidden = false
            secondBtn.setTitle("取消订单", for: .normal)
            secondBtn.setTitleColor(UIColor.colorWithHexString(hex: "666666"), for: .normal)
            secondBtn.backgroundColor = UIColor.clear
            secondBtn.layer.borderWidth = 1
            secondBtn.layer.borderColor = UIColor.colorWithHexString(hex: "d3d3d3").cgColor
            (cell.viewWithTag(2) as! UILabel).textColor = UIColor.colorWithHexString(hex: "ff9b2b")
            secondBtn.addTarget(self, action: #selector(cancelBtnDidClick(_:)), for: .touchUpInside)
        }else if Int(dic?["state"] as! String) == 4 {//待收货
            firstBtn.isHidden = true
            secondBtn.isHidden = false
            secondBtn.setTitle("确认收货", for: .normal)
            secondBtn.setTitleColor(UIColor.white, for: .normal)
            secondBtn.backgroundColor = UIColor.colorWithHexString(hex: "fbb125")
            secondBtn.layer.borderWidth = 0
            secondBtn.layer.borderColor = UIColor.clear.cgColor
            (cell.viewWithTag(2) as! UILabel).textColor = UIColor.colorWithHexString(hex: "ff9b2b")
            secondBtn.addTarget(self, action: #selector(sureGoodsBtnDidClick(_:)), for: .touchUpInside)
        }else if Int(dic?["state"] as! String) == 5 {//为已完成
            firstBtn.isHidden = true
            secondBtn.isHidden = false
            secondBtn.setTitle("已完成", for: .normal)
            secondBtn.setTitleColor(UIColor.colorWithHexString(hex: "666666"), for: .normal)
            secondBtn.backgroundColor = UIColor.clear
            secondBtn.layer.borderWidth = 1
            secondBtn.layer.borderColor = UIColor.colorWithHexString(hex: "d3d3d3").cgColor
            (cell.viewWithTag(2) as! UILabel).textColor = UIColor.colorWithHexString(hex: "333333")
        }else if Int(dic?["state"] as! String) == 6 {//为取消订单
            firstBtn.isHidden = true
            secondBtn.isHidden = true
            (cell.viewWithTag(2) as! UILabel).textColor = UIColor.colorWithHexString(hex: "999999")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailPush", sender: indexPath)
    }
    
    
    func payBtnDidClick(_ sender:UIButton) -> Void {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender) as! UITableViewCell
        let indexPath = self.tableView.indexPath(for: cell)
        let dic = self.orderList?[(indexPath?.section)!]
        self.performSegue(withIdentifier: "payPush", sender: dic)
    }
    
    func cancelBtnDidClick(_ sender:UIButton) -> Void {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender) as! UITableViewCell
        let indexPath = self.tableView.indexPath(for: cell)
        let dic = self.orderList?[(indexPath?.section)!]
        self.requestCancelOrder(dic!)
    }
    
    func sureGoodsBtnDidClick(_ sender:UIButton) {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender) as! UITableViewCell
        let indexPath = self.tableView.indexPath(for: cell)
        let dic = self.orderList?[(indexPath?.section)!]
//        self.performSegue(withIdentifier: "payPush", sender: dic)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailPush" {
            let vc = segue.destination as! OrderDetailViewController
            let dic = self.orderList?[(sender as! IndexPath).section]
            vc.orderBaseInfo = dic
        }else if segue.identifier == "payPush" {
            let vc = segue.destination as! OrderPayViewController
            vc.payDic = (sender as! NSDictionary)
            vc.orderId = (sender as! NSDictionary)["order_number"] as? String
        }
    }
    

    func requestOrderList(_ state:Int) {
        SVProgressHUD.show()
        var dic = ["user_id":UserModel.shareInstance.userId,"page":String(page)]
        if state != 0 {
            dic["state"] = String(state)
        }
        NetworkModel.request(dic as NSDictionary, url: "/user_order_list") { (dic) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                self.orderList = (dic as! NSDictionary)["list"] as? [NSDictionary]
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }else{
                self.orderList = [NSDictionary]()
                self.tableView.reloadData()
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
    func requestCancelOrder(_ dic:NSDictionary) {
        SVProgressHUD.show()
        NetworkModel.request(["order_number":(dic["order_number"] as! String),"state":"6"], url: "/user_order_edit") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                self.requestOrderList((self.currentBtn?.tag)! - 1)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
}
