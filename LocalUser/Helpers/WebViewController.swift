//
//  WebViewController.swift
//  LocalUser
//
//  Created by YunTu on 2017/1/5.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit
import SVProgressHUD

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var url:String?
    var html:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if url != nil {
            let req = NSURLRequest(url: NSURL(string: self.url!) as! URL)
            self.webView.loadRequest(req as URLRequest)
        }else{
            self.webView.loadHTMLString(html!, baseURL: nil)
        }
        SVProgressHUD.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    
    public class func getInstance() -> WebViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "web")
        return vc as! WebViewController
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
