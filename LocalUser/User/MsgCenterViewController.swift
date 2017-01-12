//
//  MsgCenterViewController.swift
//  LocalUser
//
//  Created by YunTu on 2016/12/30.
//  Copyright © 2016年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class MsgCenterViewController: UITableViewController {

    var msgList:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息通知"
        self.requestMsgList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.msgList == nil {
            return 0
        }
        return (self.msgList?.count)!
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.viewWithTag(2)?.layer.cornerRadius = 4
        let dic = self.msgList?[indexPath.row] as! NSDictionary
        (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img"] as! String)))
        if Int(dic["start"] as! String) == 1 {
            cell.viewWithTag(2)?.isHidden = false
        }else{
            cell.viewWithTag(2)?.isHidden = true
        }
        (cell.viewWithTag(3) as! UILabel).text = dic["type"] as? String
        (cell.viewWithTag(4) as! UILabel).text = dic["time"] as? String
        (cell.viewWithTag(5) as! UILabel).text = dic["name"] as? String
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
    
    func requestMsgList() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["user_id":UserModel.shareInstance.userId], url: "/user_msg_list") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.msgList = (dic as! NSDictionary)["list"] as? NSArray
                self.tableView.reloadData()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }

}
