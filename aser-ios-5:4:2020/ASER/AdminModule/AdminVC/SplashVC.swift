
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

class SplashVC: UIViewController {
    //MARK:- Outlets & Variables
    var splashVMObj = SplashVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        sleep(UInt32(2.0))
       
        
        if !KAppDelegate.didStartFromNotification {
            checkAuthcode()
        }
    }
    /// Check for User session either User is already login or not
    func checkAuthcode() {
        let auth = Proxy.shared.authNil()
        if auth == "" {
            Proxy.shared.pushToNextVC(identifier: "WelcomeVC", isAnimate: true, currentViewController: self)
        } else {
            var deviceTokken =  ""
            if UserDefaults.standard.object(forKey: "device_token") == nil {
                deviceTokken = "0000055"
            } else {
                deviceTokken = UserDefaults.standard.object(forKey: "device_token")! as! String
            }
            let param = [ "DeviceDetail[device_token]": deviceTokken ,
                          "DeviceDetail[device_type]" : AppInfo.DeviceType,
                          "DeviceDetail[device_name]" : AppInfo.DeviceName] as [String:AnyObject]
            splashVMObj.loginUser(param: param) { (response) in
                self.splashVMObj.handelReponseForPushController(response, view: self)
            }
        }
    }
    
}

