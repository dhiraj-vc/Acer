
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

class AppointmentListVC: UIViewController {
    
    //Mark: - Varriable
    var objAppointmentVM = AppointmentVM()

    //Mark: - IB Outlets
    @IBOutlet weak var tblVwAppointment: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var btnEmergencyCall: UIButton!
    @IBOutlet weak var cnstWidthForbutton: NSLayoutConstraint!
    
    //Mark: - View Life Cycle
    override func viewDidLoad() {
       
        if KAppDelegate.loginTypeVal == UserRole.Patient.rawValue {
             btnBook.isHidden = false
             btnEmergencyCall.isHidden = false
             cnstWidthForbutton.constant = 40.0
        } else {
             btnBook.isHidden = true
            btnEmergencyCall.isHidden = true
            cnstWidthForbutton.constant = 0.0
        }
        reSheduleDetail = self
        self.tblVwAppointment.register(UINib.init(nibName: "AppointmentListTVC", bundle: nil), forCellReuseIdentifier: "AppointmentListTVC")
        if objAppointmentVM.cameFrom == "PatientDet" {
           btnBack.setTitle("Back", for: .normal)
        } else {
            btnBack.setTitle("", for: .normal)
            btnBack.setImage(UIImage(named: "ic_menu"), for: .normal)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshList), name: NSNotification.Name("RefreshList"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        objAppointmentVM.getAppointments {
            if self.objAppointmentVM.arrAppointments.count>0{
                self.tblVwAppointment.isHidden = false
                self.tblVwAppointment.reloadData()
            } else {
                self.tblVwAppointment.isHidden = true
            }
        }
    }
    
    //MARK:- actions
    @IBAction func btnBackAction(_ sender: Any) {
        if objAppointmentVM.cameFrom == "PatientDet" {
            Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
        } else {
            sideMenuViewController?._presentLeftMenuViewController()
        }
    }
    @IBAction func btnBookAppointment(_ sender: UIButton) {
        Proxy.shared.pushToNextVC(identifier: "BookAppointmentsVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func btnEmergencyCall(_ sender: UIButton) {
        let phoneNo = AppInfo.EmergencyNo
        if let url = URL(string: "tel://\(phoneNo)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }    
    //MARK:- Handle Notification Method
    @objc func refreshList(){
        viewWillAppear(true)
    }
}
