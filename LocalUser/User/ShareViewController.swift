//
//  ShareViewController.swift
//  LocalUser
//
//  Created by YunTu on 2017/1/3.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {

    @IBOutlet weak var moreShareBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "分享有礼"
        self.moreShareBtn.layer.cornerRadius = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func wxShareBtnDidClick(_ sender: Any) {
        let message = WXMediaMessage()
        message.title = "测试"
        message.description = "测试的啦"
        message.setThumbImage(UIImage(named: "icon-logo"))
        
        let ext = WXWebpageObject()
        ext.webpageUrl = "http://www.baidu.com"
        
        message.mediaObject = ext
        
        let req = SendMessageToWXReq.init()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneSession.rawValue)
        
        WXApi.send(req)
    }
    
    @IBAction func friendShareBtnDidClick(_ sender: Any) {
        let message = WXMediaMessage()
        message.title = "测试"
        message.description = "测试的啦"
        message.setThumbImage(UIImage(named: "icon-logo"))
        
        let ext = WXWebpageObject()
        ext.webpageUrl = "http://www.baidu.com"
        
        message.mediaObject = ext
        
        let req = SendMessageToWXReq.init()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneTimeline.rawValue)
        
        WXApi.send(req)
    }
    
    @IBAction func shortMsgShareBtnDidClick(_ sender: Any) {
        
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
