
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
import UIKit
class AppointmentVM {
    var cameFrom = String()
    var patientID = Int()
    var dateApp = String()
    var pageCount = 0
    var totalPageCount = 0
    var arrAppointments = [AppointmentModel]()
    func getAppointments(_ completion:@escaping() -> Void){
        var urlString = String()
        if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue && patientID != 0 {
            urlString = "\(Apis.KGetPatientAppointments)\(patientID)&page=\(pageCount)"
        } else {
            urlString = "\(Apis.KGetMyAppointment)\(pageCount)"
        }
        WebServiceProxy.shared.getData(urlString, showIndicator: true) { (response) in
            if response.success{
                if let responsedict =  response.data {
                    if let dictMeta = responsedict["_meta"] as? NSDictionary{
                        if let totalPages = dictMeta["pageCount"] as? Int {
                            self.totalPageCount = totalPages
                        }
                    }
                    if self.pageCount == 0 {
                        self.arrAppointments.removeAll()
                    }
                    if let resArrr = responsedict["list"] as? NSArray {
                        for i in 0..<resArrr.count{
                            if let dictData = resArrr[i] as? NSDictionary{
                                let objVM = AppointmentModel()
                                objVM.getAppointmentDet(dictApp: dictData)
                                self.arrAppointments.append(objVM)
                            }
                        }
                    }
                }
                completion()
            }else{
                if self.pageCount == 0{
                    Proxy.shared.displayStatusCodeAlert(response.message!)
                }
            }
        }
    }
    
