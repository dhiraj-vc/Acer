
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

class AppointmentModel: NSObject {
    var createdBy,id,stateId,userId,typeId:Int?
    var createdOn,dateForAppointment,healthProblem,userName,userContact,userCode,userDesig,userProfileFile,userID: String?
    var arrReports = [GalleryModel]()
    func getAppointmentDet(dictApp:NSDictionary){
        createdBy = dictApp["created_by_id"] as? Int ?? 0
        id = dictApp["id"] as? Int ?? 0
        stateId = dictApp["state_id"] as? Int ?? 0
        if let userid = dictApp["user_id"] as? Int  {
            userId = userid
        } else if let userid = dictApp["user_id"] as? String {
            if userid == "" {
                userId = 0
            } else {
                userId = Int(userid)!
            }
        }
        
        typeId = dictApp["type_id"] as? Int ?? 0
        createdOn = dictApp["created_on"] as? String ?? ""
        dateForAppointment = dictApp["date"] as? String ?? ""
        healthProblem = dictApp["problems"] as? String ?? ""
        if let dictUser = dictApp["user"] as? NSDictionary {
            userName = dictUser["full_name"] as? String ?? ""
            userContact = dictUser["contact_no"] as? String ?? ""
            userCode = dictUser["access_code"] as? String ?? ""
            userDesig = dictUser["designation"] as? String ?? ""
            userProfileFile = dictUser["profile_file"] as? String ?? ""
            
        }
        if let arrReport = dictApp["reports"] as? NSArray {
            for i in 0..<arrReport.count {
                if let dictReport = arrReport[i] as? NSDictionary {
                    let objReports = GalleryModel()
                    objReports.getGallery(dictReport)
                    arrReports.append(objReports)
                }
            }
        }
    }
}

class PrescriptionModel: NSObject {
    var createdBy,id,appId:Int?
    var createdOn,detail,username: String?
    func getPresDet(dictReport:NSDictionary){
        appId       = dictReport["appointment_id"] as? Int ?? 0
        createdBy   = dictReport["created_by_id"] as? Int ?? 0
        id          = dictReport["id"] as? Int ?? 0
        createdOn   = dictReport["created_on"] as? String ?? ""
        detail      = dictReport["description"] as? String ?? ""
        username    = dictReport["username"] as? String ?? ""
        
    }
}
class DoctorSubscriptionPlans: NSObject {
    var plan_pricing,patients_limit,plan_validity, plan_id:Int?
    var ios_plan_id, title: String?
    func getPresDet(dictReport:NSDictionary){
        plan_pricing       = dictReport["plan_pricing"] as? Int ?? 0
        patients_limit   = dictReport["patients_limit"] as? Int ?? 0
        plan_validity          = dictReport["plan_validity"] as? Int ?? 0
        plan_id          = dictReport["id"] as? Int ?? 0
        ios_plan_id   = dictReport["ios_plan_id"] as? String ?? ""
        title   = dictReport["title"] as? String ?? ""

    }
}
