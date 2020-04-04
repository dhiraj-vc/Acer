
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

class WelcomeVC: UIViewController {
    //MARK:- Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(gotoSignup(_:)), name: Notification.Name("SignUpRole"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotoChooseModule(_:)), name: Notification.Name("gotoChooseModule"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("SignUpRole"), object: nil)
        // NotificationCenter.default.removeObserver(self, name: Notification.Name("gotoChooseModule"), object: nil)
    }
    //MARK:- Actions
    @IBAction func btnLogin(_ sender: UIButton) {
        Proxy.shared.pushToNextVC(identifier: "UserSignInVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnSignUp(_ sender: UIButton) {
        Proxy.shared.presentToNextVC(identifier: "ChooseAsSignupOne", isAnimate: true, currentViewController: self)
    }
    @IBAction func btnQuickSurvey(_ sender: UIButton) {
        KAppDelegate.loginTypeVal = UserRole.User.rawValue
        let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "UserSignUpVC") as! UserSignUpVC
        nextVC.signUpVMobj.cameFrom = "Quick Review"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //MARK:- Handle notification
    @objc func gotoSignup(_ notification:Notification){
        if let userRole = notification.object as? Int {
            KAppDelegate.loginTypeVal = userRole
            if KAppDelegate.loginTypeVal > 2 {
                Proxy.shared.pushToNextVC(identifier: "MedicalSignUpVC", isAnimate: true, currentViewController: self)
            } else {
                Proxy.shared.pushToNextVC(identifier: "UserSignUpVC", isAnimate: true, currentViewController: self)
            }
        }
    }
    //MARK:- Handle notification
    @objc func gotoChooseModule(_ notification:Notification){
        if let userRole = notification.object as? String {
            if userRole == "Research" {
                Proxy.shared.presentToNextVC(identifier: "ChooseSignUpVC", isAnimate: true, currentViewController: self)
            } else if userRole == "Medical" {
                Proxy.shared.presentToNextVC(identifier: "MedicalModuleVC", isAnimate: true, currentViewController: self) 
            }
        }
    }
}
