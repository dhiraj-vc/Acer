
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
class DashboardPatientVM
{
    var dashBoardOptionArray = ["Appointments","Prescribed Activities","My Reports"]
}
extension DashboardPatientVC: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objDashboardPatientVM.dashBoardOptionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVwDashBoardPatients.dequeueReusableCell(withIdentifier: "DashboardPatientTVC", for: indexPath) as! DashboardPatientTVC
        cell.lbldashboardOptions.text! = objDashboardPatientVM.dashBoardOptionArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let appointmentVC = mainStoryboard.instantiateViewController(withIdentifier: "AppointmentListVC") as! AppointmentListVC
            KAppDelegate.currentViewCont = appointmentVC
            appointmentVC.objAppointmentVM.cameFrom = "PatientDet"
            self.navigationController?.pushViewController(appointmentVC, animated: true)
        case 1:
            Proxy.shared.pushToNextVC(identifier: "PrescriptionListVC", isAnimate: true, currentViewController: self)
        case 2:
            let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "MyReportsVC") as! MyReportsVC
            nextVC.galleryVMObj.cameFrom = ""
            self.navigationController?.pushViewController(nextVC, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

