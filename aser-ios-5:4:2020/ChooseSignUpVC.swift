
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

class ChooseSignUpVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK:- Actions
    
    @IBAction func btnSignUPAdmin(_ sender: UIButton) {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name("SignUpRole"), object: UserRole.Admin.rawValue)
        }
    }
    @IBAction func btnSignUpParticipant(_ sender: UIButton) {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name("SignUpRole"), object: UserRole.User.rawValue)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true) {
            //MARK: ACTION
        }
    }
}
