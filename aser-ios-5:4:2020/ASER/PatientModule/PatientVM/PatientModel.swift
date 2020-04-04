
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

class PatientModel: NSObject {
    var fullname, profileImage : String?
    var patientID,createdBy,doctorID,stateID : Int?
    func getPatientDet(_ dictDet: NSDictionary){
        if let dictPatient = dictDet["patient"] as? NSDictionary {
            fullname = dictPatient["full_name"] as? String ?? ""
            profileImage = dictPatient["profile_file"] as? String ?? ""
        }
        patientID = dictDet["patient_id"] as? Int ?? 0
        doctorID = dictDet["doctor_id"] as? Int ?? 0
        createdBy = dictDet["created_by_id"] as? Int ?? 0
        stateID = dictDet["state_id"] as? Int ?? 0
    }
}

class PatientDetModel: NSObject {
    var fullname, profileImage : String?
    var patientID,createdBy,doctorID,stateID : Int?
    var arrAppointments = [AppointmentModel]()
    var arrReport = [GalleryModel]()
    func getPatientDet(_ dictDet: NSDictionary){
        fullname = dictDet["full_name"] as? String ?? ""
        profileImage = dictDet["profile_file"] as? String ?? ""
        patientID = dictDet["patient_id"] as? Int ?? 0
        if let arrApp = dictDet["appointments"] as? NSArray{
            arrAppointments.removeAll()
            for i in 0..<arrApp.count {
                if let dictApp = arrApp[i] as? NSDictionary {
                    let objApp = AppointmentModel()
                    objApp.getAppointmentDet(dictApp: dictApp)
                    arrAppointments.append(objApp)
                }
            }
        }
        if let arrReports = dictDet["reports"] as? NSArray{
            arrReport.removeAll()
            for i in 0..<arrReports.count {
                if let dictReport = arrReports[i] as? NSDictionary {
                    let objReport = GalleryModel()
                    objReport.getGallery(dictReport)
                    arrReport.append(objReport)
                }
            }
        } else {
            arrReport.removeAll()
        }
    }
}
