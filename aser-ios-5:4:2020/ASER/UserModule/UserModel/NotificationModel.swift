
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
class NotificationModel{
    var id, modelId : Int?
    var imageFile, title,description,date,time, controller, action: String?
    
    func getNotification(_ dictData:NSDictionary){
        imageFile = dictData["file"] as? String ?? ""
        title = dictData["title"] as? String ?? ""
        controller = dictData["controller"] as? String ?? ""
        action = dictData["action"] as? String ?? ""
        id = dictData["id"] as? Int ?? 0
        modelId = dictData["model_id"] as? Int ?? 0
        description = dictData["description"] as? String ?? ""
        let dateAndTime = dictData["created_on"] as? String ?? ""
        date = Proxy.shared.changeDateFormat(dateAndTime, oldFormat: "yyyy-MM-dd HH:mm:ss", dateFormat: "dd MMM, yyyy")
        time = Proxy.shared.changeDateFormat(dateAndTime, oldFormat: "yyyy-MM-dd HH:mm:ss", dateFormat: "hh:mm")
    }
}
