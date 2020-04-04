
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
class ResetPasswordVC: UIViewController {
    
    

    @IBOutlet weak var txtFldEmail: UITextField!
    
    //for color change
    @IBOutlet weak var resetPswdBtn: UIButton!
    @IBOutlet weak var bckgrndImageView: UIImageView!
    @IBOutlet weak var bckBtn: UIButton!
    @IBOutlet weak var forgotPswdLbl: UILabel!
    
     var objResetPasswordVM = ResetPasswordVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func actionResetPWD(_ sender: UIButton) {
        if txtFldEmail.isBlank{
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.email)
        }else if !Proxy.shared.isValidEmail(txtFldEmail.text!){
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.validEmail)
        }else{
            let param = [ "email" : txtFldEmail.text!]  as [String:AnyObject] //"User[email]" : txtFldEmail.text!
                
            objResetPasswordVM.resetPassword(param: param) {
                Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
            }
        }
    }
}
