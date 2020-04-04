//
//  Proxy.swift
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
import Foundation
import Alamofire
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import NVActivityIndicatorView
let KAppDelegate = UIApplication.shared.delegate as! AppDelegate
typealias ResponseHandler = (ApiResponse) -> Void
 let storyBoard = UIStoryboard(name: "Main", bundle: nil)
 var currentViewCont = UIViewController()
 class Proxy {
    static var shared: Proxy {
        return Proxy()
    }
   private init(){}
    
    //MARK:- Common Methods
    func authNil() -> String {
        if let authCode = UserDefaults.standard.object(forKey: "access-token") as? String {
            return authCode
        } else {
            return ""
        }
    }

    //MARK:- Push Method
    var emptyDictionary = [String: String]()
    
    func pushToNextVC(identifier:String, isAnimate:Bool, currentViewController: UIViewController, title: String = " ") {
        let pushControllerObj = mainStoryboard.instantiateViewController(withIdentifier: identifier)
        if title != " "{
          pushControllerObj.title = title
        }
        KAppDelegate.currentViewCont = currentViewController
        currentViewController.navigationController?.pushViewController(pushControllerObj, animated: isAnimate)
    }
   
    //MARK:- Pop Method
    func popToBackVC(isAnimate:Bool , currentViewController: UIViewController) {
        currentViewController.navigationController?.popViewController(animated: isAnimate)
    }
    
    //MARK:- Present Method
    func presentToNextVC(identifier:String, isAnimate:Bool , currentViewController: UIViewController) {
        let presentControllerObj = mainStoryboard.instantiateViewController(withIdentifier: identifier)
        currentViewController.present(presentControllerObj, animated: isAnimate, completion: nil)
    }
    
    //MARK:- Dismiss Method
    func dismissToBackVC(isAnimate:Bool, currentViewController: UIViewController) {
        currentViewController.dismiss(animated: isAnimate, completion: nil)
    }
   func rootWithoutDrawer(identifier: String){
        let blankController = storyBoard.instantiateViewController(withIdentifier: identifier)
        var homeNavController:UINavigationController = UINavigationController()
        homeNavController = UINavigationController.init(rootViewController: blankController)
        homeNavController.isNavigationBarHidden = true
        KAppDelegate.window!.rootViewController = homeNavController
        KAppDelegate.window!.makeKeyAndVisible()
    }
    //MARK:- Display Toast
    func displayStatusCodeAlert(_ userMessage: String) {
//          UIView.hr_setToastThemeColor(Colours.SuccessColor)
        UIView.hr_setToastThemeColor(UIColor.white )
        KAppDelegate.window!.makeToast(message: userMessage)
    }
   //MARK:- Check Valid Email Method
    func isValidEmail(_ testStr:String) -> Bool  {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return (testStr.range(of: emailRegEx, options:.regularExpression) != nil)
    }
    func isAdminValidEmail(_ testStr:String) -> Bool {
        if validMailaz(email: testStr){
            return true
        } else if validMailstt(email: testStr) {
            return true
        } else {
            return false
        }
    }
    func validMailstt(email: String) -> Bool {
        let emailRegExstt = "[A-Z0-9a-z._%+-]+@agelesszen.com"
        return (email.range(of: emailRegExstt, options:.regularExpression) != nil)
    }
    func validMailaz(email: String) -> Bool {
        let emailRegExstt = "[A-Z0-9a-z._%+-]+@sttintl.com"
        return (email.range(of: emailRegExstt, options:.regularExpression) != nil)
    }    
    func timeFromatter(_ time: String) -> String {
        let dateFrmterSingle = DateFormatter()
        dateFrmterSingle.dateFormat = "HH:mm:ss"
        let time = dateFrmterSingle.date(from: time)
        dateFrmterSingle.dateFormat = "hh:mm a"
        return dateFrmterSingle.string(from: time!)
    }
    func timeFromatterReverse(_ time: String) -> String {
        let dateFrmterSingle = DateFormatter()
        dateFrmterSingle.dateFormat = "hh:mm a"
        let time = dateFrmterSingle.date(from: time)
        dateFrmterSingle.dateFormat = "HH:mm:ss"
        return dateFrmterSingle.string(from: time!)
    }
    func getDateAndTime(getDate:String) -> (String,String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        let dateInStr = dateFormatter.date(from: getDate)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        if dateInStr != nil{
            let resultDateInStr = dateFormatter1.string(from: dateInStr!)
            dateFormatter1.dateFormat = "hh:mm a"
            let timeInStr = dateFormatter.date(from: getDate)
            let resultTimeInStr = dateFormatter1.string(from: timeInStr!)
            return (resultDateInStr,resultTimeInStr)
        }else{
            return ("","")
        }
    }
    /* Use the Below two for Date Formatting*/
    func getStringFrmDate(getDate:Date, format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format //"yyyy-MM-dd hh:mm"
        let dateInStr = dateFormatter.string(from: getDate)
        return dateInStr
    }
    func getDateFrmString(getDate:String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format //("yyyy-MM-dd HH:mm:ss")"
        var dateInStr = dateFormatter.date(from: getDate)
        if dateInStr == nil {
            dateInStr = Date()
        }
        
        return dateInStr!
    }
    func isValidPassword(_ testStr:String) -> Bool {
        let eightRegEx  = ".{8,}"
        let texttest3 = NSPredicate(format:"SELF MATCHES %@", eightRegEx)
        let eightresult = texttest3.evaluate(with: testStr)
        return eightresult
    }
    func isValidPhone(_ testStr:String) -> Bool {
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: testStr)
        let tenRegEx  = ".{16,}"
        let texttest3 = NSPredicate(format:"SELF MATCHES %@", tenRegEx)
        let tenresult = texttest3.evaluate(with: testStr)
        return numberresult && tenresult
    }
    //MARK:- Check Valid Name Method
    func isValidInput(_ Input:String) -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
        // string contains non-whitespace characters
        if Input.rangeOfCharacter(from: characterset.inverted) != nil {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.validName)
            return false
        }
        else {
            return true
        }
    }
    //MARK: - HANDLE ACTIVITY
    func showActivityIndicator() {
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    func hideActivityIndicator() {       
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    //MARK:- Latitude Method
    func getLatitude() -> String   {
        if UserDefaults.standard.object(forKey: "lat") != nil {
            let currentLat =  UserDefaults.standard.object(forKey: "lat") as! String
            return currentLat
        }
        return ""
    }
    //MARK:- Longitude Method
    func getLongitude() -> String {
        if UserDefaults.standard.object(forKey: "long") != nil {
            let currentLong =  UserDefaults.standard.object(forKey: "long") as! String
            return currentLong
        }
        return ""
    }
    //MARK:- Open Default Setting
    func openSettingApp() {
        KAppDelegate.networkOff = true
        let settingAlert = UIAlertController(title: "Connection Problem", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        settingAlert.addAction(okAction)
        let openSetting = UIAlertAction(title:"Setting", style:UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) in
            let url:URL = URL(string: UIApplication.openSettingsURLString)!
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in })
            } else {
                guard UIApplication.shared.openURL(url) else {
                    Proxy.shared.displayStatusCodeAlert(AlertMsgs.reviewNetwork)
                    return
                }
            }
        })
        settingAlert.addAction(openSetting)
        
        
