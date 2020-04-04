
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
class UserSignUpVM: NSObject {
    var picker = UIPickerView()
    var cameFrom = String()
    func saveSignUpDetail(param : [String:AnyObject],completion: @escaping ResponseHandler){
        WebServiceProxy.shared.postData("\(Apis.KSignUp)", params: param, showIndicator: true)  { (ApiResponse) in
            completion(ApiResponse)
        }
    }
    
    func handelReponseForPushController(_ response:ApiResponse,view:UIViewController){
        if response.success {           
            if let userDetDict = response.data {
                if let detailDict = userDetDict["detail"] as? NSDictionary
                { if let auth = detailDict["access_token"] as? String {
                    UserDefaults.standard.set(auth, forKey: "access-token")
                    UserDefaults.standard.synchronize()
                    }
                    KAppDelegate.objUserDetailModel.userDict(dict: detailDict)
                    if KAppDelegate.loginTypeVal == UserRole.Admin.rawValue {
                        KAppDelegate.navigateToOtherVC(identifier: "AdminHomeVC")
                    }else{
                        (KAppDelegate.objUserDetailModel.stateID == UserStatus.Incomplete.rawValue) ? KAppDelegate.navigateToOtherVC(identifier: "UserProfileCompletionVC") : KAppDelegate.navigateToOtherVC(identifier: "UserDashboardVC")
                    }
                }
            }
        }  else {
            Proxy.shared.displayStatusCodeAlert(response.message ?? AlertMsgs.FAILSIGNUP)
        }
    }
}
extension UserSignUpVC: UIPickerViewDelegate,UIPickerViewDataSource {
    //MAKR:- PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return StaticData.AdminRole.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        txtFldRole.text = StaticData.AdminRole[row][0]
        return StaticData.AdminRole[row][0]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtFldRole.text = StaticData.AdminRole[row][0]
    }
}

extension UserSignUpVC:UITextFieldDelegate {
    //MARK:- Text Field Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtFldFirstName:
            txtFldFirstName.goToNextTextFeild(nextTextFeild: txtFldLastName)
        case txtFldLastName:
            txtFldLastName.goToNextTextFeild(nextTextFeild: txtFldEmail)
        case txtFldEmail:
            txtFldEmail.goToNextTextFeild(nextTextFeild: txtFldPswrd)
        case txtFldPswrd:
            txtFldPswrd.goToNextTextFeild(nextTextFeild: txtFldConfirmPswrd)
        case txtFldConfirmPswrd:
            txtFldConfirmPswrd.resignFirstResponder()
        case txtFldRole:
            txtFldRole.resignFirstResponder()
        default:
            break
        }
        return true
    }
}

extension UserSignUpVC{
    func checkVallidation() -> Bool {
        if txtFldFirstName.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.ENTERFIRSTNAME)
            return false
        }
        else if txtFldLastName.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.ENTERLASTNAME)
            return false
        }
        else if txtFldEmail.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.email)
            return false
        }
        else if Proxy.shared.isValidEmail(txtFldEmail.text!) != true && KAppDelegate.loginTypeVal == UserRole.User.rawValue {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.validEmail)
            return false
        }
//        else if Proxy.shared.isAdminValidEmail(txtFldEmail.text!) != true && KAppDelegate.loginTypeVal == UserRole.Admin.rawValue {
//            Proxy.shared.displayStatusCodeAlert(AlertMsgs.validEmail)
//            return false
//        }
        else if txtFldPswrd.isBlank{
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.password)
            return false
        }
            // himanshu rajput
//        else if Proxy.shared.isValidPassword(txtFldPswrd.text!) != true {
//            Proxy.shared.displayStatusCodeAlert(AlertMsgs.validPassword)
//            return false
//        }
        else if txtFldConfirmPswrd.isBlank{
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.confirmPassword)
            return false
        }
        else if txtFldConfirmPswrd.text != txtFldPswrd.text {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.wrongConfirmPassword)
            return false
        }
        else if txtFldRole.isBlank == true && KAppDelegate.loginTypeVal == UserRole.Admin.rawValue {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.enterRole)
            return false
        }
        else if btnTermsAndCondition.isSelected != true && KAppDelegate.loginTypeVal == UserRole.User.rawValue {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.acceptTerms)
            return false
        }
        else if txtFldDesignation.isBlank && KAppDelegate.loginTypeVal == UserRole.Admin.rawValue {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.ENTERDESIGNATION)
            return false
        } else {
            return true
        }
    }
}


