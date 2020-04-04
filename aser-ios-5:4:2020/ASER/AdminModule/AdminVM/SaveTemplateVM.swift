
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

class SaveTemplateVM: NSObject {
     var researchId = Int()
  func saveTemplate(param:[String:AnyObject], _ completion:@escaping() -> Void){
           WebServiceProxy.shared.postData("\(Apis.KSaveTemplate)\(researchId)", params:param , showIndicator: true) { (ApiResponse) in
                if ApiResponse.success{
                    completion()
                }else{
                    Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
                }
            }
        }
}