//        himanshu
        KAppDelegate.window?.rootViewController?.present(settingAlert, animated: true, completion: nil)
//        KAppDelegate.window?.currentViewController()?.present(settingAlert, animated: true, completion: nil)
    }
    //MARK:- LOCATION SETTING
    func openLocationSettingApp() {
        let settingAlert = UIAlertController(title: "Location Problem", message: "Please enable your location", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        settingAlert.addAction(okAction)
        let openSetting = UIAlertAction(title:"Setting", style:UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) in
            let url:URL = URL(string: UIApplication.openSettingsURLString)!
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in })
            } else {
                guard UIApplication.shared.openURL(url) else {
                    Proxy.shared.displayStatusCodeAlert(AlertMsgs.reviewNetwork)
                    return
                }
            }
        })
        settingAlert.addAction(openSetting)
        UIApplication.shared.keyWindow?.rootViewController?.present(settingAlert, animated: true, completion: nil)
    }
    //MARK:- Show Alert to enable Touch ID
    func showAlertController(view:UIViewController, message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let url:URL = URL(string: UIApplication.openSettingsURLString)!
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in })
            } else {
                guard UIApplication.shared.openURL(url) else {
                    Proxy.shared.displayStatusCodeAlert(AlertMsgs.reviewNetwork)
                    return
                }
            }
        }))
        view.present(alertController, animated: true, completion: nil)
    }
    //MARK:- logout Method
    func logout(_ completion:@escaping() -> Void){
        WebServiceProxy.shared.getData("\(Apis.KLogout)", showIndicator: true, completion: {  (ApiResponse) in
            if ApiResponse.success{
                UserDefaults.standard.set("", forKey: "access-token")
                UserDefaults.standard.set("", forKey: "ColorKey")
                
                UserDefaults.standard.synchronize()
                Proxy.shared.displayStatusCodeAlert(AlertMsgs.LOGOUT)
                completion()
            } else {
              Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
            }
            self.hideActivityIndicator()
        })
    }
    //MARK:- expiry Date Method
    func expiryDateCheckMethod(_ expiryDate: String)->Bool  {
        let dateInFormat = DateFormatter()
        dateInFormat.timeZone = TimeZone(identifier: "UTC")
        dateInFormat.dateFormat = "yyyy-MM-dd"
        let expiryDate = dateInFormat.date(from: expiryDate)
        
        dateInFormat.timeZone = TimeZone.current
        let now = dateInFormat.string(from: Date())
        let currentDate = dateInFormat.date(from: now)
        let offsetTime = TimeZone.current.secondsFromGMT()
        let finalTime = currentDate!.addingTimeInterval(TimeInterval(offsetTime))
        
        if finalTime.compare(expiryDate!) == ComparisonResult.orderedDescending {
            return false
        } else if currentDate!.compare(expiryDate!) == ComparisonResult.orderedAscending  {
            return true
        } else{
            return true
        }
    }
    //MARK : DATE FORMAT
    func dateFormatinYDMHM(dateFormat:String,date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let resultDate = dateFormatter.string(from: date)
        return resultDate
    }
    //Add Done Button for TextField
    func addDoneBtnOnTF(_ textfield:UITextField,doneButton:UIBarButtonItem,cancelButton:UIBarButtonItem)  {
        //Add done button on keyboard toolbar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        textfield.inputAccessoryView = toolbar
    }
    //CALCULATE DURATION
    func getDuration(from: Date , to:Date ) -> String {
        let calendar = NSCalendar.current
        let startDate = calendar.startOfDay(for: from)
        let endDate = calendar.startOfDay(for: to)
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return  "\(components.day! + 1)"
    }
    
    //MARK : METHOD FOR HANDLING ALERT"S & PERFEROM ACTION
    func alertControl(title:String, message:String, _ completion:@escaping(_ alert:UIAlertController, _ action:String) -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.handleAlert(action: action, { (Bool) in
                if Bool == true{
                    completion(alert, "true")
                }
            })            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            //TODO: self.handleAlert(action:action)
            self.handleAlert(action: action, { (Bool) in
                if Bool == false{
                    completion(alert, "false")
                }
            })
        }))
        completion(alert, " ")
    }
    
    func handleAlert(action:UIAlertAction, _ completion:@escaping(_ action:Bool) -> Void){
        switch action.style{
        case .default:
            print("default")
            completion(true)
        case .cancel:
            completion(false)
            print("cancel")
        case .destructive:
            print("destructive")
            
        }
    }
    
    //Change any object to jsonString
    func jsonString(from object:Any) -> String? {
        var finalString = String()
        do {let jsonData = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
            //Convert back to string. Usually only do this for debugging
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                let test = String(JSONString.filter { !"\n".contains($0) })
                finalString =  test }
        } catch {
            Proxy.shared.displayStatusCodeAlert(error as! String)
        }
        return finalString
    }
    
    func arrToString (selectArr:NSMutableArray) -> String{
        var conString = String()
        if selectArr.count > 0 {
            for i in 0..<selectArr.count{
                if selectArr[i] as! Int != 0 {
                    if i != selectArr.count-1 {
                        conString += "\(selectArr[i]),"
                    } else {
                        conString += "\(selectArr[i])"
                    }
                }
            }
        }
        return conString
    }
    
    func getDateFrmStringNew(getDate:String, format: String) -> Date {
        var endDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format //("yyyy-MM-dd HH:mm:ss")"
        let dateInStr = dateFormatter.date(from: getDate)
        if dateInStr != nil {
            endDate = Calendar.current.date(byAdding: .day, value: 1, to: dateInStr!)!
        } else {
            endDate = Date()
        }
        return endDate
    }
    
    //MARK:- Change Date format
    func changeDateFormat(_ dateStr: String, oldFormat:String, dateFormat:String) -> String{
        if dateStr != ""{
            let dateFormattr = DateFormatter()
            dateFormattr.dateFormat = oldFormat
            let date1 = dateFormattr.date(from: dateStr)
            let dateFormattr1 = DateFormatter()
            dateFormattr1.dateFormat = dateFormat
            var dateNew = String()
            if date1 != nil {
                dateNew = dateFormattr1.string(from: (date1!))
            } else {
                dateNew = dateFormattr1.string(from: (Date()))
            }
            return dateNew
        }else{
            return ""
        }
    }
}
