
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

class ChatModel: NSObject {
    var fullName,message,createdOn, profileImg, fromUsername, toUserName:String?
    var chatId, messageID, unreadCount, fromUserId, toUserId : Int?
    func getChatDet(_ dictData: NSDictionary){
        fullName = dictData["full_name"] as? String ?? ""
        unreadCount = dictData["unread_count"] as? Int ?? 0
        profileImg = dictData["user"] as? String ?? ""
        if profileImg == ""{
          profileImg = dictData["profile_file"] as? String ?? ""
        }
        fromUsername = dictData["from_user_name"] as? String ?? ""
        toUserName = dictData["to_user_name"] as? String ?? ""
        chatId = dictData["id"] as? Int ?? 0
        fromUserId = dictData["from_user_id"] as? Int ?? 0
        toUserId = dictData["to_user_id"] as? Int ?? 0
        if let dictMsg = dictData["message"] as? NSDictionary{
            messageID = dictMsg["id"] as? Int ?? 0
            createdOn = dictMsg["created_on"] as? String ?? ""
            message = dictMsg["message"] as? String ?? ""
        } else {
            messageID = dictData["id"] as? Int ?? 0
            createdOn = dictData["created_on"] as? String ?? ""
            message = dictData["message"] as? String ?? ""
        }
    }
}
