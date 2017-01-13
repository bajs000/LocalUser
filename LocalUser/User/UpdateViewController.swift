//
//  UpdateViewController.swift
//  LocalUser
//
//  Created by YunTu on 2017/1/13.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

enum UpdateType {
    case name
    case password
    case phone
}

class UpdateViewController: UITableViewController {

    var titleArr = [["title":"","detail":"","placeholder":""]]
    var type:UpdateType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "修改", style: .plain, target: self, action: #selector(updateBtnDidClick(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
        if self.type == .password {
            (cell.viewWithTag(2) as! UITextField).isSecureTextEntry = true
        } else if self.type == .phone {
            (cell.viewWithTag(2) as! UITextField).keyboardType = .numberPad
        }
        (cell.viewWithTag(2) as! UITextField).addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return cell
    }
    
    func textFieldDidChange(_ sender: UITextField) {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
        let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
        var dic = titleArr[(indexPath?.row)!]
        dic["detail"] = sender.text
        titleArr.remove(at: (indexPath?.row)!)
        titleArr.insert(dic, at: (indexPath?.row)!)
    }

    func updateBtnDidClick(_ sender: UIBarButtonItem) -> Void {
        self.requestUpdate()
    }
    
    func requestUpdate() -> Void {
        SVProgressHUD.show()
        var dic:NSDictionary?
        var url = ""
        if type == .name {
            dic = ["user_name":(titleArr[0]["detail"])!,"mnique":UserModel.shareInstance.mnique]
            url = "/user_edit"
        }else if type == .password {
            url = "/edit_password"
            dic = ["password":(titleArr[0]["detail"])!,"mnique":UserModel.shareInstance.mnique]
        }else if type == .phone {
            url = "/user_edit"
            dic = ["user_phone":(titleArr[0]["detail"])!,"mnique":UserModel.shareInstance.mnique]
        }
        NetworkModel.request(dic!, url: url) { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                _ = self.navigationController?.popToRootViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
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
