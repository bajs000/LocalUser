//
//  OrderPayViewController.swift
//  LocalUser
//
//  Created by YunTu on 2017/1/6.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

class OrderPayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var payLabel: UILabel!
    let titleArr:[[String:String]] = [["title":"支付宝支付","icon":"pay-model-0"],
                                      ["title":"微信支付","icon":"pay-model-1"],
                                      ["title":"余额支付","icon":"pay-model-2"]]
    var currentIndexPath:IndexPath?
    var payDic:NSDictionary?
    var orderId:String?
    
    @IBAction func payBtnDidClick(_ sender: Any) {
        
        self.requestPay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "支付"
        let tempStr = NSMutableAttributedString.init(string: "应付：￥" + (self.payDic?["money"] as! String))
        let range = NSMakeRange(3, (self.payDic?["money"] as! String).characters.count + 1)
        tempStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithHexString(hex: "ff9b2b"), range: range)
        self.payLabel.attributedText = tempStr
        self.payBtn.layer.cornerRadius = 16
        currentIndexPath = IndexPath(row: 0, section: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = self.titleArr[indexPath.row]
        (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: dic["icon"]!)
        (cell.viewWithTag(2) as! UILabel).text = dic["title"]
        if self.currentIndexPath == indexPath {
            (cell.viewWithTag(3) as! UIImageView).image = UIImage(named: "regist-select")
        }else{
            (cell.viewWithTag(3) as! UIImageView).image = UIImage(named: "regist-unselect")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentIndexPath = indexPath
        self.tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func requestPay() {
        SVProgressHUD.show()
        var payment = "alipay"
        if currentIndexPath?.row == 0 {
            payment = "alipay"
        }else if currentIndexPath?.row == 1 {
            payment = "wechat"
        }else{
            SVProgressHUD.showError(withStatus: "暂未开放")
            return
        }
        
        var orderNum = ""
        if self.payDic?["order_number"] == nil {
            orderNum = self.orderId!
        }else {
            orderNum = (self.payDic?["order_number"] as! String)
        }
        NetworkModel.request(["money":(self.payDic?["money"] as! String),"payment":payment,"user_id":UserModel.shareInstance.userId,"pay_type":"1","order_number":orderNum], url: "/recharge") { (dic) in
            SVProgressHUD.dismiss()
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                if self.currentIndexPath?.row == 1 {
                    let stamp = ((dic as! NSDictionary)["timestamp"] as! NSNumber)
                    let req = PayReq.init()
                    req.openID = (dic as! NSDictionary)["appid"] as! String
                    req.partnerId = (dic as! NSDictionary)["mch_id"] as! String
                    req.prepayId = (dic as! NSDictionary)["prepay_id"] as! String
                    req.nonceStr = (dic as! NSDictionary)["nonce_str"] as! String
                    req.package = "Sign=WXPay"
                    req.timeStamp = UInt32(stamp.intValue)
                    
                    var params:[String:String] = [:]
                    params["appid"] = req.openID
                    params["noncestr"] = req.nonceStr
                    params["package"] = req.package
                    params["partnerid"] = req.partnerId
                    params["prepayid"] = req.prepayId
                    params["timestamp"] = stamp.stringValue
                    
                    req.sign = PayListViewController.createMd5Sign(dic: params as NSDictionary)
                    WXApi.send(req)
                }else{
                    let order = Order.init()
                    order.partner = (dic as! [String:String])["PARTNER"]
                    order.sellerID = (dic as! [String:String])["SELLER"]
//                    let dateformatter = DateFormatter.init()
//                    dateformatter.dateFormat = "yyyyMMddHHmmssSSS"
//                    let now = Date()
                    order.outTradeNO = orderNum
                    order.subject = "支付"
                    order.body = "支付"
                    order.totalFee = (self.payDic?["money"] as! String)
                    order.notifyURL = (dic as! [String:String])["notifyurl"]
                    order.service = "mobile.securitypay.pay"
                    order.paymentType = "1"
                    order.inputCharset = "utf-8"
                    order.itBPay = "30m"
                    
                    let orderSpec = order.description
                    let privateKey = (dic as! [String:String])["RSA_PRIVATE"]
                    let signer = CreateRSADataSigner(privateKey)
                    let signedString = signer?.sign(orderSpec)
                    var orderString:String?
                    if signedString != nil {
                        orderString = NSString(format: "%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec,signedString!,"RSA") as String
                        AlipaySDK.defaultService().payOrder(orderString, fromScheme: "alipay20166b5769c1f389", callback: { (resultDic) in
                            print("aaaaa")
                        })
                    }
                }
            }
        }
    }

}
