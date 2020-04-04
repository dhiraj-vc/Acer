
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

class AddPrescriptionVM: NSObject {
    var dictAppointment = AppointmentModel()
    var dictPres = PrescriptionModel()
    var arrPrescList = [PrescriptionModel]()
    var cameFrom = String()
    var pageCount = 0
    var totalPageCount = 0
    func addPrescription(_ params: [String:AnyObject], completion:@escaping()-> Void ) {
        var urlString = String()
        if cameFrom == "Edit"{
            urlString = "\(Apis.KEditPrescription)\(dictPres.id!)"
        } else {
            urlString =  Apis.KAddPrescription
        }
        WebServiceProxy.shared.postData(urlString, params: params, showIndicator: true) { (response) in
            if response.success {
                completion()
            } else {
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
        }
    }
    func listPrescription(_ completion:@escaping()-> Void ) {
        var urlString = String()
        if dictAppointment.id != nil {
            urlString = "\(Apis.KListPrescription)\(dictAppointment.id!)&page=\(pageCount)"
        } else {
            urlString = "\(Apis.KGetPatientPrescription)\(pageCount)"
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
                        self.arrPrescList.removeAll()
                    }
                    if let resArrr = responsedict["list"] as? NSArray {
                        for i in 0..<resArrr.count{
                            if let dictData = resArrr[i] as? NSDictionary{
                                let objPres = PrescriptionModel()
                                objPres.getPresDet(dictReport: dictData)
                                self.arrPrescList.append(objPres)
                            }
                        }
                    }
                }
                completion()
            } else {
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
        }
    }
    func deletePrescription(_ presId:Int, completion:@escaping()-> Void ) {
        WebServiceProxy.shared.getData("\(Apis.KDeletePrescription)\(presId)", showIndicator: true) { (response) in
            if response.success {
                completion()
            } else {
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
        }
    }
}
extension PrescriptionListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objPresc.arrPrescList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dictPres = objPresc.arrPrescList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrescriptionTVC") as! PrescriptionTVC
        cell.lblName.text = dictPres.username
        cell.lblDescription.text = dictPres.detail
        cell.lblCreatedOn.text = Proxy.shared.changeDateFormat(dictPres.createdOn!, oldFormat: "yyyy-MM-dd HH:mm:ss", dateFormat: "dd MMM, yyyy hh:mm a")
        if KAppDelegate.loginTypeVal == UserRole.Patient.rawValue {
            cell.btnEdit.isHidden = true
            cell.btnDelete.isHidden = true
        } else {
            cell.btnEdit.isHidden = false
            cell.btnDelete.isHidden = false
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(editPrescription(sender:)), for: .touchUpInside)
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(deletePrescription(sender:)), for: .touchUpInside)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == objPresc.arrPrescList.count-1{
            if objPresc.pageCount+1 < objPresc.totalPageCount{
                objPresc.pageCount += 1
                objPresc.listPrescription {
                    self.tblViewPrescription.reloadData()
                }
            }
        }
    }
    //MARK:- Button Actions
    @objc func editPrescription(sender:UIButton){
        let dictPres = objPresc.arrPrescList[sender.tag]
        let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "AddPrescriptionVC") as! AddPrescriptionVC
        nextVC.objAddPresVM.cameFrom = "Edit"
        nextVC.objAddPresVM.dictPres = dictPres
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @objc func deletePrescription(sender:UIButton){
        let dictPres = objPresc.arrPrescList[sender.tag]
        Proxy.shared.alertControl(title: "Delete Prescription", message: AlertMsgs.AREYOUSUREWANTTODELETEPRESCRIPTION) { (alert, boolVal) in
            if boolVal == "true"{
                self.objPresc.deletePrescription(dictPres.id!, completion: {
                    self.objPresc.listPrescription {
                        if self.objPresc.arrPrescList.count>0{
                            self.tblViewPrescription.isHidden = false
                             self.tblViewPrescription.reloadData()
                        } else {
                            self.tblViewPrescription.isHidden = true
                        }
                       
                    }
                })
            } else if boolVal == "false"{
                //HANDLE NO ACTIONS
            } else{
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
