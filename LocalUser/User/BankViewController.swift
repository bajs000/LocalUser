//
//  BankViewController.swift
//  LocalUser
//
//  Created by YunTu on 2017/1/3.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

class BankViewController: UITableViewController {

    var bankList:NSArray?
    var completeChose:((_ bank:[String:String]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "银行卡"
        self.requestBankList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.bankList == nil {
            return 0
        }
        return (self.bankList?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = (self.bankList?[indexPath.row] as! NSDictionary)["bank_name"] as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = self.bankList?[indexPath.row] as! NSDictionary
        if self.completeChose != nil {
            self.completeChose!(dic as! [String : String])
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func requestBankList() {
        SVProgressHUD.show()
        NetworkModel.request([:], url: "/bank_list", complete: {(dic) -> Void in
            self.bankList = (dic as! NSDictionary)["list"] as? NSArray
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        })
        
    }
    
}
