//
//  AppDelegate.swift
//  LocalUser
//
//  Created by 果儿 on 16/12/15.
//  Copyright © 2016年 果儿. All rights reserved.
//

import UIKit
import YTKNetwork
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate, WXApiDelegate {

    var window: UIWindow?
    var _mapManager: BMKMapManager?
    let kWXAPP_ID = "wx6b2dd79bee84b937"
    let kWXAPP_SECRET = "1222d0f8f4667a1c2bcf8d7323fe921b"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        WXApi.registerApp(kWXAPP_ID)
        WXApi.registerAppSupportContentFlag(8191)
        YTKNetworkConfig.shared().baseUrl = "http://cdelivery.cq1b1.com/api.php/index"
        // 要使用百度地图，请先启动BaiduMapManager
        _mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start("KcOWhNdn3odwTFsf6k1bccHCIoQecELs", generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }

    func onResp(_ resp: BaseResp!) {
        if resp.isKind(of: SendAuthResp.self) {
            SVProgressHUD.show()
            var url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=" + kWXAPP_ID + "&secret=" + kWXAPP_SECRET + "&code=" + (resp as! SendAuthResp).code + "&grant_type=authorization_code"
            NetworkModel.requestThirdLogin([:], url: url, complete: { (dic) in
                url = "https://api.weixin.qq.com/sns/userinfo?access_token=" + ((dic as! NSDictionary)["access_token"] as! String) + "&openid=" + ((dic as! NSDictionary)["openid"] as! String)
                print(url)
                NetworkModel.requestThirdLogin([:], url: url, complete: { (dic) in
                    NetworkModel.request(["openid":((dic as! NSDictionary)["openid"] as! String),"category":"wx","head_graphic":((dic as! NSDictionary)["headimgurl"] as! String)], url: "/logo", complete: { (dic) in
                        if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                            SVProgressHUD.dismiss()
                            UserDefaults.standard.set((dic as! NSDictionary)["user_id"], forKey: "USERID")
                            UserDefaults.standard.set((dic as! NSDictionary)["mnique"], forKey: "MNIQUE")
                            UserDefaults.standard.synchronize()
                            let nav = self.window?.rootViewController as! UINavigationController
                            nav.popViewController(animated: true)
                        }else{
                            SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
                        }
                    })
                })
            })
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: - BMKGeneralDelegate
    func onGetNetworkState(_ iError: Int32) {
        if (0 == iError) {
            NSLog("联网成功");
        }
        else{
            NSLog("联网失败，错误代码：Error\(iError)");
        }
    }
    
    func onGetPermissionState(_ iError: Int32) {
        if (0 == iError) {
            NSLog("授权成功");
        }
        else{
            NSLog("授权失败，错误代码：Error\(iError)");
        }
    }
}

