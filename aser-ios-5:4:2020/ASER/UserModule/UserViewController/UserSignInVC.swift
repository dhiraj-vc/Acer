
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
import LocalAuthentication
class UserSignInVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPswrd: UITextField!
    @IBOutlet weak var btnRemember: UIButton!
    var signInVMObj = UserSignInVM()
    // For color change
    
    @IBOutlet weak var bckgrndImage: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var signInLbl: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet weak var signupBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        btnRemember.isSelected = false
        
        if let username = UserDefaults.standard.object(forKey: "loginUsername") as? String
        {
            txtFldEmail.text = username
        }
        if let password = UserDefaults.standard.object(forKey: "loginPassword") as? String
        {
            txtFldPswrd.text = password
            btnRemember.isSelected = true
        }
        
        
}

    //MARK:- Actions
    @IBAction func actionSignIn(_ sender:UIButton){
        if checkVallidation() == true {
            if btnRemember.isSelected{
                UserDefaults.standard.set(txtFldEmail.text, forKey: "loginUsername")
                UserDefaults.standard.set(txtFldPswrd.text, forKey: "loginPassword")
               UserDefaults.standard.synchronize()
            } else {
               UserDefaults.standard.removeObject(forKey: "loginUsername")
               UserDefaults.standard.removeObject(forKey: "loginPassword")
                
            }
            var deviceTokken =  ""
            if UserDefaults.standard.object(forKey: "device_token") == nil {
                deviceTokken = "0000055"
            } else {
                deviceTokken = UserDefaults.standard.object(forKey: "device_token")! as! String
            }
            let param = [
                "username": txtFldEmail.text!,
                "device_token": deviceTokken,
                "device_name" : AppInfo.DeviceName,
                "device_type" : AppInfo.DeviceType,
            "password": txtFldPswrd.text!] as [String:AnyObject]
//            "LoginForm[username]": txtFldEmail.text!,
//            "LoginForm[password]": txtFldPswrd.text!] as [String:AnyObject]
//                "LoginForm[device_token]": deviceTokken ,
//                "LoginForm[device_type]" : AppInfo.DeviceType,
//                "LoginForm[device_name]" : AppInfo.DeviceName] as [String:AnyObject]
            signInVMObj.loginUser(param: param) { (response) in
                self.signInVMObj.handelReponseForPushController(response, view: self)
            }
        }
    }
    @IBAction func actionSignUp(_ sender:UIButton){
//      Proxy.shared.pushToNextVC(identifier: "WelcomeVC", isAnimate: true, currentViewController: self)
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
   }
    @IBAction func actionForgotPWD(_ sender: UIButton) {
         Proxy.shared.pushToNextVC(identifier: "ResetPasswordVC", isAnimate: false, currentViewController: self)
    }
    @IBAction func actionBack(_ sender:UIButton){
        KAppDelegate.loginTypeVal = UserRole.Admin.rawValue
    //    Proxy.shared.pushToNextVC(identifier: "ChooseRoleVC", isAnimate: true, currentViewController: self)
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: WelcomeVC.self) {
               self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    @IBAction func rememberMe(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
     }
   
}
