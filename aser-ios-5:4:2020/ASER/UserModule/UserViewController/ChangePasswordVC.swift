//
//  ChangePasswordVC.swift
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
class ChangePasswordVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var txtFldNewPassword: UITextField!
    @IBOutlet weak var txtFldRePassword: UITextField!
    
    // For color change
    @IBOutlet weak var topNavBarView: UIView!
    @IBOutlet weak var bottomNavBarView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var changePasswordObj = ChangePasswordVM()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:-Actions
    @IBAction func btnbACK(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    @IBAction func btnChangePassword(_ sender: UIButton) {
        if txtFldNewPassword.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.newPassword)
        }
            // himanshu rajput
//        else if
//            Proxy.shared.isValidPassword(txtFldNewPassword.text!) == false{
//            Proxy.shared.displayStatusCodeAlert(AlertMsgs.validPassword)
//        }
        else if txtFldRePassword.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.repeatPassword)
        } else if txtFldNewPassword.text! != txtFldRePassword.text!{
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.wrongConfirmPassword)
        }else{
        changePasswordObj.password = txtFldNewPassword.text!
            changePasswordObj.changePasswordApi {
                Proxy.shared.displayStatusCodeAlert(AlertMsgs.changePasswordSuccessfully)
                Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
            }
        }
    }
}
