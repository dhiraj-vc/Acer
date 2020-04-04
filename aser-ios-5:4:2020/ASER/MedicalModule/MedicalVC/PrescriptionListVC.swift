
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

class PrescriptionListVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var tblViewPrescription: UITableView!
    @IBOutlet weak var btnAddPresciption: UIButton!
    var objPresc = AddPrescriptionVM()
    
    //Mark: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAddPresciption.isHidden = KAppDelegate.loginTypeVal == UserRole.Medical.rawValue ? false : true
    }
    override func viewWillAppear(_ animated: Bool) {
        objPresc.listPrescription {
            if self.objPresc.arrPrescList.count>0{
            self.tblViewPrescription.isHidden = false
            self.tblViewPrescription.reloadData()
            } else {
            self.tblViewPrescription.isHidden = true
            }
        }
    }
    //MARK:- Actions
    @IBAction func btnBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    @IBAction func btnAddPrescription(_ sender: UIButton) {
        let reportsVC = mainStoryboard.instantiateViewController(withIdentifier: "AddPrescriptionVC") as! AddPrescriptionVC
        reportsVC.objAddPresVM.dictAppointment = objPresc.dictAppointment
        self.navigationController?.pushViewController(reportsVC, animated: true)
    }
}
