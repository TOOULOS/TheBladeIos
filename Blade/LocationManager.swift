//
//  LocationManager.swift
//  MaidFinder
//
//  Created by Mac_Mini17 on 27/11/19.
//  Copyright © 2019 Mac_Mini17. All rights reserved.
//

/*
 
 firstname
 lastname
 dob
 streetname
 city
 state
 country
 zipcode
 mobile number
 country code
 email
 password
 subscribetonewsletter
 */
import UIKit
import CoreLocation
var objLocationData = LocationData()
class LocationData{
    
    var currentLat  : Double?
    var currentLong : Double?
    var location   : String?
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance: LocationManager = {
        let instance = LocationManager()
        // setup code
        return instance
    }()
    
   var locationManager:CLLocationManager!
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.requestAlwaysAuthorization()
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
                //locationManager.startUpdatingHeading()
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        debugPrint("user latitude = \(userLocation.coordinate.latitude)")
        debugPrint("user longitude = \(userLocation.coordinate.longitude)")
        
        objLocationData.currentLat = userLocation.coordinate.latitude
        objLocationData.currentLong = userLocation.coordinate.longitude
        let address = CLGeocoder.init()
            address.reverseGeocodeLocation(CLLocation.init(latitude: userLocation.coordinate.latitude, longitude:userLocation.coordinate.longitude)) { (places, error) in
                if error == nil{
                    if let place = places{
                        
                        if place.count > 0 {
                            let pm = place[0]
                            var addressString : String = ""
                            if pm.subLocality != nil {
                                addressString = addressString + pm.subLocality! + ", "
                            }
                            if pm.thoroughfare != nil {
                                addressString = addressString + pm.thoroughfare! + ", "
                            }
                            var city = ""
                            
                            if pm.locality != nil {
                                city = pm.locality!
                            } else if pm.subLocality != nil {
                                city = pm.subLocality!
                            } else if pm.country != nil {
                                city =  pm.country!
                            }
                            if pm.postalCode != nil {
                                addressString = addressString + pm.postalCode! + " "
                            }

                            objLocationData.location = city
                            print(addressString)
                      }
                        
                        //here you can get all the info by combining that you can make address
                    }
                }
            }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            // The user denied authorization
        } else if (status == CLAuthorizationStatus.authorizedAlways) || (status == CLAuthorizationStatus.authorizedWhenInUse) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                NotificationCenter.default.post(name: Notification.Name("UpdateLocation"), object: nil)
            }
            
            
            // The user accepted authorization
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}
