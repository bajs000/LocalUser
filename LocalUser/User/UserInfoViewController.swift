//
//  UserInfoViewController.swift
//  LocalUser
//
//  Created by YunTu on 2016/12/30.
//  Copyright © 2016年 果儿. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class UserInfoViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var titleArr:[[String:String]]?
    var avatar:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.title = "我的账户"
        let user = UserModel.shareInstance
        self.titleArr = [["title":"头像","detail":user.avatar],
                         ["title":"商家名","detail":user.userName],
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
            if avatar != nil {
                (cell.viewWithTag(2) as! UIImageView).image = avatar
            }else{
                (cell.viewWithTag(2) as! UIImageView).sd_setImage(with: URL(string: UserModel.shareInstance.avatar), placeholderImage: UIImage(named: "main-user-default-icon"))
            }
        }else{
            (cell.viewWithTag(2) as! UILabel).text = titleArr?[indexPath.row]["detail"]
            if indexPath.row == 4 {
                if ((cell.viewWithTag(2) as! UILabel).text?.characters.count)! > 7 {
                    (cell.viewWithTag(2) as! UILabel).text = ((cell.viewWithTag(2) as! UILabel).text! as NSString).replacingCharacters(in: NSMakeRange(3, 4), with: "****")
                }
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 5 {
            self.performSegue(withIdentifier: "accountPush", sender: indexPath)
        }else if indexPath.row == 0 {
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "相机", style: .default, handler: { (alertAction) in
                let imgPicker = UIImagePickerController.init()
                imgPicker.sourceType = .camera
                imgPicker.delegate = self
                imgPicker.allowsEditing = true
                self.present(imgPicker, animated: true, completion: nil)
            })
            let photoAction = UIAlertAction(title: "相册", style: .default, handler: { (alertAction) in
                let imgPicker = UIImagePickerController.init()
                imgPicker.sourceType = .savedPhotosAlbum
                imgPicker.delegate = self
                imgPicker.allowsEditing = true
                self.present(imgPicker, animated: true, completion: nil)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (alertAction) in
                
            })
            sheet.addAction(cameraAction)
            sheet.addAction(photoAction)
            sheet.addAction(cancelAction)
            self.present(sheet, animated: true, completion: nil)
        }else if indexPath.row == 2 {
            self.performSegue(withIdentifier: "placePush", sender: indexPath)
        }else if indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 4 {
            self.performSegue(withIdentifier: "updatePush", sender: indexPath)
        }
    }
    
    // MARK: - UIImagePickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.requestUploadAvatar(info[UIImagePickerControllerOriginalImage] as! UIImage)
        avatar = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        self.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func requestUploadAvatar(_ image:UIImage) {
        SVProgressHUD.show()
        UploadNetwork.request(["mnique":UserModel.shareInstance.mnique], data: image,paramName: "head_graphic", url: "/user_edit") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UPDATEINFO"), object: nil)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updatePush" {
            let vc = segue.destination as! UpdateViewController
            if (sender as! IndexPath).row == 1 {
                vc.title = "商户名"
                vc.type = .name
            }else if (sender as! IndexPath).row == 3 {
                vc.title = "修改密码"
                vc.type = .password
            }else if (sender as! IndexPath).row == 4 {
                vc.title = "修改手机"
                vc.type = .phone
            }
        }
    }
    

}
