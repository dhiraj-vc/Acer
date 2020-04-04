
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
import LocalAuthentication
class SplashVM: NSObject {
    func loginUser(param: [String:AnyObject], completion: @escaping ResponseHandler){
        WebServiceProxy.shared.postData("\(Apis.KCheckLogin)\(Proxy.shared.authNil())", params: param, showIndicator: true) {  (ApiResponse) in
            completion(ApiResponse)
        }
    }
    func handelReponseForPushController(_ response:ApiResponse,view:UIViewController){
        if response.success {
           //            debugPrint(response.data)
            if let userDetDict = response.data {
                if let detailDict = userDetDict["detail"] as? NSDictionary
                { if let auth = detailDict["access_token"] as? String {
                    UserDefaults.standard.set(auth, forKey: "access-token")
                    UserDefaults.standard.synchronize()
                    }
                    KAppDelegate.objUserDetailModel.userDict(dict: detailDict)
                     if KAppDelegate.objUserDetailModel.stateID == UserStatus.Incomplete.rawValue &&  KAppDelegate.loginTypeVal == UserRole.User.rawValue {
                            Proxy.shared.logout {
                                KAppDelegate.navigateToOtherVC(identifier: "UserSignInVC")
                            }
                     } else {
                            if KAppDelegate.objUserDetailModel.isPasscode == 1 && KAppDelegate.objUserDetailModel.isFingerPrint == 1 {
                                let setPassVC = mainStoryboard.instantiateViewController(withIdentifier: "SetPassCodeVC") as! SetPassCodeVC
                                setPassVC.setPassVMObj.cameFrom = "SplashWithTouchID"
                                view.navigationController?.pushViewController(setPassVC, animated: true)
                            }
                           else if KAppDelegate.objUserDetailModel.isPasscode != 0 {
                                let setPassVC = mainStoryboard.instantiateViewController(withIdentifier: "SetPassCodeVC") as! SetPassCodeVC
                                setPassVC.setPassVMObj.cameFrom = "Splash"
                                view.navigationController?.pushViewController(setPassVC, animated: true)
                            } else if KAppDelegate.objUserDetailModel.isFingerPrint != 0 {
                                let context = LAContext()
                                var error: NSError?
                                if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                                    let reason = "Authenticate with Touch ID"
                                    context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply:
                                        ({(succes, error) in
                                            if succes {
                                                Proxy.shared.showActivityIndicator()
                                                self.roleNavigation()
                                            } else {
                                                Proxy.shared.displayStatusCodeAlert("Touch ID Authentication Failed")
                                                KAppDelegate.loginTypeVal = UserRole.Admin.rawValue
                                                KAppDelegate.navigateToOtherVC(identifier: "WelcomeVC")
                                            }
                                        } ))
                                } else {
                                    KAppDelegate.loginTypeVal = UserRole.Admin.rawValue
                                    KAppDelegate.navigateToOtherVC(identifier: "WelcomeVC")
                                    Proxy.shared.showAlertController(view: view, message: "Touch ID not available")
                                }
                            } else {
                                roleNavigation()
                            }
                        }
                    }
                }
            } else{
            Proxy.shared.pushToNextVC(identifier: "WelcomeVC", isAnimate: true, currentViewController: view)
        }
    }
    //MARK:- Custome Methods
    func roleNavigation(){
        if KAppDelegate.loginTypeVal == UserRole.Admin.rawValue {
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
    }
    func getTouchIDStatus(view:UIViewController, completion:@escaping() -> Void){
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            completion()
        } else {
            Proxy.shared.showAlertController(view: view, message: "Go to settings and Enable your Touch ID")
        }
    }
}
