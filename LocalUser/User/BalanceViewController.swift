//
//  BalanceViewController.swift
//  LocalUser
//
//  Created by YunTu on 2016/12/30.
//  Copyright © 2016年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

class BalanceViewController: UITableViewController {

    var balanceList:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "余额明细"
        self.requestBalance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.balanceList == nil {
            return 0
        }
        return (self.balanceList?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = self.balanceList?[indexPath.row] as! NSDictionary
        (cell.viewWithTag(1) as! UILabel).text = dic["title"] as? String
        (cell.viewWithTag(2) as! UILabel).text = dic["time"] as? String
        (cell.viewWithTag(3) as! UILabel).text = "余额：" + (dic["balance"] as! String)
        (cell.viewWithTag(4) as! UILabel).text = dic["a_money"] as? String
        if (cell.viewWithTag(4) as! UILabel).text != nil && ((cell.viewWithTag(4) as! UILabel).text?.characters.count)! > 0 {
            if ((cell.viewWithTag(4) as! UILabel).text)!.hasPrefix("-") {
                (cell.viewWithTag(4) as! UILabel).textColor = UIColor.colorWithHexString(hex: "08a805")
            }else{
                (cell.viewWithTag(4) as! UILabel).textColor = UIColor.colorWithHexString(hex: "ff9000")
            }
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func requestBalance() {
        SVProgressHUD.show()
        NetworkModel.request(["user_id":UserModel.shareInstance.userId], url: "/list_detailed") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.balanceList = (dic as! NSDictionary)["list"] as? NSArray
                self.tableView.reloadData()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }

}
