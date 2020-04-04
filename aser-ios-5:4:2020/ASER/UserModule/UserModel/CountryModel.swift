
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

class CountryModel: NSObject {
    var name,sortName : String?
    var id, phoneCode : Int?
    func countryDet(countDict:NSDictionary){
        id = countDict["id"] as? Int ?? 0
        name = countDict["name"] as? String ?? ""
        if name == "" {
        name = countDict["title"] as? String ?? ""
        }
        phoneCode = countDict["phonecode"] as? Int ?? 0
        sortName = countDict["sortname"] as? String ?? ""
    }
}