    func changeStateApp(_ appId:Int, stateID:Int, completion:@escaping()-> Void ) {
        let paramVal = NSMutableDictionary()
        var param = [String:AnyObject]()
        var userId = String()
        if stateID != AppointmentState.Pending.rawValue {
            param = [
                "state_id": stateID as AnyObject] as [String:AnyObject]
        } else {
            param = [
                "date": dateApp as AnyObject,
                "state_id": stateID  as AnyObject] as [String:AnyObject]
        }
        paramVal.setValue(param, forKey: "Appointment")
        WebServiceProxy.shared.postData("\(Apis.KGetUpdateAppointment)\(appId)", params: paramVal as? Dictionary<String, AnyObject>, showIndicator: true) { (response) in
            if response.success {
                completion()
            }else {
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
        }
    }
}
extension AppointmentListVC: UITableViewDelegate,UITableViewDataSource,ResheduleDet{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objAppointmentVM.arrAppointments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentListTVC", for: indexPath) as! AppointmentListTVC
        let dictApp = objAppointmentVM.arrAppointments[indexPath.row]
        cell.lblDateAndTime.text = Proxy.shared.changeDateFormat(dictApp.dateForAppointment!, oldFormat: "yyyy-MM-dd HH:mm:ss", dateFormat: "dd MMM yyyy hh:mm a")
        cell.lblHealthIssue.text = dictApp.healthProblem
        cell.lblAppointmentId.text = "Appointment Id : \(dictApp.id!)"
//        cell.btnPrescription.tag = indexPath.row
        cell.btnCall.tag = indexPath.row
        cell.btnCancel.tag = indexPath.row
        cell.btnReSchedule.tag = indexPath.row
        cell.cnstHeightForButtons.constant = 30
        cell.btnCall.addTarget(self, action: #selector(makeCallToPatient(sender:)), for: .touchUpInside)
        cell.btnCancel.addTarget(self, action: #selector(cancelAppointment(sender:)), for: .touchUpInside)
        cell.btnReSchedule.addTarget(self, action: #selector(reScheduleAppointment(sender:)), for: .touchUpInside)
//        cell.btnPrescription.addTarget(self, action: #selector(gotoPrescription(sender:)), for: .touchUpInside)
        cell.lblPatientName.text = dictApp.userName
        if dictApp.userProfileFile != nil {
        cell.imgViewPatient.sd_setImage(with: URL(string: dictApp.userProfileFile!), placeholderImage: UIImage(named: "ic_profile-1"))
        }
        if KAppDelegate.loginTypeVal == UserRole.Patient.rawValue {
           
            cell.lblGender.isHidden = false
            cell.lblGender.text = KAppDelegate.objUserDetailModel.designation
            switch dictApp.stateId {
            case AppointmentState.InActive.rawValue:
                cell.btnCancel.isHidden = true
                cell.btnReSchedule.isHidden = true
                cell.cnstHeightForButtons.constant = 0
                cell.lblAppointmentStatus.text = "Cancelled"
            case AppointmentState.Complete.rawValue:
                cell.btnCancel.isHidden = true
                cell.btnReSchedule.isHidden = true
                cell.cnstHeightForButtons.constant = 0
                cell.lblAppointmentStatus.text = "Completed"
            case AppointmentState.Active.rawValue:
                cell.btnCancel.isHidden = false
                cell.btnReSchedule.isHidden = false
                cell.lblAppointmentStatus.text = "Scheduled"
            default:
                cell.btnCancel.isHidden = false
                cell.btnReSchedule.isHidden = false
                cell.lblAppointmentStatus.text = "Pending"
            }
        } else {
            cell.btnCancel.isHidden = false
            cell.btnReSchedule.isHidden = false
//            cell.lblPatientName.text = KAppDelegate.objUserDetailModel.fullName
//            cell.imgViewPatient.sd_setImage(with: URL(string: KAppDelegate.objUserDetailModel.profileImage), placeholderImage: UIImage(named: "ic_profile-1"))
            cell.lblGender.isHidden = true
            
           
            switch dictApp.stateId {
            case AppointmentState.InActive.rawValue:
                cell.btnCancel.isHidden = true
                cell.btnReSchedule.isHidden = true
                cell.cnstHeightForButtons.constant = 0
                cell.lblAppointmentStatus.text = "Cancelled"
            case AppointmentState.Complete.rawValue:
                cell.btnCancel.isHidden = true
                cell.btnReSchedule.isHidden = true
                cell.cnstHeightForButtons.constant = 0
                cell.lblAppointmentStatus.text = "Completed"
            case AppointmentState.Active.rawValue:
                cell.btnReSchedule.setTitle("Complete", for: .normal)
                cell.lblAppointmentStatus.text = "Scheduled"
            default:
                cell.btnReSchedule.setTitle("Schedule", for: .normal)
                cell.lblAppointmentStatus.text = "Pending"
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 220
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictApp = objAppointmentVM.arrAppointments[indexPath.row]
        let detVC = mainStoryboard.instantiateViewController(withIdentifier: "AppointmentDetailVC") as! AppointmentDetailVC
        detVC.objAppDetVM.appointmentDet = dictApp
        self.navigationController?.pushViewController(detVC, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == objAppointmentVM.arrAppointments.count-1{
            if objAppointmentVM.pageCount+1 < objAppointmentVM.totalPageCount{
                objAppointmentVM.pageCount += 1
                objAppointmentVM.getAppointments {
                    self.tblVwAppointment.reloadData()
                }
            }
        }
    }
    @objc func makeCallToPatient(sender:UIButton){
         let dictApp = objAppointmentVM.arrAppointments[sender.tag]
        if dictApp.userContact != "" {
            if dictApp.userContact != nil {
        if let url = URL(string: "tel://\(dictApp.userContact!)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
            } else {
              Proxy.shared.displayStatusCodeAlert("Phone number not available")
            }
        } else {
            Proxy.shared.displayStatusCodeAlert("Phone number not available")
        }
    }
    @objc func gotoPrescription(sender:UIButton){
        let dictApp = objAppointmentVM.arrAppointments[sender.tag]
        let reportsVC = mainStoryboard.instantiateViewController(withIdentifier: "PrescriptionListVC") as! PrescriptionListVC
        reportsVC.objPresc.dictAppointment = dictApp
        self.navigationController?.pushViewController(reportsVC, animated: true)
    }
    @objc func cancelAppointment(sender:UIButton){
        let dictApp = objAppointmentVM.arrAppointments[sender.tag]
        objAppointmentVM.changeStateApp(dictApp.id!, stateID: AppointmentState.InActive.rawValue) {
            self.objAppointmentVM.getAppointments {
                self.tblVwAppointment.reloadData()
                if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue{
                    let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "CancelAppointmentVC") as! CancelAppointmentVC
                    nextVC.patientId = self.objAppointmentVM.patientID
                    self.navigationController?.present(nextVC, animated: true, completion: nil)
                }
            }
        }
    }
    @objc func reScheduleAppointment(sender:UIButton){
        let dictApp = objAppointmentVM.arrAppointments[sender.tag]
        if sender.titleLabel?.text == "Schedule"{
            objAppointmentVM.changeStateApp(dictApp.id!, stateID: AppointmentState.Active.rawValue) {
                self.reloadData()
            }
        } else if sender.titleLabel?.text == "Complete"{
            objAppointmentVM.changeStateApp(dictApp.id!, stateID: AppointmentState.Complete.rawValue) {
                self.reloadData()
            }
        } else {
            let presentVC = mainStoryboard.instantiateViewController(withIdentifier: "ReScheduleVC") as! ReScheduleVC
            presentVC.indexVal = sender.tag
            self.navigationController?.present(presentVC, animated: true, completion: nil)
        }
    }
    //MARK:- Handle delegate for reshedule
    func rescheduleDetails(_ dateVal: String, indexVal: Int) {
        let dictApp = objAppointmentVM.arrAppointments[indexVal]
        objAppointmentVM.dateApp = Proxy.shared.changeDateFormat(dateVal, oldFormat: "dd MMM, yyyy hh mm a", dateFormat: "yyyy-MM-dd HH:MM:ss")
        objAppointmentVM.changeStateApp(dictApp.id!, stateID: AppointmentState.Pending.rawValue) {
            self.objAppointmentVM.getAppointments {
                self.tblVwAppointment.reloadData()
            }
        }
    }
    func reloadData(){
        self.objAppointmentVM.getAppointments {
            self.tblVwAppointment.reloadData()
        }
    }
}
