
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

class CreateResearchProgramModel{
    var basicQuestSubmitted = false
    var id, typeId, pictureSubmission, submissionTimeline ,researchId, isReminder, createdBy : Int?
    var assignCode, companyName, productName, description,  submission_timeline, created_on, reserachStartDate, reserachEndDate, shareBy: String?
    
    func getResearchList(dictDat: NSDictionary) {
        if dictDat.count>0{
            id = dictDat["id"] as? Int ?? 0
            typeId = dictDat["type_id"] as? Int ?? 0
            isReminder = dictDat["is_reminder"] as? Int ?? 0
            createdBy = dictDat["created_by_id"] as? Int ?? 0
            assignCode = dictDat["assign_code"] as? String ?? ""
            companyName = dictDat["company_name"] as? String ?? ""
            description = dictDat["description"] as? String ?? ""
            submission_timeline = dictDat["submission_timeline"] as? String ?? ""
            created_on = dictDat["created_on"] as? String ?? ""
            basicQuestSubmitted = dictDat["basic_question_submit"] as? Bool ?? false
            reserachStartDate = dictDat["start_date"] as? String ?? ""
            reserachEndDate = dictDat["end_date"] as? String ?? ""
            pictureSubmission  = dictDat["picture_submission"] as? Int ?? 0
            submissionTimeline = dictDat["submission_timeline"] as? Int ?? 0
            researchId = dictDat["research_id"] as? Int ?? 0
            shareBy = dictDat["created_by_name"] as? String ?? ""
            if let prodName = dictDat["product_name"] as? String {
                 productName = prodName
            }else{
                if let researchDict =  dictDat["Research"] as? NSDictionary{
                     productName = researchDict["product_name"] as? String ?? ""
                    if reserachStartDate == "" || reserachEndDate == "" {
                    reserachStartDate =  researchDict["start_date"] as? String ?? ""
                    reserachEndDate =  researchDict["end_date"] as? String ?? ""
                    }
                }else{
                     productName = ""
                }
            }
            
            }
        }
    }

