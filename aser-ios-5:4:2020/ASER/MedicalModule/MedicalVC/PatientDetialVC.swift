
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

class PatientDetialVC: UIViewController {
    
    //Mark: - Outlets
    @IBOutlet weak var appointmentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collVWReportsUpload: UICollectionView!
    @IBOutlet weak var tblVWAppointmentsDate: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPatientProfile: UILabel!
    @IBOutlet weak var imgViewPatient: UIImageView!
    @IBOutlet weak var viewForLabalReports: UIView!
    @IBOutlet weak var viewForReports: UIView!
    var objPatientDetVM = PatientDetailVM()
   
    //Mark: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblVWAppointmentsDate.register(UINib.init(nibName: "PatientDetialTVC", bundle: nil), forCellReuseIdentifier: "PatientDetialTVC")
        self.collVWReportsUpload.register(UINib(nibName: "PatientDetialCVC", bundle: nil), forCellWithReuseIdentifier: "PatientDetialCVC")
    }
    override func viewWillAppear(_ animated: Bool) {
        objPatientDetVM.getPatientDet {
            self.lblTitle.text = KAppDelegate.patientDet.fullname
            self.lblPatientProfile.text = KAppDelegate.patientDet.fullname
            self.imgViewPatient.sd_setImage(with: URL(string: KAppDelegate.patientDet.profileImage!), placeholderImage: UIImage(named:"ic_profile-1"))
            self.tblVWAppointmentsDate.reloadData()
            self.appointmentHeightConstraint.constant = CGFloat(self.tblVWAppointmentsDate.contentSize.height)
            if KAppDelegate.patientDet.arrReport.count>0{
                self.viewForReports.isHidden = false
                self.viewForLabalReports.isHidden = false
                self.collVWReportsUpload.reloadData()
            } else {
                self.viewForReports.isHidden = true
                self.viewForLabalReports.isHidden = true
            }
        }
    }
    //MARK:- Actions
    @IBAction func btnActionBack(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    @IBAction func btnActionAppointment(_ sender: Any) {
        let appointmentVC = mainStoryboard.instantiateViewController(withIdentifier: "AppointmentListVC") as! AppointmentListVC
        KAppDelegate.currentViewCont = appointmentVC
        appointmentVC.objAppointmentVM.cameFrom = "PatientDet"
        appointmentVC.objAppointmentVM.patientID = objPatientDetVM.patientID
        self.navigationController?.pushViewController(appointmentVC, animated: true)
    }
    @IBAction func btnViewAllReport(_ sender: UIButton) {
        let reportVC = mainStoryboard.instantiateViewController(withIdentifier: "MyReportsVC") as! MyReportsVC
        reportVC.galleryVMObj.patientId = objPatientDetVM.patientID
        self.navigationController?.pushViewController(reportVC, animated: true)
    }
    @IBAction func btnMsgChatAction(_ sender: Any) {
        let chatVC = mainStoryboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.objChatVM.messageToId = objPatientDetVM.patientID
        KAppDelegate.currentViewCont = chatVC
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    @IBAction func btnBookAppointment(_ sender: UIButton) {
        let bookVC = mainStoryboard.instantiateViewController(withIdentifier: "BookAppointmentsVC") as! BookAppointmentsVC
        bookVC.objBookAppointmentsVM.patientId = "\(objPatientDetVM.patientID)"
        self.navigationController?.pushViewController(bookVC, animated: true)
    }
}
