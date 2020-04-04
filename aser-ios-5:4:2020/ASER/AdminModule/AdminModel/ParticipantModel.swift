
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

class ParticipantModel {
    var id, is_shared : Int?
    var fullName, profileImg : String?
    var shared = false
    var rating:Float?
    func getParticipantsData(dictData: NSDictionary){
        id = dictData["id"] as? Int ?? 0
        fullName = dictData["full_name"] as? String ?? ""
        profileImg = dictData["profile_file"] as? String ?? ""
        is_shared = dictData["is_shared"] as? Int ?? 0
        shared = (is_shared == 1) ? true : false
        rating = dictData["rating"] as? Float ?? 0
    }
}
