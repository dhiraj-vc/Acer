
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
class GalleryModel{
    var id : Int?
    var imageFile, title, createdBy: String?
    
    func getGallery(_ dictData:NSDictionary){
        id = dictData["id"] as? Int ?? 0
        imageFile = dictData["image"] as? String ?? ""
        //himanshu ne change
//         imageFile = dictData["file"] as? String ?? ""
        title = dictData["title"] as? String ?? ""
        createdBy = dictData["created_by"] as? String ?? ""
    }
}
class DailyImagesModel{
    var day: String?
    var gallery = [GalleryModel]()
 }
