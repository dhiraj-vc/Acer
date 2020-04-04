
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

class SetPasscodeVM: NSObject {
    var cameFrom = String()
    var isPassConfirmed = false
    var isPassCode = Int()
     var passCodeVal = String()
    func changePasscodeApi(param:[String:AnyObject], completion: @escaping ResponseHandler) {
        WebServiceProxy.shared.postData("\(Apis.KUpdatePasscode)\(Proxy.shared.authNil())", params: param, showIndicator: true) { (ApiResponse) in
            if ApiResponse.success {
               completion(ApiResponse)
            }
            else{
                Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
            }
        }
    }
    func handelReponse(_ response:ApiResponse,completion : @escaping()->Void){
        if response.success {
            if let userDetDict = response.data {
                if let detailDict = userDetDict["user"] as? NSDictionary
                { KAppDelegate.objUserDetailModel.userDict(dict: detailDict)
                  completion()
                  }
            }
        }else{
            Proxy.shared.displayStatusCodeAlert("Try Again...")
        }
    }
    func forgotPasscode(_ completion:@escaping() -> Void){
        WebServiceProxy.shared.getData("\(Apis.KForgotPasscode)\(Proxy.shared.authNil())", showIndicator: true) { (response) in
            if response.success{
               Proxy.shared.displayStatusCodeAlert(AlertMsgs.passcodeAlert)
            }
                else{
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
            completion()
        }
    }
}
extension SetPassCodeVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (range.length == 0){
            if textField == textFieldOne {
                textFldTwo?.becomeFirstResponder()
            }
            if textField == textFldTwo {
                txtFldThree?.becomeFirstResponder()
            }
            if textField == txtFldThree {
                txtFldFour?.becomeFirstResponder()
            }
            if textField == txtFldFour {
                txtFldFour?.resignFirstResponder()
            }
            textField.text? = string
            return false
        }
        else if (range.length == 1) {
            if textField == txtFldFour {
                txtFldThree?.becomeFirstResponder()
            }
            if textField == txtFldThree {
                textFldTwo?.becomeFirstResponder()
            }
            if textField == textFldTwo {
                textFieldOne?.becomeFirstResponder()
            }
            if textField == textFieldOne {
                textFieldOne?.resignFirstResponder()
            }
            textField.text? = ""
            return false
        }
        return true
    }
    func checkValidation()-> Bool {
        if textFieldOne.isBlank != true && textFldTwo.isBlank != true && txtFldThree.isBlank != true && txtFldFour.isBlank != true {
            return true
        } else {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.KEnterPasscode)
            return false
        }
    }
}
