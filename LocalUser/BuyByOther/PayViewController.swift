//
//  PayViewController.swift
//  LocalUser
//
//  Created by YunTu on 2017/1/3.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

class PayViewController: UITableViewController {

    @IBOutlet weak var payBtn: UIButton!
    let titleArr:[[String:String]] = [["title":"支付宝支付","icon":"pay-model-0"],
                                      ["title":"微信支付","icon":"pay-model-1"]/*,
                                      ["title":"余额支付","icon":"pay-model-2"]*/]
    var currentIndexPath:IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "充值"
        self.payBtn.layer.cornerRadius = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentIndexPath = indexPath
        self.tableView.reloadData()
    }

    @IBAction func payBtnDidClick(_ sender: Any) {
        let vc = PayListViewController.getInstance()
        if self.currentIndexPath.row == 0 {
            vc.type = .alipay
        }else{
            vc.type = .weixin
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
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

}
