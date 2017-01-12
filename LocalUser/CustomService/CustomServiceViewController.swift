//
//  CustomServiceViewController.swift
//  LocalUser
//
//  Created by YunTu on 2016/12/29.
//  Copyright © 2016年 果儿. All rights reserved.
//

import UIKit

class CustomServiceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commitOrderBtn: UIButton!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    
    var textView:UITextView?
    var placeholder:UILabel?
    var buyPlaceDic:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "定制服务"
        self.commitOrderBtn.layer.cornerRadius = 16
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardShow(_ notification:Notification) -> Void {
        let keyboardRect:CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.tableViewBottom.constant = keyboardRect.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardHide(_ notification:Notification) -> Void {
        UIView.animate(withDuration: 0.75, animations: ({
            self.tableViewBottom.constant = 49
            self.view.layoutIfNeeded()
        }), completion: {(_ finish:Bool) -> Void in
            
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = "headerCell"
        if indexPath.section == 1 {
            cellIdentify = "placeCell"
        }else if indexPath.section == 2 {
            cellIdentify = "detailCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.section == 0 {
            textView = cell.viewWithTag(1) as? UITextView
            textView?.delegate = self
            placeholder = cell.viewWithTag(2) as? UILabel
        }else if indexPath.section == 1 {
            if self.buyPlaceDic != nil {
                (cell.viewWithTag(11) as! UILabel).text = self.buyPlaceDic?.allKeys[0] as? String
                (cell.viewWithTag(11) as! UILabel).textColor = UIColor.colorWithHexString(hex: "333333")
            }else {
                (cell.viewWithTag(11) as! UILabel).textColor = UIColor.colorWithHexString(hex: "CCCCCC")
            }
        }
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 0 {
            placeholder?.isHidden = true
        }else{
            placeholder?.isHidden = false
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationPush" {
            let vc = segue.destination as! MapLocationViewController
            vc.completeChoseLocation = {(_ locationName:String, location:CLLocationCoordinate2D) -> Void in
                self.buyPlaceDic = [locationName:location]
                self.tableView.reloadData()
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
