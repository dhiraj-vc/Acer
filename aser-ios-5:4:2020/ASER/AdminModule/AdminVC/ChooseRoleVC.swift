
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
class ChooseRoleVC: UIViewController {
    
    @IBOutlet weak var loginAdminBtn: UIButton!
    @IBOutlet weak var loginParticipentBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- Actions
    @IBAction func btnAdminSignUp(_ sender: UIButton) {
        KAppDelegate.loginTypeVal = UserRole.Admin.rawValue
        Proxy.shared.pushToNextVC(identifier: "UserSignInVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnUserSignUp(_ sender: UIButton) {
        KAppDelegate.loginTypeVal = UserRole.User.rawValue
        Proxy.shared.pushToNextVC(identifier: "UserSignInVC", isAnimate: true, currentViewController: self)
    }    
}
