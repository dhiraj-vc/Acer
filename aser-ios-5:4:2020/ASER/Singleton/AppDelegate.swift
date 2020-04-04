
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
import IQKeyboardManagerSwift
import UserNotifications
import FBSDKShareKit
import FBSDKLoginKit
import LocalAuthentication
//import CoreLocation
@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate, SSASideMenuDelegate, UNUserNotificationCenterDelegate  {
    var window: UIWindow?
    var currentViewCont = UIViewController()
    var networkOff = false
    var zoomLevel : Float = 14.9
    var sideMenuViewController: SSASideMenu?
    var loginTypeVal  = UserRole.Admin.rawValue
    var objUserDetailModel =  UserDetailModel()
    var addSurveyQuestionModel = AddSurvayQuestionModel()
    var arrForQuestion = NSMutableArray()
    var didStartFromNotification = Bool()
    let splashView = UIImageView()
    let locationManager = CLLocationManager()
    var patientDet = PatientDetModel()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startMonitoringVisits()
//        locationManager.delegate = self

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        registerForPushNotifications(application: application)
        UIApplication.shared.applicationIconBadgeNumber = 0;
        if let options = launchOptions {
            if let notification = options[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary {
                didStartFromNotification = true
                DispatchQueue.main.async {
                    self.checkWithNotification(userInfo: notification,viewCont:(self.window?.rootViewController)!)
                }
            }else{
                didStartFromNotification = false
            }
        }else {
            didStartFromNotification = false
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func checkWithNotification(userInfo:NSDictionary,viewCont:UIViewController) {
        let auth = Proxy.shared.authNil()
        if auth == "" {
            Proxy.shared.pushToNextVC(identifier: "IntroductionVC", isAnimate: true, currentViewController: viewCont)
        } else {
            var deviceTokken =  ""
            if UserDefaults.standard.object(forKey: "device_token") == nil {
                deviceTokken = "0000055"
            } else {
                deviceTokken = UserDefaults.standard.object(forKey: "device_token")! as! String
            }
            debugPrint(deviceTokken)
            let param = [ "DeviceDetail[device_token]": deviceTokken ,
                          "DeviceDetail[device_type]" : AppInfo.DeviceType,
                          "DeviceDetail[device_name]" : AppInfo.DeviceName] as [String:AnyObject]
            WebServiceProxy.shared.postData("\(Apis.KCheckLogin)\(Proxy.shared.authNil())", params: param, showIndicator: true) {  (ApiResponse) in
                self.handelReponseForPushController(ApiResponse, view: viewCont,userInfo:userInfo)
            }
        }
    }
    func handelReponseForPushController(_ response:ApiResponse,view:UIViewController,userInfo:NSDictionary){
        if response.success {
            if let userDetDict = response.data {
                if let detailDict = userDetDict["detail"] as? NSDictionary
                { if let auth = detailDict["access_token"] as? String {
                    UserDefaults.standard.set(auth, forKey: "access-token")
                    UserDefaults.standard.synchronize()
                    }
                    KAppDelegate.objUserDetailModel.userDict(dict: detailDict)
                    if KAppDelegate.loginTypeVal == UserRole.User.rawValue && KAppDelegate.objUserDetailModel.stateID == UserStatus.Incomplete.rawValue{
                            Proxy.shared.logout {
                                KAppDelegate.loginTypeVal = UserRole.Admin.rawValue
                                 KAppDelegate.navigateToOtherVC(identifier: "WelcomeVC")
                            }
                    } else if KAppDelegate.loginTypeVal == UserRole.Admin.rawValue {
                        KAppDelegate.navigateToOtherVC(identifier: "AdminHomeVC")
                    } else if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue {
                        KAppDelegate.navigateToOtherVC(identifier: "ListOfPatientsVC")
                    } else if KAppDelegate.loginTypeVal == UserRole.Patient.rawValue && KAppDelegate.objUserDetailModel.isParticipant == 0 {
                        KAppDelegate.navigateToOtherVC(identifier: "DashboardPatientVC")
                    } else if KAppDelegate.loginTypeVal == UserRole.Patient.rawValue && KAppDelegate.objUserDetailModel.isParticipant == 1 {
                        KAppDelegate.loginTypeVal = UserRole.User.rawValue
                        KAppDelegate.navigateToOtherVC(identifier: "UserDashboardVC")
                    } else {
                        KAppDelegate.navigateToOtherVC(identifier: "UserDashboardVC")
                    }
                    self.handleNotifications(userInfo: userInfo)
                }
            }
        } else {
            Proxy.shared.pushToNextVC(identifier: "WelcomeVC", isAnimate: true, currentViewController: view)
        }
    }
    //MARK:- Custome Methods
    func roleNavigation(_ userInfo:NSDictionary){
       
    }
    //Set Route with SSA side menu
    func navigateToOtherVC(identifier:String) {
        let homeVC = mainStoryboard.instantiateViewController(withIdentifier: identifier)
        var leftVC = UIViewController()
        
        if KAppDelegate.loginTypeVal > 2 {
            if KAppDelegate.loginTypeVal == UserRole.Patient.rawValue && KAppDelegate.objUserDetailModel.isParticipant == 1 {
              leftVC = mainStoryboard.instantiateViewController(withIdentifier: "DrawerVC")
            } else {
            leftVC = mainStoryboard.instantiateViewController(withIdentifier: "MedicalDrawerVC")
            }
        } else {
            leftVC = mainStoryboard.instantiateViewController(withIdentifier: "DrawerVC")
        }
        //MARK : Setup SSASideMenu
        let sideMenu = SSASideMenu(contentViewController: UINavigationController(rootViewController: homeVC), leftMenuViewController: leftVC)
        sideMenu.delegate = self
        sideMenu.navigationController?.isNavigationBarHidden = true
        homeVC.navigationController?.isNavigationBarHidden = true
        window?.rootViewController = sideMenu
        currentViewCont = homeVC
        window?.makeKeyAndVisible()
    }
    //MARK:- Deep Linking
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var  result = false
        if  url.absoluteString.range(of:("facebook")) != nil{
            result = FBSDKApplicationDelegate.sharedInstance().application(app, open: url as URL!, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        }
        return true
    }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        Proxy.shared.hideActivityIndicator()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application,open: url as URL?,sourceApplication: sourceApplication,annotation: annotation)
    }
    // MARK:- NOTIFICATION METHODS
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        debugPrint("Device Token: \(tokenString)")
        UserDefaults.standard.set(tokenString, forKey: "device_token")
        UserDefaults.standard.synchronize()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        UserDefaults.standard.set("00000000000000055", forKey: "device_token")
        UserDefaults.standard.synchronize()
    }
    
    func registerForPushNotifications(application: UIApplication) {
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted) {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            })
        } else {
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if !didStartFromNotification {
            handleNotifications(userInfo: userInfo as NSDictionary)
        } else {
            didStartFromNotification = false
        }
        
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (_ options: UNNotificationPresentationOptions) -> Void) {
        var userInfo = NSDictionary()
        userInfo = notification.request.content.userInfo as NSDictionary
        debugPrint("userInfo" ,userInfo)
        completionHandler([.sound])
        handleNotifications(userInfo: userInfo)
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        var userInfo = NSDictionary()
        userInfo = response.notification.request.content.userInfo as NSDictionary
        if !didStartFromNotification {
            handleNotifications(userInfo: userInfo)
        } else {
            didStartFromNotification = false
        }
    }
    // MARK:- HANDLE NOTIFICATION DATA
    func handleNotifications(userInfo: NSDictionary) {
        //        UIApplication.shared.applicationIconBadgeNumber = 0;
        debugPrint("userInfo" ,userInfo)
        normalAlertWithAction(userInfo: userInfo)
    }
    func normalAlertWithAction(userInfo:NSDictionary)  {
        if let aps = userInfo["aps"] as? NSDictionary{
            let message = aps.value(forKey: "alert") as? String ?? "ASER.. Notificaton received!"
            let alert = UIAlertController(title: "ASER", message: message, preferredStyle: .alert)
            //            let dismiss = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (action: UIAlertAction) in
                let action = userInfo["action"] as? String
                let controller = userInfo["controller"] as? String
                if action == "reminder" && controller == "timer" {
                    if (self.currentViewCont.isKind(of: UserHomeVC.self)) {
                        NotificationCenter.default.post(name: NSNotification.Name("RefreshHomeList"), object: nil)
                    } else {
                        let userHomeVC = mainStoryboard.instantiateViewController(withIdentifier: "UserHomeVC") as! UserHomeVC
                        self.currentViewCont.navigationController?.pushViewController(userHomeVC, animated: true)
                    }
                    //MARK:- Doctor Patient Notifications
                } else if action == "send-message" && controller == "chat"  {
                    if (self.currentViewCont.isKind(of: ChatVC.self)) {
                        NotificationCenter.default.post(name: NSNotification.Name("RefreshChatList"), object: nil)
                    } else {
                        if let toUserID =  userInfo["from_user"] as? Int {
                            let chatVC = mainStoryboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                            chatVC.objChatVM.messageToId = toUserID
                            KAppDelegate.currentViewCont = chatVC
                            self.currentViewCont.navigationController?.pushViewController(chatVC, animated: true)
                        }
                    }
                } else if action == "update-appointment" && controller == "appointment"  {
                    if (self.currentViewCont.isKind(of: AppointmentListVC.self)) {
                        NotificationCenter.default.post(name: NSNotification.Name("RefreshList"), object: nil)
                    } else {
                        let chatVC = mainStoryboard.instantiateViewController(withIdentifier: "AppointmentListVC") as! AppointmentListVC
                        KAppDelegate.currentViewCont = chatVC
                        self.currentViewCont.navigationController?.pushViewController(chatVC, animated: true)
                    }
                } else if action == "save-answer" && controller == "research-program" {
                    let survayAnsVC = mainStoryboard.instantiateViewController(withIdentifier: "SubmittedSurveyAnsVC") as! SubmittedSurveyAnsVC
                    let resID = userInfo["research_id"] as? Int
                    survayAnsVC.objSubSurveyAnsVM.researchId =  resID!
                    self.currentViewCont.navigationController?.pushViewController(survayAnsVC, animated: true)
                } else if action == "share-program" && controller == "research-program" {
                    if (self.currentViewCont.isKind(of: CreateResearchProgramVC.self)) {
                        NotificationCenter.default.post(name: NSNotification.Name("RefreshSharedList"), object: nil)
                    } else {
                        let newVC = mainStoryboard.instantiateViewController(withIdentifier: "CreateResearchProgramVC") as! CreateResearchProgramVC
                        newVC.title = "Shared Survey"
                        self.currentViewCont.navigationController?.pushViewController(newVC, animated: true)
                    }
                } else if action == "template" && controller == "save-as-template" {
                    if (self.currentViewCont.isKind(of: TemplatesListVC.self)) {
                        NotificationCenter.default.post(name: NSNotification.Name("RefreshTemplateList"), object: nil)
                    } else {
                        Proxy.shared.pushToNextVC(identifier: "TemplatesListVC", isAnimate: true, currentViewController: self.currentViewCont)
                    }
                } else {
                    if KAppDelegate.loginTypeVal == UserRole.Admin.rawValue{
                        KAppDelegate.navigateToOtherVC(identifier: "AdminHomeVC")
                    } else if KAppDelegate.loginTypeVal == UserRole.User.rawValue{
                        KAppDelegate.navigateToOtherVC(identifier: "UserDashboardVC")
                    } else if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue{
                        KAppDelegate.navigateToOtherVC(identifier: "ListOfPatientsVC")
                    } else if KAppDelegate.loginTypeVal == UserRole.Patient.rawValue{
                        KAppDelegate.navigateToOtherVC(identifier: "DashboardPatientVC")
                    }
                }
            }
            alert.addAction(action)
            self.currentViewCont.present(alert, animated: true, completion: nil)
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
}

