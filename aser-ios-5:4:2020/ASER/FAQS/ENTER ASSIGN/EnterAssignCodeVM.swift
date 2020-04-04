
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
class EnterAssignCodeVM:NSObject{
    var urlString = String()
    func submitAssignCode(_ assignCode: String, completion:@escaping(_ response: ApiResponse) -> Void) {
        let param = [ "code" : assignCode ] as [String:AnyObject]
        WebServiceProxy.shared.postData(urlString, params: param, showIndicator: true) { (response) in
            completion(response)
        }
    }
}
