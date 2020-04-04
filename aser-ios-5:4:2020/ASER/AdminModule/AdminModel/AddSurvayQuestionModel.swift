
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
class AddSurvayQuestionModel: NSObject {
    var assignCode, duration, companyName, endDate, pictureSubmission, pictureSubmissionInt, produnctName, startDate, timeLine :String?
    
    var ResearchProgramDict = NSMutableDictionary()
    func addValues(dict:NSMutableDictionary){
        assignCode = dict["Assign Code"] as? String
        companyName = dict["Company Name"] as? String
        duration = dict["Duration"] as? String
        pictureSubmissionInt = dict["Daily Picture Submission"] as? String
        pictureSubmission = (pictureSubmissionInt == "Yes") ? "1" : "0"
        produnctName = dict["Product Name"] as? String
        
        if let strtDateVal =  dict["Research Start Date"] as? String{
            let startDateValue = Proxy.shared.getDateFrmString(getDate: strtDateVal, format: "ddMMM,yyyy")
            let submitDate = Proxy.shared.getStringFrmDate(getDate: startDateValue, format: "yyyy-MM-dd")
              startDate = submitDate
        }
        
        if let endDateVal =  dict["Research End Date"] as? String{
            let startDateValue = Proxy.shared.getDateFrmString(getDate: endDateVal, format: "ddMMM,yyyy")
            let submitDate = Proxy.shared.getStringFrmDate(getDate: startDateValue, format: "yyyy-MM-dd")
            endDate = submitDate
        }
      }
}
