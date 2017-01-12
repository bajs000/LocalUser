//
//  MapLocationViewController.swift
//  LocalUser
//
//  Created by YunTu on 2016/12/28.
//  Copyright © 2016年 果儿. All rights reserved.
//

import UIKit

class MapLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BMKMapViewDelegate, BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: BMKMapView!
    
    var locService: BMKLocationService?
    var geoCodeSearch: BMKGeoCodeSearch?
    var poiArr: NSArray?
    var count = 0
    var completeChoseLocation:((String,CLLocationCoordinate2D) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.locService = BMKLocationService.init()
        self.locService?.delegate = self
        self.geoCodeSearch = BMKGeoCodeSearch.init()
        self.geoCodeSearch?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if poiArr == nil {
            return 0
        }
        return (poiArr?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = (poiArr?[indexPath.row] as! BMKPoiInfo).name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let poiInfo = poiArr?[indexPath.row] as! BMKPoiInfo
        self.completeChoseLocation!(poiInfo.name,poiInfo.pt)
        _ = self.navigationController?.popViewController(animated: true)
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
        count = count + 1
        if count <= 1 {
            self.mapView.setCenter(userLocation.location.coordinate, animated: true)
            self.mapView.setRegion(BMKCoordinateRegionMake(userLocation.location.coordinate, BMKCoordinateSpanMake(0.05, 0.05)), animated: true)
            self.locService?.stopUserLocationService()
            self.startGeocodeSearch(userLocation.location.coordinate)
        }
    }

    func startGeocodeSearch(_ coordinate:CLLocationCoordinate2D){
        self.mapView.removeAnnotations(self.mapView.annotations)
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
            poiArr = result.poiList as NSArray
            self.tableView.reloadData()
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
