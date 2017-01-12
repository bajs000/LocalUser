//
//  OrderPayViewController.swift
//  LocalUser
//
//  Created by YunTu on 2017/1/6.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit

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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "支付"
        let tempStr = NSMutableAttributedString.init(string: "应付：￥" + (self.payDic?["money"] as! String))
        let range = NSMakeRange(3, (self.payDic?["money"] as! String).characters.count + 1)
        tempStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithHexString(hex: "ff9b2b"), range: range)
        self.payLabel.attributedText = tempStr
        self.payBtn.layer.cornerRadius = 16
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

}
