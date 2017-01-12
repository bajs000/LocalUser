//
//  AccountViewController.swift
//  LocalUser
//
//  Created by YunTu on 2017/1/3.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class AccountViewController: UITableViewController {

    var accountList:[[String:String]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "代收货款账户"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addAccountBtnDidClick(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestAccountList()
    }
    
    func addAccountBtnDidClick(_ sender: UIBarButtonItem) -> Void {
        self.performSegue(withIdentifier: "addPush", sender: nil)
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
        if self.accountList == nil {
            return 0
        }
        return (self.accountList?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.viewWithTag(1)?.layer.cornerRadius = 6
        cell.viewWithTag(2)?.layer.cornerRadius = 25
        cell.viewWithTag(3)?.layer.cornerRadius = 21
        
        let dic = self.accountList?[indexPath.row]
        (cell.viewWithTag(3) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic?["img"])!))
        (cell.viewWithTag(4) as! UILabel).text = dic?["bank_name"]
        (cell.viewWithTag(5) as! UILabel).text = dic?["account"]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let dic = self.accountList?[indexPath.row]
        let editAction = UITableViewRowAction.init(style: .normal, title: "编辑", handler: { (action, indexPath) in
            self.performSegue(withIdentifier: "addPush", sender: indexPath)
            })
        
        let deleteAction = UITableViewRowAction.init(style: .destructive, title: "删除") { (action, indexPath) in
            self.requestDeleteAccount((dic?["bank_id"])!,indexPath: indexPath)
        }
        return [deleteAction,editAction]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

//    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "删除"
//    }
//    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender != nil {
            let vc = segue.destination as! AddAccountViewController
            let dic = self.accountList?[(sender as! IndexPath).row]
            vc.editBank = dic
        }
    }

    func requestAccountList() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["user_id":UserModel.shareInstance.userId], url: "/user_bank_list") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                self.accountList = (dic as! NSDictionary)["list"] as? [[String:String]]
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
    func requestDeleteAccount(_ bankId:String, indexPath:IndexPath) -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["bank_id":bankId], url: "/user_bank_del") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                self.accountList?.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
}
