//
//  CustumMapView.swift
//  Piing Swift
//
//  Created by Veedepu Srikanth on 28/12/17.
//  Copyright © 2017 Piing. All rights reserved.
//

import Foundation
import GoogleMaps

class CustomMapView: UIView {
    
    var mapView = GMSMapView()
    var markersArray = [GMSMarker]()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let camera = GMSCameraPosition.camera(withLatitude: AppDelegate.latitude, longitude: AppDelegate.longitude, zoom: 15.0, bearing: 270, viewingAngle: 0)
        
        mapView = GMSMapView.map(withFrame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height), camera: camera)
        mapView.autoresizingMask = .flexibleHeight
                
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: AppDelegate.MAP_STYLE, withExtension: AppDelegate.MAP_STYLE_TYPE) {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        self.addSubview(mapView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func animateMapView() {
        
        mapView.animate(toZoom: 16)
        
        //        let target = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        //
        //        UIView.animate(withDuration: 5.6, delay: 0.0, options: .curveEaseInOut, animations: {
        //
        //            self.mapView.camera = GMSCameraPosition.camera(withTarget: target, zoom: 16)
        //
        //        }) { (success) in
        //
        //        }
    }
    
    func showCustomerMarkerOnTheMap(with addressModel: AddressModel) {
        
        let customMarker = GMSMarker()
        customMarker.icon = UIImage.init(named: "home_map_icon")
        customMarker.appearAnimation = .pop
        
        let latitude = Double(addressModel.lat!)!
        let longitude = Double(addressModel.lon!)!
        
        customMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        customMarker.map = self.mapView
        
        markersArray.removeAll()
        markersArray.append(customMarker)
    }
    
    
    func showCustomerMarkerOnTheMap(with latitude: Double, longitude: Double) {
        
        let customMarker = GMSMarker()
        //customMarker.icon = UIImage.init(named: "home_map_icon")
        customMarker.appearAnimation = .pop
        
        customMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        customMarker.map = self.mapView
        
        markersArray.removeAll()
        markersArray.append(customMarker)
    }
    
    func showMultipleMarkersOnTheMap(with addressModel: AddressModel) {
        
        let customMarker = GMSMarker()
        customMarker.icon = UIImage.init(named: "home_map_icon")
        customMarker.appearAnimation = .pop
        
        let latitude = Double(addressModel.lat!)!
        let longitude = Double(addressModel.lon!)!
        
        customMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        customMarker.map = self.mapView
        
        for marker in markersArray {
            if marker.position.latitude != customMarker.position.latitude {
                markersArray.append(customMarker)
                break
            }
        }
        
        if markersArray.count == 0 {
            markersArray.append(customMarker)
        }
    }
    
    func focusMapToShowAllMarkers() {
        
//        let path = GMSMutablePath.init()
//
//        for marker in markersArray {
//
//            path.add(marker.position)
//        }
//
//        let bounds = GMSCoordinateBounds.init(path: path)
//        mapView.animate(with: GMSCameraUpdate.fit(bounds))
        
        
        var bounds = GMSCoordinateBounds()
        
        for marker in markersArray {
            bounds = bounds.includingCoordinate(marker.position)
        }
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
        mapView.animate(with: update)
        
        if markersArray.count == 1 {
            mapView.animate(toZoom: 16)
        }
    }
    
    func scrollByY(y:CGFloat) {
        mapView.animate(with: GMSCameraUpdate.scrollBy(x: 0, y: y))
    }
    
    func clearAllMarkers() {
        
        for marker in markersArray {
            marker.map = nil
        }
        
        mapView.clear()
        markersArray.removeAll()
        //mapView.animate(toZoom: 16)
    }
}
