
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

class AppointmentDetailVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var imgViewPatient: UIImageView!
    @IBOutlet weak var lblPatientName: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblAppointmentStatus: UILabel!
    @IBOutlet weak var lblHealthIssue: UILabel!
    @IBOutlet weak var lblDateAndTime: UILabel!
    @IBOutlet weak var lblAppointmentId: UILabel!
    @IBOutlet weak var clcViewReports: UICollectionView!
    @IBOutlet weak var viewForCollection: UIView!
    @IBOutlet weak var viewForTitleReports: UIView!
    @IBOutlet weak var cnstHeightForView: NSLayoutConstraint!
    
    var objAppDetVM = AppointmentDetailVM()
  
    
    //Mark: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
         self.clcViewReports.register(UINib(nibName: "PatientDetialCVC", bundle: nil), forCellWithReuseIdentifier: "PatientDetialCVC")
        setDate()
    }
    func setDate(){
        lblPatientName.text = KAppDelegate.objUserDetailModel.fullName
        imgViewPatient.sd_setImage(with: URL(string: KAppDelegate.objUserDetailModel.profileImage), placeholderImage: UIImage(named: "ic_profile-1"))
        lblDateAndTime.text = Proxy.shared.changeDateFormat(objAppDetVM.appointmentDet.dateForAppointment!, oldFormat: "yyyy-MM-dd HH:mm:ss", dateFormat: "dd MMM yyyy hh:mm a")
        lblHealthIssue.text = objAppDetVM.appointmentDet.healthProblem
        lblAppointmentId.text = "Appointment Id : \(objAppDetVM.appointmentDet.id!)"
        if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue{
            lblGender.text = KAppDelegate.objUserDetailModel.designation
        } else {
            lblGender.isHidden = true
        }
        if objAppDetVM.appointmentDet.arrReports.count>0 {
            viewForCollection.isHidden = false
            viewForTitleReports.isHidden = false
            cnstHeightForView.constant = 150
        } else {
            viewForCollection.isHidden = true
            viewForTitleReports.isHidden = true
            cnstHeightForView.constant = 0
        }
    }
    
    //MARK:- Actions
    
    @IBAction func btnBookAppointment(_ sender: UIButton) {
        let bookVC = mainStoryboard.instantiateViewController(withIdentifier: "BookAppointmentsVC") as! BookAppointmentsVC
        bookVC.objBookAppointmentsVM.patientId = "\(objAppDetVM.appointmentDet.userId!)"
        self.navigationController?.pushViewController(bookVC, animated: true)
    }
    
    @IBAction func btnViewReports(_ sender: UIButton) {
        let reportsVC = mainStoryboard.instantiateViewController(withIdentifier: "MyReportsVC") as! MyReportsVC
        reportsVC.galleryVMObj.appointmentID = objAppDetVM.appointmentDet.id!
        reportsVC.galleryVMObj.cameFrom = "Appointment"
        self.navigationController?.pushViewController(reportsVC, animated: true)
    }
    
    @IBAction func btnViewPrescription(_ sender: UIButton) {
        let reportsVC = mainStoryboard.instantiateViewController(withIdentifier: "PrescriptionListVC") as! PrescriptionListVC
        reportsVC.objPresc.dictAppointment = objAppDetVM.appointmentDet
        self.navigationController?.pushViewController(reportsVC, animated: true)
    }
    @IBAction func btnBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    @IBAction func btnAddReports(_ sender: UIButton) {
      btnViewReports(UIButton())
    }
    @IBAction func btnAction(_ sender: UIButton) {
        if objAppDetVM.appointmentDet.userContact != "" {
            if objAppDetVM.appointmentDet.userContact != nil {
            if let url = URL(string: "tel://\(objAppDetVM.appointmentDet.userContact!)"), UIApplication.shared.canOpenURL(url) {
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
    
}
