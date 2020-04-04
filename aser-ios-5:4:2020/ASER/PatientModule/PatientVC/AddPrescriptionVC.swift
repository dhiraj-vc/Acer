
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

class AddPrescriptionVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var txtFldPatientName: UITextField!
    @IBOutlet weak var txtViewPrescription: UITextView!
    @IBOutlet weak var btnAddTitle: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    var objAddPresVM =  AddPrescriptionVM()
    var objPatientDet = PatientDetailVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFldPatientName.text = KAppDelegate.patientDet.fullname
        if objAddPresVM.dictPres.detail != nil {
            btnAddTitle.setTitle("Update", for: .normal)
            lblTitle.text = "Edit Prescription"
            txtViewPrescription.text = objAddPresVM.dictPres.detail
        } else {
            btnAddTitle.setTitle("Add", for: .normal)
            lblTitle.text = "Add Prescription"
        }
    }
    //MARK:- Actions
    
    @IBAction func btnAdd(_ sender: UIButton) {
        var paramVal = [String:AnyObject]()
        if objAddPresVM.cameFrom == "Edit" {
            paramVal = ["PrescribedActivities[description]": txtViewPrescription.text! ] as [String:AnyObject]
        } else {
            paramVal = [
                "PrescribedActivities[appointment_id]": objAddPresVM.dictAppointment.id  as AnyObject,
                "PrescribedActivities[description]": txtViewPrescription.text! ] as [String:AnyObject]
        }
        objAddPresVM.addPrescription(paramVal) {
            Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
        }
    }
    @IBAction func btnActionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
}
