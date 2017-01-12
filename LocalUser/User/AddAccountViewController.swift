//
//  AddAccountViewController.swift
//  LocalUser
//
//  Created by YunTu on 2017/1/3.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddAccountViewController: UITableViewController {

    @IBOutlet weak var sureBtn: UIButton!
    var titleArr:[[String:String]] = [["title":"持  卡  人","placeholder":"请输入","detail":""],
                    ["title":"卡        号","placeholder":"请输入","detail":""],
                    ["title":"选择银行","placeholder":"请选择","detail":""],
                    ["title":"卡户行名称","placeholder":"请输入","detail":""]]
    var currentBank:[String:String]?
    var editBank:[String:String]?{
        didSet{
            self.titleArr = [["title":"持  卡  人","placeholder":"请输入","detail":(self.editBank?["name"])!],
                             ["title":"卡        号","placeholder":"请输入","detail":(self.editBank?["account"])!],
                             ["title":"选择银行","placeholder":"请选择","detail":(self.editBank?["bank_name"])!],
                             ["title":"卡户行名称","placeholder":"请输入","detail":(self.editBank?["bank_acc_name"])!]]
            self.currentBank = ["bank_logo":(self.editBank?["img"])!,"bank_name":(self.editBank?["bank_name"])!]
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "添加账户"
        self.sureBtn.layer.cornerRadius = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = titleArr[indexPath.row]["title"]
        (cell.viewWithTag(2) as! UITextField).text = titleArr[indexPath.row]["detail"]
        (cell.viewWithTag(2) as! UITextField).placeholder = titleArr[indexPath.row]["placeholder"]
        (cell.viewWithTag(2) as! UITextField).keyboardType = .default
        if indexPath.row == 1 {
            (cell.viewWithTag(2) as! UITextField).keyboardType = .numberPad
        }
        
        if indexPath.row == 2 {
            cell.viewWithTag(3)?.isHidden = false
            (cell.viewWithTag(2) as! UITextField).isUserInteractionEnabled = false
        }else{
            cell.viewWithTag(3)?.isHidden = true
            (cell.viewWithTag(2) as! UITextField).isUserInteractionEnabled = true
            (cell.viewWithTag(2) as! UITextField).addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            self.performSegue(withIdentifier: "bankPush", sender: nil)
        }
    }
    
    func textFieldDidChange(_ textField:UITextField) -> Void {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: textField)
        let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
        var dic = self.titleArr[(indexPath?.row)!]
        dic["detail"] = textField.text
        self.titleArr.remove(at: (indexPath?.row)!)
        self.titleArr.insert(dic, at: (indexPath?.row)!)
    }
    
    @IBAction func sureAddBtnDidClick(_ sender: Any) {
        for dic in self.titleArr {
            if dic["detail"]?.characters.count == 0 {
                SVProgressHUD.showError(withStatus: "请输入" + (dic["title"]?.replacingOccurrences(of: " ", with: ""))!)
                return
            }
        }
        self.requestAddAccount()
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
        let vc = segue.destination as! BankViewController
        vc.completeChose = {(_ bank) -> Void in
            var dic = self.titleArr[2]
            dic["detail"] = bank["bank_name"]
            self.titleArr.remove(at: 2)
            self.titleArr.insert(dic, at: 2)
            self.currentBank = bank
            self.tableView.reloadData()
        }
    }

    func requestAddAccount() -> Void {
        SVProgressHUD.show()
        var url = "/user_bank_add"
        var dic = ["img":(currentBank?["bank_logo"])!,"bank_name":(currentBank?["bank_name"])!,"name":(self.titleArr[0]["detail"])!,"account":(self.titleArr[1]["detail"])!,"bank_acc_name":(self.titleArr[3]["detail"])!,"user_id":UserModel.shareInstance.userId]
        if self.editBank != nil {
            url = "/user_bank_edit"
            dic = ["img":(currentBank?["bank_logo"])!,"bank_name":(currentBank?["bank_name"])!,"name":(self.titleArr[0]["detail"])!,"account":(self.titleArr[1]["detail"])!,"bank_acc_name":(self.titleArr[3]["detail"])!,"user_id":UserModel.shareInstance.userId,"bank_id":(self.editBank?["bank_id"])!]
        }
        NetworkModel.request(dic as NSDictionary, url: url) { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
        
    }
    
}
