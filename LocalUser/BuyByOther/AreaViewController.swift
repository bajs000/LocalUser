//
//  AreaViewController.swift
//  LocalUser
//
//  Created by YunTu on 2016/12/30.
//  Copyright © 2016年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

class AreaViewController: UITableViewController {

    var placeArr:NSArray?
    var count = 0
    var completeChose:((_ area:NSDictionary) -> Void)?
    var choseArea:[String:NSDictionary] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择地址"
        self.requestArea(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if placeArr == nil {
            return 0
        }
        return (placeArr?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = (self.placeArr?[indexPath.row] as! NSDictionary)["name"] as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        count = count + 1
        let dic = self.placeArr?[indexPath.row] as? NSDictionary
        choseArea[String(count)] = dic!
        if count > 2 {
            if self.completeChose != nil {
                self.completeChose!(self.choseArea as NSDictionary)
                _ = self.navigationController?.popViewController(animated: true)
            }
        }else {
            self.requestArea(dic?["id"] as? String)
        }
    }

    func requestArea(_ pid:String?) {
        SVProgressHUD.show()
        var dic = ["type":"1"]
        if pid != nil && (pid?.characters.count)! > 0 {
            dic = ["type":"1","pid":pid!]
        }
        
//        let req = URLRequest(url: URL(string: "http://cdelivery.cq1b1.com/api.php/index/area_list")!)
        
        NetworkModel.request(dic as NSDictionary, url: "/area_list") { (dict) in
            self.placeArr = (dict as? NSDictionary)?["list"] as? NSArray
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
        
//        NetworkModel.init(with: dic as NSDictionary?, url: "/area_list", requestMethod: .POST, requestType: .HTTP).startWithCompletionBlock(success: { (request) in
//            self.placeArr = request.responseObject as? NSArray
//            self.tableView.reloadData()
//            print(request.responseObject ?? "")
//            print(request.responseString ?? "")
//        }, failure: { (request) in
//            print(request.error!)
//        })
    }
    
}
