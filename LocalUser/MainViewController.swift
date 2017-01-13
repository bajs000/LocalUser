//
//  ViewController.swift
//  LocalUser
//
//  Created by 果儿 on 16/12/15.
//  Copyright © 2016年 果儿. All rights reserved.
//

import UIKit
import Masonry
import SVProgressHUD
import SDWebImage

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, BMKMapViewDelegate, BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate {

    @IBOutlet weak var mapView: BMKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bubbleBg: UIImageView!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var bubbleView:UIView!
    @IBOutlet weak var bubbleViewWidth: NSLayoutConstraint!
    @IBOutlet weak var bubbleViewHeight: NSLayoutConstraint!
    @IBOutlet var userView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewLeading: NSLayoutConstraint!
    @IBOutlet weak var avatarBg: UIView!
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var avatarIcon: UIImageView!
    @IBOutlet weak var userNameBtn: UIButton!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var locService:BMKLocationService?
    var geoCodeSearch:BMKGeoCodeSearch?
    var userTitleList:[String:[[String:String]]]?
    var bannerDatasource:[NSDictionary] = [NSDictionary]()
    
    @IBAction func userInfoBtnDidClick(_ sender: Any) {
        if UserDefaults.standard.object(forKey: "MNIQUE") != nil {
            self.navigationController?.view.addSubview(self.userView)
            self.userView.mas_makeConstraints { (make) in
                _ = make?.top.equalTo()(self.navigationController?.view.mas_top)
                _ = make?.left.equalTo()(self.navigationController?.view.mas_left)
                _ = make?.bottom.equalTo()(self.navigationController?.view.mas_bottom)
                _ = make?.right.equalTo()(self.navigationController?.view.mas_right)
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.tableViewLeading.constant = 0
                self.userView.layoutIfNeeded()
            }, completion: {(_ finish:Bool) -> Void in
            })
        }else{
            self.performSegue(withIdentifier: "loginPush", sender: sender)
        }
    }
    
    @IBAction func dimissUserCenter(_ sender: Any) {
        self.dismissUserCenter(nil)
    }
    
    @IBAction func msgBtnDidClick(_ sender: Any) {
        
    }
    
    func dismissUserCenter(_ completion:(() -> Void)?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.tableViewLeading.constant = -(UIScreen.main.bounds.size.width - 35)
            self.userView.layoutIfNeeded()
        }, completion: {(_ finish:Bool) -> Void in
            if self.userView.superview != nil {
                self.userView.removeFromSuperview()
            }
            if completion != nil {
                completion!()
            }
        })
    }
    
    @IBAction func sureAddressBtnDidClick(_ sender: UIButton) {
        let alert = Bundle.main.loadNibNamed("CustomAlert", owner: nil, options: nil)![0] as! CustomAlert
        alert.showAlert(self.cityBtn.currentTitle! + self.addressLabel.text!, block: {(_ tag:Int) -> Void in
            print(tag)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if UserDefaults.standard.object(forKey: "MNIQUE") != nil {
            SVProgressHUD.show()
            NetworkModel.request(["mnique":UserDefaults.standard.object(forKey: "MNIQUE") as! String], url: "/user_info") { (dic) in
                SVProgressHUD.dismiss()
                let dict = dic as! NSDictionary
                let userDefault = UserDefaults.standard
                if Int(dict["code"] as! String) == 200 {
                    UserModel.shareInstance.logout()
                    if !(((dict["info"] as! NSDictionary)["for_address"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["info"] as! NSDictionary)["for_address"] as! String).characters.count > 0{
                        userDefault.set(((dict["info"] as! NSDictionary)["for_address"] as! String), forKey: "ADDRESS")
                    }
                    if !(((dict["info"] as! NSDictionary)["gender"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["info"] as! NSDictionary)["gender"] as! String).characters.count > 0{
                        userDefault.set(((dict["info"] as! NSDictionary)["gender"] as! String), forKey: "GENDER")
                    }
                    if !(((dict["info"] as! NSDictionary)["head_graphic"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["info"] as! NSDictionary)["head_graphic"] as! String).characters.count > 0{
                        userDefault.set(((dict["info"] as! NSDictionary)["head_graphic"] as! String), forKey: "AVATAR")
                    }
                    if !(((dict["info"] as! NSDictionary)["is_bess"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["info"] as! NSDictionary)["is_bess"] as! String).characters.count > 0{
                        userDefault.set(((dict["info"] as! NSDictionary)["is_bess"] as! String), forKey: "BESS")
                    }
                    if !(((dict["info"] as! NSDictionary)["mnique"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["info"] as! NSDictionary)["mnique"] as! String).characters.count > 0{
                        userDefault.set(((dict["info"] as! NSDictionary)["mnique"] as! String), forKey: "MNIQUE")
                    }
                    if !(((dict["info"] as! NSDictionary)["money"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["info"] as! NSDictionary)["money"] as! String).characters.count > 0{
                        userDefault.set(((dict["info"] as! NSDictionary)["money"] as! String), forKey: "MONEY")
                    }
                    if !(((dict["info"] as! NSDictionary)["user_id"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["info"] as! NSDictionary)["user_id"] as! String).characters.count > 0{
                        userDefault.set(((dict["info"] as! NSDictionary)["user_id"] as! String), forKey: "USERID")
                    }
                    if !(((dict["info"] as! NSDictionary)["user_name"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["info"] as! NSDictionary)["user_name"] as! String).characters.count > 0{
                        userDefault.set(((dict["info"] as! NSDictionary)["user_name"] as! String), forKey: "USERNAME")
                    }
                    if !(((dict["info"] as! NSDictionary)["user_phone"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["info"] as! NSDictionary)["user_phone"] as! String).characters.count > 0{
                        userDefault.set(((dict["info"] as! NSDictionary)["user_phone"] as! String), forKey: "USERPHONE")
                    }
                    userDefault.synchronize()
                    self.avatarIcon.sd_setImage(with: URL(string: UserModel.shareInstance.avatar), placeholderImage: UIImage(named: "main-user-default-icon"))
                    self.userNameBtn.setTitle(UserModel.shareInstance.userName, for: .normal)
//                    self.avatarBtn.sd_setImage(with: URL(string: UserModel.shareInstance.avatar), for: .normal, placeholderImage: UIImage(named: "main-user-bg"))
                }else{
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView.init(image: UIImage(named: "main-title-img"))
        self.mapView.delegate = self
        self.locService = BMKLocationService.init()
        self.locService?.delegate = self
        self.geoCodeSearch = BMKGeoCodeSearch.init()
        self.geoCodeSearch?.delegate = self
        self.bubbleView.isHidden = true
        self.tableViewLeading.constant = -(UIScreen.main.bounds.size.width - 35)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.avatarBg.layer.cornerRadius = self.avatarBg.frame.width / 2
        self.avatarIcon.layer.cornerRadius = 28.5
        self.collectionViewHeight.constant = 0
        self.view.layoutIfNeeded()
        
        userTitleList = ["0":[["title":""]],
                         "1":[["title":"历史订单","detail":"","icon":"main-user-gift"]],
                         "2":[["title":"分享有礼","detail":"","icon":"main-user-gift"]],
                         "3":[["title":"我的账户","detail":"编辑地址、设置收货款账户","icon":"main-user-account"],["title":"我的钱包","detail":"余额查询及优惠券","icon":"other-price"]],
                         "4":[["title":"消息通知","detail":"","icon":"main-user-msg"],["title":"使用通知","detail":"常见问题","icon":"other-notice"]],
                         "5":[["title":"联系客服","detail":"","icon":"main-user-service"],["title":"设置","detail":"","icon":"main-user-setting"]]]
//        self.bubbleBg.image = self.bubbleBg.image?.resizableImage(withCapInsets: UIEdgeInsetsMake(2, 80, 6, 2))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bannerDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let dic = self.bannerDatasource[indexPath.row]
        (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["bigpic"] as! String)))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UICollectionView.self){
            pageControl.currentPage = Int(Int(scrollView.contentOffset.x) / Int(self.collectionView.frame.width))
        }
    }
    
    func mapView(_ mapView: BMKMapView!, regionDidChangeAnimated animated: Bool) {
        self.startGeocodeSearch(mapView.centerCoordinate)
    }
    
    func mapViewDidFinishLoading(_ mapView: BMKMapView!) {
        self.locService?.startUserLocationService()
        self.mapView.showsUserLocation = false
        self.mapView.userTrackingMode = BMKUserTrackingModeNone
        self.mapView.showsUserLocation = true
    }

    func didUpdate(_ userLocation: BMKUserLocation!) {
        self.mapView.updateLocationData(userLocation)
        DispatchQueue.once(token: "OnceLocation", block: {
            print("lat:" + String(userLocation.location.coordinate.latitude) + "lng:" + String(userLocation.location.coordinate.longitude))
            self.mapView.setCenter(userLocation.location.coordinate, animated: true)
            self.mapView.setRegion(BMKCoordinateRegionMake(userLocation.location.coordinate, BMKCoordinateSpanMake(0.05, 0.05)), animated: true)
            self.locService?.stopUserLocationService()
            self.startGeocodeSearch(userLocation.location.coordinate)
            self.requestBannerData(userLocation.location.coordinate)
        })
    }
    
    func startGeocodeSearch(_ coordinate:CLLocationCoordinate2D){
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.bubbleView.isHidden = true
        let reverseGeocodeSearchOption = BMKReverseGeoCodeOption.init()
        reverseGeocodeSearchOption.reverseGeoPoint = coordinate
        let flag = self.geoCodeSearch?.reverseGeoCode(reverseGeocodeSearchOption)
        if flag! {
//            print("反geo检索发送成功")
        }else {
            print("反geo检索发送失败")
        }
    }
    
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            let maxSize = CGSize(width: UIScreen.main.bounds.size.width - 40, height: Helpers.screanSize().height / 5)
            let citySize = (("  " + result.addressDetail.city + "  ") as NSString).boundingRect(with: maxSize, options: [.usesLineFragmentOrigin , .usesFontLeading , .truncatesLastVisibleLine], attributes: [NSFontAttributeName:self.addressLabel.font], context: nil).size
            let addressSize = (result.address as NSString).boundingRect(with: CGSize(width: maxSize.width - citySize.width - 8 - 8 - 5 - 10, height: maxSize.height), options: [.usesLineFragmentOrigin , .usesFontLeading , .truncatesLastVisibleLine], attributes: [NSFontAttributeName:self.addressLabel.font], context: nil).size
            let newSize = CGSize(width: addressSize.width, height: addressSize.height + citySize.height)
            self.bubbleViewWidth.constant = newSize.width + 82
            self.bubbleViewHeight.constant = max(newSize.height, 40)
            
            self.mapView.centerCoordinate = result.location
            self.bubbleView.isHidden = false
            self.addressLabel.text = result.address
            self.cityBtn.setTitle("  " + result.addressDetail.city + "  ", for: .normal)
        }
    }
    
    func didFailToLocateUserWithError(_ error: Error!) {
        print(error)
    }
    
    //MARK:- UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section <= 2 {
            return 1
        }else{
            return 2
        }
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
        var cellIdentify = ""
        if indexPath.section == 0 {
            cellIdentify = "orderCell"
        }else{
            cellIdentify = "Cell"
        }
        let arr = self.userTitleList?[String(indexPath.section)]
        let dic = arr?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.section > 0 {
            (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: (dic?["icon"])!)
            (cell.viewWithTag(2) as! UILabel).text = dic?["title"]
            (cell.viewWithTag(3) as! UILabel).text = dic?["detail"]
            if indexPath.row % 2 == 1{
                cell.viewWithTag(4)?.isHidden = true
            }else{
                if arr?.count == 1 {
                    cell.viewWithTag(4)?.isHidden = true
                }else{
                    cell.viewWithTag(4)?.isHidden = false
                }
            }
        }else{
            for i in 12...14{
                (cell.viewWithTag(i) as! UIButton).addTarget(self, action: #selector(orderStateBtnDidClick(_:)), for: .touchUpInside)
            
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.dismissUserCenter {
            if indexPath.section == 4{
                if indexPath.row == 0 {
                    self.performSegue(withIdentifier: "msgPush", sender: indexPath)
                }else{
                    self.performSegue(withIdentifier: "usePush", sender: indexPath)
                }
            }else if indexPath.section == 3 {
                if indexPath.row == 0 {
                    self.performSegue(withIdentifier: "accountPush", sender: indexPath)
                }else{
                    self.performSegue(withIdentifier: "walletPush", sender: indexPath)
                }
            }else if indexPath.section == 5 {
                if indexPath.row == 0 {
                
                }else{
                    self.performSegue(withIdentifier: "settingPush", sender: indexPath)
                }
            }else if indexPath.section == 2 {
                self.performSegue(withIdentifier: "sharePush", sender: indexPath)
            }else if indexPath.section == 0 {
                self.performSegue(withIdentifier: "orderPush", sender: nil)
            }else if indexPath.section == 1 {
                self.performSegue(withIdentifier: "historyPush", sender: indexPath)
            }
        }
    }
    
    func orderStateBtnDidClick(_ sender:UIButton) -> Void {
        self.dismissUserCenter {
            self.performSegue(withIdentifier: "orderPush", sender: sender)
        }
    }
        
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderPush" {
            if sender != nil {
                let vc = segue.destination as! OrderListViewController
                vc.currentSelectTag = (sender as! UIButton).tag - 10
            }
        }
    }
    
    func requestBannerData(_ coordinate:CLLocationCoordinate2D) {
        NetworkModel.request(["longitude":String(coordinate.longitude),"latitude":String(coordinate.latitude)], url: "") { (dic) in
            self.bannerDatasource = (dic as! NSDictionary)["banner_list"] as! [NSDictionary]
            if self.bannerDatasource.count > 0 {
                self.pageControl.numberOfPages = self.bannerDatasource.count
                UIView.animate(withDuration: 0.5, animations: { 
                    self.collectionViewHeight.constant = 100
                    self.view.layoutIfNeeded()
                })
            }
            self.collectionView.reloadData()
        }
    }
}

