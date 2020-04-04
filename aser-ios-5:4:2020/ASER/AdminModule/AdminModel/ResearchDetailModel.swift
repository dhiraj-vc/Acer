
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

class ResearchDetailModel{
   
    var id, typeId, pictureSubmission : Int?
    var assignCode, companyName, productName, submission_timeline, reserachStartDate, reserachEndDate, basicQuestSubmitted, pictureSubVal, question, submissionTimeLine : String?
    var arrSurveyQuestModel = [SurveyQuestModel]()
    
    func getResearchDetail(dictDat: NSDictionary) {
        if dictDat.count>0{
            id = dictDat["id"] as? Int ?? 0
            typeId = dictDat["type_id"] as? Int ?? 0
            assignCode = dictDat["assign_code"] as? String ?? ""
            companyName = dictDat["company_name"] as? String ?? ""
            productName = dictDat["product_name"] as? String ?? ""
            submission_timeline = dictDat["submission_timeline"] as? String ?? ""
//            basicQuestSubmitted = dictDat["basic_question_submit"] as? Bool ?? false
            reserachStartDate = dictDat["start_date"] as? String ?? ""
            reserachEndDate = dictDat["end_date"] as? String ?? ""
            pictureSubmission  = dictDat["picture_submission"] as? Int ?? 0
            pictureSubVal = (pictureSubmission == 1) ? "Yes" : "No"
//            submissionTimeline = dictDat["submission_timeline"] as? Int ?? 0
            if let values = dictDat["submission_timeline"] as? Int {
                submissionTimeLine = "\(values)"
            }else if let val = dictDat["submission_timeline"] as? String {
                submissionTimeLine = val
            }else{
                submissionTimeLine = ""
            }
            question = dictDat["question"] as? String ?? ""
            var arrQuest = NSArray()
            if let arrQuestResaecrh = dictDat["Questions"] as? NSArray{
             arrQuest = arrQuestResaecrh
            } else if let arrQuestTemp =  dictDat["templateQuestions"] as? NSArray {
             arrQuest = arrQuestTemp
            }
            if arrQuest.count > 0  {
                for index in 0..<arrQuest.count{
                    if let dictData = arrQuest[index] as? NSDictionary{
                        let objModel = SurveyQuestModel()
                        objModel.getQuestionList(dictData: dictData)
                        self.arrSurveyQuestModel.append(objModel)
                    }
                } 
            }
        }
    }
}

