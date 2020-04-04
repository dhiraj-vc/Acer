//
//  ChangePasswordVM.swift
//  ConnectUpz
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
class ChangePasswordVM: NSObject {
 var password = String()
     func changePasswordApi(_ completion:@escaping() -> Void) {
        let param = [ "User[newPassword]":  password ] as [String:AnyObject]
        WebServiceProxy.shared.postData("\(Apis.KChangePassword)", params: param, showIndicator: true) { (ApiResponse) in
            if ApiResponse.success {
                Proxy.shared.displayStatusCodeAlert(AlertMsgs.CHANGEPWD)
                    completion()
            }
            else{
                Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
            }
        }
    }
}

extension ChangePasswordVC: UITextFieldDelegate{
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         if textField == txtFldNewPassword{
           txtFldNewPassword.goToNextTextFeild(nextTextFeild: txtFldRePassword)
         }else if textField == txtFldRePassword{
             txtFldRePassword.resignFirstResponder()
        }
        return true 
    }
}
