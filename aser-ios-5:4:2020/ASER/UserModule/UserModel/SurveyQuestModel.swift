
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
import Foundation
class SurveyQuestModel{
    var cellimage = UIImage()
    var id, typeId, researchId, pictureSubmission : Int?
    var question, day, pictureSubVal,submissionTimeLine  : String?
     var selectedImage = UIImage()
    var arrOptionModel = [OptionModel]()
    func getQuestionList(dictData: NSDictionary) {
        if dictData.count>0{
            id = dictData["id"] as? Int ?? 0
            typeId = dictData["type_id"] as? Int ?? 0
            question = dictData["question"] as? String ?? ""
            researchId = dictData["research_id"] as? Int ?? 0
            submissionTimeLine = dictData["day"] as? String ?? ""
            pictureSubmission = dictData["picture_submission"] as? Int ?? 0
            pictureSubVal = (pictureSubmission == 1) ? "Yes" : "No"
            day = dictData["day"] as? String ?? ""
            var arrOptions = NSArray()
            if let arrOptResaecrh = dictData["Options"] as? NSArray{
                arrOptions = arrOptResaecrh
            } else if let arrOptTemp =  dictData["templateQuestionOptions"] as? NSArray {
                arrOptions = arrOptTemp
            }
            else if let arrOptTemp =  dictData["questionBankOptions"] as? NSArray {
                arrOptions = arrOptTemp
            }
          for index in 0..<arrOptions.count{
                    if let dictData = arrOptions[index] as? NSDictionary{
                        let objM = OptionModel()
                        objM.getOptionList(dictData: dictData)
                        //MARK: APPEND MODEL TO THE SAME ARRAY TYPE
                        objM.isSelected = false
                        self.arrOptionModel.append(objM)
                    }
                }
         }
    }
}

class OptionModel{
    
    var id, questionId, typeId, isAnswer : Int?
    var option : String?
    var isSelected = false
    var selectedIndexPath = IndexPath()
     func getOptionList(dictData: NSDictionary) {
        id = dictData["id"] as? Int ?? 0
        typeId = dictData["type_id"] as? Int ?? 0
        questionId = dictData["question_id"] as? Int ?? 0
        isAnswer = dictData["is_answer"] as? Int ?? 0
        option = dictData["option"] as? String ?? ""
    }
}




