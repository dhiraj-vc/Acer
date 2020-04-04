
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

class MedicalSignUpVC: UIViewController {
    //MARK:- OUTLETS
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var txtFldFirstName: UITextField!
    @IBOutlet weak var txtFldLastName: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPswrd: UITextField!
    @IBOutlet weak var txtFldConfirmPswrd: UITextField!
    @IBOutlet weak var txtFldRole: UITextField!
    @IBOutlet weak var cnstHeightVwDesignation: NSLayoutConstraint!
    @IBOutlet weak var imgViewDoctorCode: UIImageView!

    
//

    public static let SwiftShopping = "com.theNameYouPickedEarlier.razefaces.swiftshopping"

    var signUpVMobj = MedicalSignUpVM()
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if  KAppDelegate.loginTypeVal == UserRole.Medical.rawValue {
            lblMainTitle.text = "Signup as Doctor"
            txtFldRole.placeholder = "Designation"
            imgViewDoctorCode.image = UIImage(named:"ic_name")
            
        } else {
         
            txtFldRole.placeholder = "Doctor's Code"
            imgViewDoctorCode.image = UIImage(named:"ic_doctor_code")
        }
        
    }
  
    //MARK:-ACTIONS
  
    
    @IBAction func actionSignUp(_ sender:UIButton)
    {
        if checkVallidation(){
            var deviceTokken =  ""
            if UserDefaults.standard.object(forKey: "device_token") == nil {
                deviceTokken = "0000055"
            } else {
                deviceTokken = UserDefaults.standard.object(forKey: "device_token")! as! String
            }
            var subRoleID = String()
            if txtFldRole.text ==  StaticData.AdminRole[0][0]{
                subRoleID = StaticData.AdminRole[0][1]
            }else if txtFldRole.text ==  StaticData.AdminRole[1][0]{
                subRoleID = StaticData.AdminRole[1][1]
            }
            let param = [
//                "User[first_name]": txtFldFirstName.text!,
//                "User[last_name]": txtFldLastName.text!,
//                "User[email]": txtFldEmail.text! ,
//                "User[password]": txtFldPswrd.text!,
//                "User[designation]": txtFldRole.text!,
//                "User[access_code]": txtFldRole.text!,
//                "LoginForm[device_token]": deviceTokken,
//                "LoginForm[device_type]": AppInfo.DeviceType,
//                "LoginForm[device_name]": AppInfo.DeviceName,
                "first_name": txtFldFirstName.text!,
                "last_name": txtFldLastName.text!,
                "email": txtFldEmail.text! ,
                "password": txtFldPswrd.text!,
                "designation": txtFldRole.text!,
                "access_code": txtFldRole.text!,
                "device_token": deviceTokken,
                "device_type": AppInfo.DeviceType,
                "device_name": AppInfo.DeviceName,
                "is_user" : KAppDelegate.loginTypeVal] as [String: AnyObject]
            signUpVMobj.saveSignUpDetail(param: param) { (response) in
                
                  self.signUpVMobj.handelReponseForPushController(response, view: self)
                  {
                    
                }
            }
        }
    }
    

    @IBAction func actionSignIn(_ sender:UIButton) {
        KAppDelegate.loginTypeVal = UserRole.Admin.rawValue
        Proxy.shared.rootWithoutDrawer(identifier: "WelcomeVC")
    }
    @IBAction func actionAction(_ sender:UIButton) {
        KAppDelegate.loginTypeVal = UserRole.Admin.rawValue
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: WelcomeVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
}
