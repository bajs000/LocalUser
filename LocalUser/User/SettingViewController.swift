//
//  SettingViewController.swift
//  LocalUser
//
//  Created by YunTu on 2017/1/3.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {

    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBAction func logoutBtnDidClick(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "MNIQUE")
        UserDefaults.standard.synchronize()
        UserModel.shareInstance.logout()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        self.logoutBtn.layer.cornerRadius = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
