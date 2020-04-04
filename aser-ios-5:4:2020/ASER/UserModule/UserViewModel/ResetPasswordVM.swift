
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

class ResetPasswordVM: NSObject {
    
    func resetPassword(param: [String:AnyObject], completion : @escaping()->Void) {
        WebServiceProxy.shared.postData("\(Apis.KForgotPassword)", params: param, showIndicator: true) { (response) in
            if response.success{
                Proxy.shared.displayStatusCodeAlert(response.message!)
                completion()
            }else{
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
        }
        
    }
}
extension ResetPasswordVC{
    
}
