//
//  PlaceViewController.swift
//  LocalUser
//
//  Created by YunTu on 2016/12/28.
//  Copyright © 2016年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

class PlaceViewController: UITableViewController {

    @IBOutlet weak var commitBtn: UIButton!
    
    var placeList:[NSDictionary]?
    var completeSelectPlace:((NSDictionary) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.commitBtn.layer.cornerRadius = 20
        self.title = "地址管理"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestPlaceList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.placeList == nil {
            return 0
        }
        return (self.placeList?.count)!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: .zero)
        v.backgroundColor = UIColor.clear
        return v
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dic = self.placeList?[indexPath.section]
        var cellIdentify = "Cell"
        if Int((dic?["is_default"] as! String)) == 1 {
            cellIdentify = "defaultCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = dic?["consignee"] as? String
        (cell.viewWithTag(2) as! UILabel).text = dic?["contact_phone"] as? String
        (cell.viewWithTag(3) as! UILabel).text = ((((dic?["add_province"] as? String)! as String?)! + (dic?["add_city"] as? String)! as String?)! + (dic?["add_area"] as? String)! as String?)! + "\n" + (dic?["address"] as? String)! as String?
        (cell.viewWithTag(6) as! UIButton).addTarget(self, action: #selector(deletePlaceBtnDidClick(_:)), for: .touchUpInside)
        (cell.viewWithTag(4) as! UIButton).addTarget(self, action: #selector(defaultPlaceBtnDidClick(_:)), for: .touchUpInside)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = self.placeList?[indexPath.section]
        if self.completeSelectPlace != nil {
            self.completeSelectPlace!(dic!)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

    func deletePlaceBtnDidClick(_ sender:UIButton) -> Void {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender) as! UITableViewCell
        let indexPath = self.tableView.indexPath(for: cell)
        let dic = self.placeList?[(indexPath?.section)!]
        self.requestDeletePlace(dic?["addre_id"] as! String,at: indexPath!)
    }
    
    func defaultPlaceBtnDidClick(_ sender:UIButton) -> Void {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender) as! UITableViewCell
        let indexPath = self.tableView.indexPath(for: cell)
        let dic = self.placeList?[(indexPath?.section)!]
        self.requestSetDefault(dic?["addre_id"] as! String)
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
        if segue.identifier == "editPush" {
            let vc = segue.destination as! AddPlaceViewController
            let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: (sender as! UIButton)) as! UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell)
            let dic = self.placeList?[(indexPath?.section)!]
            vc.editPlace = dic
        }
    }
    
    func requestPlaceList() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["user_id":UserModel.shareInstance.userId], url: "/user_address_list") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                self.placeList = (dic as! NSDictionary)["list"] as? [NSDictionary]
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
    func requestDeletePlace(_ addressId:String, at indexPath:IndexPath) {
        SVProgressHUD.show()
        NetworkModel.request(["addre_id":addressId], url: "/user_address_del") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.placeList?.remove(at: indexPath.section)
                self.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
    func requestSetDefault(_ addressId:String) -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["user_id":UserModel.shareInstance.userId,
                              "is_default":"1",
                              "addre_id":addressId], url: "/user_address_edit") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.requestPlaceList()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }

}
