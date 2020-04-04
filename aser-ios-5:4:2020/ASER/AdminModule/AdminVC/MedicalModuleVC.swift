
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

class MedicalModuleVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Mark:-BtnAction Doctor
    @IBAction func btnActionDoctor(_ sender: Any) {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name("SignUpRole"), object: UserRole.Medical.rawValue)
        }
    }
    //Mark:-BtnAction Patient
    @IBAction func btnActionPatient(_ sender: Any) {
        self.dismiss(animated: true) {
           NotificationCenter.default.post(name: NSNotification.Name("SignUpRole"), object: UserRole.Patient.rawValue)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true) {
        }
    }
}
