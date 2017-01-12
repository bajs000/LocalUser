//
//  MapCell.swift
//  LocalUser
//
//  Created by 果儿 on 17/1/5.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit

class MapCell: UITableViewCell, BMKMapViewDelegate {

    @IBOutlet weak var mapView: BMKMapView!
    var orderInfo:NSDictionary?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mapView.delegate = self
    }

    func mapViewDidFinishLoading(_ mapView: BMKMapView!) {
        if self.orderInfo != nil {
            let pin = BMKPointAnnotation.init()
            pin.coordinate = CLLocationCoordinate2DMake(Double(self.orderInfo?["latitude"] as! String)!, Double(self.orderInfo?["longitude"] as! String)!)
            self.mapView.addAnnotation(pin)
            self.mapView.setCenter(pin.coordinate, animated: true)
            self.mapView.setRegion(BMKCoordinateRegionMake(pin.coordinate, BMKCoordinateSpanMake(0.05, 0.05)), animated: true)
        }
    }
    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation.isKind(of: BMKPointAnnotation.self) {
            let pin = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pin?.image = UIImage(named: "order-location")
            pin?.animatesDrop = true
            return pin
        }
        return nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
