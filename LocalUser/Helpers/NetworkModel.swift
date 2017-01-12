//
//  NetworkModel.swift
//  ACL
//
//  Created by YunTu on 2016/12/6.
//  Copyright © 2016年 work. All rights reserved.
//

import Foundation
import YTKNetwork
import SVProgressHUD

class NetworkModel: YTKRequest {
    
    var _requestParam:NSDictionary = [:]
    var _url:String = ""
    var _requestMethod:YTKRequestMethod = .POST
    var _requestType:YTKRequestSerializerType = .HTTP
    
    init(with param:NSDictionary?, url:String, requestMethod:YTKRequestMethod, requestType:YTKRequestSerializerType){
        super.init()
        _requestParam = param!
        _url = url
        _requestMethod = requestMethod
        _requestType = requestType
    }
    
    override func requestUrl() -> String {
        return _url
    }
    
    override func requestArgument() -> Any? {
        let tempParam = NSMutableDictionary(dictionary: _requestParam)
        tempParam.setValue("f74dd39951a0b6bbed0fe73606ea5476", forKey: "apikey")
        tempParam.setValue("1.1", forKey: "version")
        tempParam.setValue("ios", forKey: "terminal")
        return tempParam
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return _requestMethod
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return _requestType
    }
    
    public class func request(_ param:NSDictionary, url:String, complete: ((_ responseObject:Any) -> Void)?){
        let reqUrl = "http://cdelivery.cq1b1.com/api.php/index" + url
        var req = URLRequest(url: URL(string: reqUrl)!)
        let tempParam = NSMutableDictionary(dictionary: param)
        tempParam.setValue("f74dd39951a0b6bbed0fe73606ea5476", forKey: "apikey")
        tempParam.setValue("1.1", forKey: "version")
        tempParam.setValue("ios", forKey: "terminal")
        
        var body = ""
        for key in tempParam.allKeys {
            body = body + (key as! String) + "=" + (tempParam[(key as! String)] as! String)
            body = body + "&"
        }
        body = body.substring(to: body.index(body.endIndex, offsetBy: -1))
        print(body)
        let bodyData = body.data(using: .utf8)
        req.httpBody = bodyData
        req.httpMethod = "POST"
        NSURLConnection.sendAsynchronousRequest(req, queue: OperationQueue(), completionHandler: {
            (_ response:URLResponse?, data:Data?, error:Error?) -> Void in
            if error == nil {
                DispatchQueue.main.async(execute: {
                    do {
                        let dic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                        if complete != nil {
                            complete!(dic)
                        }
                    }catch{
                        
                    }
                })
            }else{
                print(error!)
                SVProgressHUD.dismiss()
            }
        })
        
    
    }
    
    public class func requestThirdLogin(_ param:NSDictionary, url:String, complete: ((_ responseObject:Any) -> Void)?){
        let reqUrl = url
        let req = URLRequest(url: URL(string: reqUrl)!)
//        let tempParam = NSMutableDictionary(dictionary: param)
//        tempParam.setValue("f74dd39951a0b6bbed0fe73606ea5476", forKey: "apikey")
//        tempParam.setValue("1.1", forKey: "version")
//        tempParam.setValue("ios", forKey: "terminal")
        
//        var body = ""
//        for key in tempParam.allKeys {
//            body = body + (key as! String) + "=" + (tempParam[(key as! String)] as! String)
//            body = body + "&"
//        }
//        body = body.substring(to: body.index(body.endIndex, offsetBy: -1))
//        print(body)
//        let bodyData = body.data(using: .utf8)
//        req.httpBody = bodyData
//        req.httpMethod = "POST"
        NSURLConnection.sendAsynchronousRequest(req, queue: OperationQueue(), completionHandler: {
            (_ response:URLResponse?, data:Data?, error:Error?) -> Void in
            if error == nil {
                DispatchQueue.main.async(execute: {
                    do {
                        let dic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                        if complete != nil {
                            complete!(dic)
                        }
                    }catch{
                        
                    }
                })
            }else{
                print(error!)
                SVProgressHUD.dismiss()
            }
        })
        
        
    }
}
