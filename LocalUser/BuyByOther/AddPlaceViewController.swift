//
//  AddPlaceViewController.swift
//  LocalUser
//
//  Created by YunTu on 2016/12/30.
//  Copyright © 2016年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddPlaceViewController: UITableViewController {

    @IBOutlet weak var commitBtn: UIButton!
    
    var titleArr:[String]?
    var currentArea:NSDictionary?
    var currentPlace:NSDictionary?
    var postParam:[String:String]?
    
    var editPlace:NSDictionary?{
        didSet{
            self.postParam = ["0":(self.editPlace?["consignee"] as! String),"1":(self.editPlace?["contact_phone"] as! String)]
            self.currentArea = ["1":["name":(self.editPlace?["add_province"] as! String)],
                                "2":["name":(self.editPlace?["add_city"] as! String)],
                                "3":["name":(self.editPlace?["add_area"] as! String)]]
            
            if !(self.editPlace?["longitude"] as! NSObject).isKind(of: NSNull.self) && !(self.editPlace?["latitude"] as! NSObject).isKind(of: NSNull.self) && (self.editPlace?["longitude"]) != nil && (self.editPlace?["latitude"]) != nil{
                self.currentPlace = [(self.editPlace?["address"] as! String):CLLocationCoordinate2DMake(Double((self.editPlace?["latitude"] as! String))!, Double((self.editPlace?["longitude"] as! String))!)]
            }else{
                self.currentPlace = [(self.editPlace?["address"] as! String):CLLocationCoordinate2DMake(0, 0)]
            }
            
            self.tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新增地址"
        titleArr = ["收货人：","联系方式：","所在地区：","详细地址："]
        if self.postParam == nil{
            self.postParam = ["0":"","1":""]
        }
        self.commitBtn.layer.cornerRadius = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (titleArr?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = titleArr?[indexPath.row]
        cell.viewWithTag(3)?.isHidden = true
        cell.viewWithTag(4)?.isHidden = true
        (cell.viewWithTag(2) as! UITextField).keyboardType = .default
        if indexPath.row == 1{
            (cell.viewWithTag(2) as! UITextField).keyboardType = .numberPad
        }
        if indexPath.row < 3 {
            (cell.viewWithTag(2) as! UITextField).text = self.postParam?[String(indexPath.row)]
        }
        if indexPath.row == 2 {
            cell.viewWithTag(3)?.isHidden = false
            cell.viewWithTag(4)?.isHidden = false
            (cell.viewWithTag(4) as! UIButton).addTarget(self, action: #selector(choseAreaTextDidClick(_:)), for: .touchDown)
            if currentArea != nil {
                let arr = (currentArea!.allKeys as NSArray).sortedArray(using: #selector(NSDecimalNumber.compare(_:))) as! [String]
                var name = ""
                for key in arr {
                    name = name + ((currentArea?[key] as! NSDictionary)["name"] as! String)
                }
                (cell.viewWithTag(2) as! UITextField).placeholder = name
            }
        }else if indexPath.row == 3 {
            cell.viewWithTag(3)?.isHidden = false
            cell.viewWithTag(4)?.isHidden = false
            (cell.viewWithTag(4) as! UIButton).addTarget(self, action: #selector(choseMapLocation(_:)), for: .touchDown)
            if self.currentPlace != nil {
                (cell.viewWithTag(2) as! UITextField).placeholder = self.currentPlace?.allKeys[0] as? String
            }
        }
        (cell.viewWithTag(2) as! UITextField).addTarget(self, action: #selector(textFieldEditDidChange(_:)), for: .editingChanged)
        return cell
    }

    func textFieldEditDidChange(_ sender:UITextField) {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender) as! UITableViewCell
        let indexPath = self.tableView.indexPath(for: cell)
        self.postParam?[String((indexPath?.row)!)] = (sender.text)!
    }
    
    func choseAreaTextDidClick(_ sender:UITextField) -> Void {
        UIApplication.shared.keyWindow?.endEditing(true)
        self.performSegue(withIdentifier: "areaPush", sender: sender)
    }
    
    func choseMapLocation(_ sender:UIButton) -> Void {
        self.performSegue(withIdentifier: "mapPush", sender: sender)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "areaPush" {
            let vc = segue.destination as! AreaViewController
            vc.completeChose = {(_ area:NSDictionary) -> Void in
                self.currentArea = area
                self.tableView.reloadData()
            }
        }else if segue.identifier == "mapPush" {
            let vc = segue.destination as! MapLocationViewController
            vc.completeChoseLocation = {(_ locationName:String, location:CLLocationCoordinate2D) -> Void in
                self.currentPlace = [locationName:location]
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func commitBtnDidClick(_ sender: Any) {
        if self.postParam?["0"]?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入收货人")
            return
        }
        if self.postParam?["1"]?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请正确输入联系方式")
            return
        }
        if self.currentArea == nil {
            SVProgressHUD.showError(withStatus: "请选择所在地区")
            return
        }
        if self.currentPlace == nil {
            SVProgressHUD.showError(withStatus: "请选择详细地址")
            return
        }
        self.requestAddPlace()
    }
    
    func requestAddPlace() -> Void {
        SVProgressHUD.show()
        var dic = ["consignee":(self.postParam?["0"])!,
                   "contact_phone":(self.postParam?["1"])!,
                   "add_province":((self.currentArea?["1"] as! NSDictionary)["name"] as! String),
                   "add_city":((self.currentArea?["2"] as! NSDictionary)["name"] as! String),
                   "add_area":((self.currentArea?["3"] as! NSDictionary)["name"] as! String),
                   "address":(self.currentPlace?.allKeys[0] as! String),
                   "longitude":String((self.currentPlace?.allValues[0] as! CLLocationCoordinate2D).longitude),
                   "latitude":String((self.currentPlace?.allValues[0] as! CLLocationCoordinate2D).latitude),
                   "is_default":"0",
                   "user_id":UserModel.shareInstance.userId]
        var url = "/user_address_add"
        if self.editPlace != nil {
            dic = ["consignee":(self.postParam?["0"])!,
                   "contact_phone":(self.postParam?["1"])!,
                   "add_province":((self.currentArea?["1"] as! NSDictionary)["name"] as! String),
                   "add_city":((self.currentArea?["2"] as! NSDictionary)["name"] as! String),
                   "add_area":((self.currentArea?["3"] as! NSDictionary)["name"] as! String),
                   "address":(self.currentPlace?.allKeys[0] as! String),
                   "longitude":String((self.currentPlace?.allValues[0] as! CLLocationCoordinate2D).longitude),
                   "latitude":String((self.currentPlace?.allValues[0] as! CLLocationCoordinate2D).latitude),
                   "is_default":"0",
                   "user_id":UserModel.shareInstance.userId,
                   "addre_id":(self.editPlace?["addre_id"] as! String)]
            url = "/user_address_edit"
        }
        NetworkModel.request(dic as NSDictionary, url: url) { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }

}
