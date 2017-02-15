//
//  PayListViewController.swift
//  LocalUser
//
//  Created by YunTu on 2017/2/15.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

enum PayType {
    case alipay
    case weixin
}

class PayListViewController: UITableViewController {

    var payList:NSArray = []
    var type:PayType = .alipay
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestPayList()
    }
    
    public class func getInstance() -> PayListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "payList")
        return vc as! PayListViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = (payList[indexPath.row] as! NSDictionary)["name"] as? String
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.requestPay(rechaId: (payList[indexPath.row] as! NSDictionary)["recha_id"] as! String, money: (payList[indexPath.row] as! NSDictionary)["money"] as! String)
    }
    
    func requestPayList() -> Void {
        SVProgressHUD.show()
        NetworkModel.request([:], url: "/recharge_list") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                self.payList = (dic as! NSDictionary)["list"] as! NSArray
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
    func requestPay(rechaId:String,money:String) {
        SVProgressHUD.show()
        var payment = "alipay"
        if self.type == .weixin {
            payment = "wechat"
        }
        NetworkModel.request(["money":money,"payment":payment,"user_id":UserModel.shareInstance.userId,"pay_type":"1","recha_id":rechaId], url: "/recharge") { (dic) in
            SVProgressHUD.dismiss()
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                if self.type == .weixin {
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
                    let dateformatter = DateFormatter.init()
                    dateformatter.dateFormat = "yyyyMMddHHmmssSSS"
                    let now = Date()
                    order.outTradeNO = dateformatter.string(from: now) + "sj"
                    order.subject = "充值"
                    order.body = "充值"
                    order.totalFee = "0.01"
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

    class func createMd5Sign(dic:NSDictionary) -> String {
        let contentString = NSMutableString()
        let keys = dic.allKeys
        let sortArrays = (keys as NSArray).sortedArray(comparator: { (obj1, obj2) -> ComparisonResult in
            return (obj1 as! String).compare((obj2 as! String), options: NSString.CompareOptions.numeric)
        })
        for categoryId in sortArrays {
            if !(dic[categoryId as! String] as! NSString).isEqual(to: "") && !(dic[categoryId as! String] as! NSString).isEqual(to: "sign") && !(dic[categoryId as! String] as! NSString).isEqual(to: "key"){
                contentString.append(categoryId as! String + "=" + (dic[categoryId as! String] as! String) + "&")
            }
        }
        contentString.appendFormat("key=%@", "hyxjsh07348606123xjsh07348606123")
        let md5Sign = self.md5String(str: contentString as String)
        return md5Sign
    }
    
    class func md5String(str:String) -> String{
        let cStr = str.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
}
