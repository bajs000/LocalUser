//
//  UserInfoViewController.swift
//  LocalUser
//
//  Created by YunTu on 2016/12/30.
//  Copyright © 2016年 果儿. All rights reserved.
//

import UIKit
import SDWebImage

class UserInfoViewController: UITableViewController {

    var titleArr:[[String:String]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.title = "我的账户"
        let user = UserModel.shareInstance
        self.titleArr = [["title":"头像","detail":user.avatar],
                         ["title":"商家名","detail":""],
                         ["title":"地址管理","detail":user.address],
                         ["title":"修改密码","detail":""],
                         ["title":"绑定手机号","detail":user.userPhone],
                         ["title":"代收款账户","detail":""]]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
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
        var cellIndentify = "avatarCell"
        if indexPath.row > 0 {
            cellIndentify = "Cell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentify, for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = titleArr?[indexPath.row]["title"]
        if indexPath.row == 0 {
            cell.viewWithTag(2)?.layer.borderWidth = 4
            cell.viewWithTag(2)?.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
            cell.viewWithTag(2)?.layer.cornerRadius = 28
            (cell.viewWithTag(2) as! UIImageView).sd_setImage(with: URL(string: UserModel.shareInstance.avatar), placeholderImage: UIImage(named: "main-user-default-icon"))
        }else{
            (cell.viewWithTag(2) as! UILabel).text = titleArr?[indexPath.row]["detail"]
            if indexPath.row == 4 {
                (cell.viewWithTag(2) as! UILabel).text = ((cell.viewWithTag(2) as! UILabel).text! as NSString).replacingCharacters(in: NSMakeRange(3, 4), with: "****")
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 5 {
            self.performSegue(withIdentifier: "accountPush", sender: indexPath)
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

}
