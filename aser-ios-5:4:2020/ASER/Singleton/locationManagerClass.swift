//
//  AppDelegate.swift
/**
 *
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author     : Shiv Charan Panjeta < shiv@toxsl.com >
 *
 * All Rights Reserved.
 * Proprietary and confidential :  All information contained herein is, and remains
 * the property of ToXSL Technologies Pvt. Ltd. and its partners.
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 */
import UIKit
import CoreMotion
import CoreLocation
import Alamofire
//GLOBAL DECLARATION OF LOCATION VARIABLES
var locationUpdates = Bool()
var locationShareInstance:locationManagerClass = locationManagerClass()
class locationManagerClass: NSObject, CLLocationManagerDelegate , UIAlertViewDelegate {
// MARK: - Class Variables
    var locationManager = CLLocationManager()
    
    class func sharedLocationManager() -> locationManagerClass  {
        locationShareInstance = locationManagerClass()
        return locationShareInstance
    }
    
    var timer = Timer()
    func startStandardUpdates() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation
        locationManager.distanceFilter = 10
        // meters
        locationManager.pausesLocationUpdatesAutomatically = false
        
        
        if (Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil) {
            locationManager.requestWhenInUseAuthorization()
                   }
        locationUpdates = true

        locationManager.startUpdatingLocation()
        if #available(iOS 9.0, *) {
            
            locationManager.allowsBackgroundLocationUpdates  = false
        } else {
            // Fallback on earlier versions
        }
//        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(locationManagerClass.updateLocationToServer), userInfo: nil, repeats: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // If it's a relatively recent event, turn off updates to save power.
        let location: CLLocation = locations.last!
        UserDefaults.standard.set("\(location.coordinate.latitude)", forKey: "lat")
        UserDefaults.standard.set("\(location.coordinate.longitude)", forKey: "long")
        UserDefaults.standard.synchronize()
      
    }
    
    func stopStandardUpdate(){
        DispatchQueue.main.async  {
            self.timer.invalidate()
        }
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = false
        } else {
            // Fallback on earlier versions
        }
        locationUpdates = false
        locationManager.stopUpdatingLocation()
    }
    
    
    //MARK:- WHEN DENIED
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied {
            UserDefaults.standard.set("\(0.0)", forKey: "lat")
            UserDefaults.standard.set("\(0.0)", forKey: "long")
            
            self.generateAlertToNotifyUser()
        } else if status == CLAuthorizationStatus.authorizedAlways ||  status == CLAuthorizationStatus.authorizedWhenInUse  {
            if let location: CLLocation = locationManager.location {
                UserDefaults.standard.set("\(location.coordinate.latitude)", forKey: "lat")
                UserDefaults.standard.set("\(location.coordinate.longitude)", forKey: "long")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name("LocationOn"), object: nil)
            }
         }
    }
    
    func generateAlertToNotifyUser() {
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined{
            
            var title: String
            title = ""
            let message: String = "Location Services are not able to determine your location"
            let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Settings")
            alertView.show()
        }
        
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied{
            var title: String
            title = "Location services are off"
            let message: String = "To use this service efficiently, you must turn on Location Services from Settings"
            let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Settings")
            alertView.show()
        }
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined
        {
            startStandardUpdates()
        }
    }

    /*
    func updateLocationToServer() {
        
       let authCode: (AnyObject?) = (UserDefaults.standard.value(forKey: "auth_code") as AnyObject?)
        if authCode != nil
        {
            var userLoc = CLLocationCoordinate2D()
            if UserDefaults.standard.object(forKey: "lat") != nil {
                let lat =  UserDefaults.standard.object(forKey: "lat") as! String
                let long = UserDefaults.standard.object(forKey: "long") as! String
                userLoc.latitude = CDouble(lat)!
                userLoc.longitude = CDouble(long)!
            }
            
            let latitute =  userLoc.latitude
            let longitude = userLoc.longitude

            let LoginUrl = "\(KServerUrl)"+"user/location-update"
            let param = [
                "lat":"\(latitute)",
                "long":"\(longitude)"
            ]
            print(LoginUrl)
            print(param)

            
            let reachability = Reachability()
            if  reachability?.isReachable  == true {
                 request(LoginUrl, method: .post, parameters: param, encoding: URLEncoding.httpBody,headers:["auth_code": "\(proxy.sharedProxy().authNil())","User-Agent":"\(usewrAgent)"])
                    .responseJSON { response in
                        do {
                            
                            if(response.response?.statusCode == 200)
                            {

                                if let JSON = response.result.value as? NSDictionary{
                                    self.serviceResponse(JSON .mutableCopy() as! NSMutableDictionary)
                                }
                            }else {
                                delegateObject = self
                                 proxy.sharedProxy().stautsHandler(LoginUrl, parameter:param as Dictionary<String, AnyObject>?, response: response.response, data: response.data , error: response.result.error as NSError?)
                            }
                        } 
                }
            }else {
                proxy.sharedProxy().openSettingApp()
            }
        }
    }
  */
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex == 1 {
            // Send the user to the Settings for this app
            let settingsURL: URL = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.openURL(settingsURL)
        }
        
    }
    
    
}

