
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
class SubmittedSurveyAnsModel{
    var id : Int?
    var question: String?
    var arrAnswerModel = [AnswerModel]()
    func getSubmittedSurveyList(dictData: NSDictionary) {
        id = dictData["id"] as? Int ?? 0
        question = dictData["question"] as? String ?? ""

        if let arrSubmitted = dictData["Answers"] as? NSArray{
            self.arrAnswerModel = []
                for index in 0..<arrSubmitted.count{
                    if let dictData = arrSubmitted[index] as? NSDictionary{
                        let objM = AnswerModel()
                        objM.getAnswerList(dictData: dictData)
                        self.arrAnswerModel.append(objM)
                    }
                }
         
        }
    }
}

class AnswerModel{
    var userName, writtenAns, submittedImg, optionString: String?
    
    func getAnswerList(dictData: NSDictionary) {
        userName = dictData["user"] as? String ?? ""
        writtenAns = dictData["answer"] as? String ?? ""
        submittedImg = dictData["image"] as? String ?? ""
        
        if let arrSubmitted = dictData["surveyansweroptions"] as? NSArray{
//            if arrSubmitted.count>0{
                optionString = arrToString(selectArr: arrSubmitted.mutableCopy() as! NSMutableArray)
//            }
        }
    }
    
    func arrToString (selectArr:NSMutableArray) -> String{
        var conString = String()
            for i in 0..<selectArr.count{
                if let dictData = selectArr[i] as? NSDictionary{
                let optionStr = dictData["option_name"] as? String
                        if i != selectArr.count-1 {
                            conString += "\(optionStr!),"
                        } else {
                            conString += "\(optionStr!)"
                        }
                }
            }
        return conString
    }
}

