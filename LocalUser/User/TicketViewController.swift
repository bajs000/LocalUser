//
//  TicketViewController.swift
//  LocalUser
//
//  Created by YunTu on 2017/1/3.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

class TicketViewController: UITableViewController {

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var sureBtn: UIButton!
    var currentIndexPath:IndexPath?
    var ticketList:NSArray?
    
    var completeChoseTicket:((NSDictionary) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "优惠券"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "使用说明", style: .plain, target: self, action: #selector(useInfoBtnDidClick(_:)))
        self.sureBtn.layer.cornerRadius = 20
        if self.completeChoseTicket == nil {
            self.footerView.isHidden = true
        }else{
            self.footerView.isHidden = false
        }
        self.requestTicketList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func useInfoBtnDidClick(_ sender: UIBarButtonItem) -> Void {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.ticketList == nil {
            return 0
        }
        return (self.ticketList?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = self.ticketList?[indexPath.row] as! NSDictionary
        var time = (dic["tem_validity"] as! String)
        time = time.substring(to: time.index(time.startIndex, offsetBy: 10))
        (cell.viewWithTag(1) as! UILabel).text = "￥" + (dic["money"] as! String)
        (cell.viewWithTag(2) as! UILabel).text = (dic["name"] as? String)
        (cell.viewWithTag(3) as! UILabel).text = "有限期至" + time
        if self.currentIndexPath == indexPath {
            (cell.viewWithTag(4) as! UIImageView).image = UIImage(named: "regist-select")
        }else{
            (cell.viewWithTag(4) as! UIImageView).image = UIImage(named: "regist-unselect")
        }
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentIndexPath = indexPath
        self.tableView.reloadData()
    }
    
    @IBAction func sureTicketBtnDidClick(_ sender: Any) {
        if self.currentIndexPath == nil {
            SVProgressHUD.showError(withStatus: "请选择优惠券")
        }else{
            if self.completeChoseTicket != nil {
                let dic = self.ticketList?[(self.currentIndexPath?.row)!] as! NSDictionary
                completeChoseTicket!(dic)
            }
            _ = self.navigationController?.popViewController(animated: true)
        }
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
    
    func requestTicketList() {
        SVProgressHUD.show()
        NetworkModel.request(["user_id":UserModel.shareInstance.userId,"is_use":"1"], url: "/user_coupon") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                print(dic)
                self.ticketList = (dic as! NSDictionary)["list"] as? NSArray
                self.tableView.reloadData()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }

}
