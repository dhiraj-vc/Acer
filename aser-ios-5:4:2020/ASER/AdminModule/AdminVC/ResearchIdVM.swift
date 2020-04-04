
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
class ResearchIdVM:NSObject{
    var urlString = String()
    func submitAssignCode(_ assignCode: String, completion:@escaping(_ response: ApiResponse) -> Void) {
        
        WebServiceProxy.shared.getData("\(Apis.KEnterResearchIds)\(urlString)", showIndicator: true) { (ApiResponse) in
            if ApiResponse.success{
                completion(ApiResponse)
            }else{
                Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
            }
        }
        
        
        
//        let param = [ "research_id" : assignCode ] as [String:AnyObject]
//        WebServiceProxy.shared.postData(urlString, params: param, showIndicator: true) { (response) in
//            completion(response)
//        }
    }
}
