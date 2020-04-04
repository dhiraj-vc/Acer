
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
class UserSignUpVC: UIViewController {
    //MARK:- OUTLETS
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var txtFldFirstName: UITextField!
    @IBOutlet weak var txtFldLastName: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPswrd: UITextField!
    @IBOutlet weak var txtFldConfirmPswrd: UITextField!
    @IBOutlet weak var txtFldRole: UITextField!
    @IBOutlet weak var viewForUser: UIView!
    @IBOutlet weak var viewForAdmin: UIView!
    @IBOutlet weak var btnTermsAndCondition: UIButton!
    @IBOutlet weak var txtFldDesignation: UITextField!
    @IBOutlet weak var vwDesignation: UIView!
    @IBOutlet weak var cnstHeightVwDesignation: NSLayoutConstraint!
    // for color change
    @IBOutlet weak var bckgrndImageView: UIImageView!
    
    @IBOutlet weak var alreadySignIn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var navigationBarView: UIView!
    
    
    var signUpVMobj = UserSignUpVM()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpVMobj.picker.delegate = self
        signUpVMobj.picker.dataSource = self
        signUpVMobj.picker.reloadAllComponents()
        txtFldRole.inputView = signUpVMobj.picker
    }
    override func viewWillAppear(_ animated: Bool) {
        if KAppDelegate.loginTypeVal == UserRole.User.rawValue {
            if signUpVMobj.cameFrom == "Quick Review" {
                lblMainTitle.text = "Quick Product Review Sign up"
            } else {
                lblMainTitle.text = "Signup as Participant"
            }
            viewForUser.isHidden = false
            txtFldEmail.placeholder = "Email"
            vwDesignation.isHidden = true
            cnstHeightVwDesignation.constant = 0
        }else if  KAppDelegate.loginTypeVal == UserRole.Medical.rawValue {
            lblMainTitle.text = "Signup as Doctor"
        }
        else if  KAppDelegate.loginTypeVal == UserRole.Patient.rawValue {
            lblMainTitle.text = "Signup as Patient"
        } else {
            lblMainTitle.text = "Signup as Administrator"
            viewForUser.isHidden = true
            txtFldEmail.placeholder =  "Email (AZ/STT)"
            vwDesignation.isHidden = false
            cnstHeightVwDesignation.constant = 50
        }
        txtFldEmail.placeHolderColor = Colours.PlaceHolderColor
    }
    
    //MARK:-ACTIONS
    @IBAction func actionSignUp(_ sender:UIButton){
        if checkVallidation() == true {
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
//                "User[sub_role_id]": subRoleID,
//                "User[designation]": txtFldDesignation.text!,
//                "LoginForm[device_token]": deviceTokken ,
//                "LoginForm[device_type]": AppInfo.DeviceType,
//                "LoginForm[device_name]": AppInfo.DeviceName,
                "first_name": txtFldFirstName.text!,
                "last_name": txtFldLastName.text!,
                "email": txtFldEmail.text! ,
                "password": txtFldPswrd.text!,
                "sub_role_id": subRoleID,
                "designation": txtFldDesignation.text!,
                "device_token": deviceTokken ,
                "device_type": AppInfo.DeviceType,
                "device_name": AppInfo.DeviceName,
                "is_user" : KAppDelegate.loginTypeVal ] as [String: AnyObject]
            signUpVMobj.saveSignUpDetail(param: param) { (response) in
                self.signUpVMobj.handelReponseForPushController(response, view: self)
            }
        }
    }
    @IBAction func actionSignIn(_ sender:UIButton){
        KAppDelegate.loginTypeVal = UserRole.Admin.rawValue
        
        Proxy.shared.pushToNextVC(identifier: "UserSignInVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func actionAction(_ sender:UIButton){
        KAppDelegate.loginTypeVal = UserRole.Admin.rawValue
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: WelcomeVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    @IBAction func actionNavigateToTermsPage(_ sender: UIButton) {
        Proxy.shared.pushToNextVC(identifier: "WKWebViewVC", isAnimate: true, currentViewController: self, title:"Terms & Conditions")
    }
    @IBAction func actionTermsAndCondition(_ sender:UIButton){
        btnTermsAndCondition.isSelected = !sender.isSelected
    }
}
