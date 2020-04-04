
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

import Foundation
import UIKit
class UserSignInVM: NSObject {
    func loginUser(param : [String:AnyObject],completion: @escaping ResponseHandler){
        WebServiceProxy.shared.postData("\(Apis.KLogIn)", params: param, showIndicator: true)  { (ApiResponse) in
            completion(ApiResponse)
        }
    }
    
    func handelReponseForPushController(_ response:ApiResponse,view:UIViewController){
        if response.success {
           
            if let userDetDict = response.data {
                if let detailDict = userDetDict["user_detail"] as? NSDictionary
                { if let auth = detailDict["access_token"] as? String
                {
                    UserDefaults.standard.set(auth, forKey: "access-token")
                    UserDefaults.standard.synchronize()
                    }
                    KAppDelegate.objUserDetailModel.userDict(dict: detailDict)
                    if KAppDelegate.loginTypeVal == UserRole.Admin.rawValue {
                        KAppDelegate.navigateToOtherVC(identifier: "AdminHomeVC")
                    }else if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue {
                        KAppDelegate.navigateToOtherVC(identifier: "ListOfPatientsVC")
                    } else if KAppDelegate.loginTypeVal == UserRole.Patient.rawValue && KAppDelegate.objUserDetailModel.isParticipant == 0 {
                        KAppDelegate.navigateToOtherVC(identifier: "DashboardPatientVC")
                    } else if KAppDelegate.loginTypeVal == UserRole.Patient.rawValue && KAppDelegate.objUserDetailModel.isParticipant == 1 {
                        KAppDelegate.navigateToOtherVC(identifier: "UserDashboardVC")
                    }  else {
                        (KAppDelegate.objUserDetailModel.stateID == UserStatus.Incomplete.rawValue) ? KAppDelegate.navigateToOtherVC(identifier: "UserProfileCompletionVC") : KAppDelegate.navigateToOtherVC(identifier: "UserDashboardVC")
                    }
                }
            }
        } else{           
            Proxy.shared.displayStatusCodeAlert(response.message!)
        }
    }
}
extension UserSignInVC:UITextFieldDelegate{
    //MARK:- Text Field Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtFldEmail:
            txtFldEmail.goToNextTextFeild(nextTextFeild: txtFldPswrd)            
        case txtFldPswrd:
            txtFldPswrd.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
extension UserSignInVC{
    func checkVallidation() -> Bool {
        if txtFldEmail.isBlank{
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.email)
            return false
        } else if txtFldPswrd.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.password)
            return false
        } else {
            return true
        }
    }
}
