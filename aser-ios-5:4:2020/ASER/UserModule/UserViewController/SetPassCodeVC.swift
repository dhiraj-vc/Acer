
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
class SetPassCodeVC: UIViewController {
    //MARK:- Outlets
    
    @IBOutlet weak var textFieldOne: UITextField!
    @IBOutlet weak var textFldTwo: UITextField!
    @IBOutlet weak var txtFldThree: UITextField!
    @IBOutlet weak var txtFldFour: UITextField!
 
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var viewForTouchID: UIView!
    @IBOutlet weak var cnstHeightForView: NSLayoutConstraint!
    
    
    @IBOutlet weak var topBarVw: UIView!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var forgotPswdBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var toucIdBtn: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    
    var setPassVMObj = SetPasscodeVM()
    var objUserSett = UserSettingVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.isHidden = false
        viewForTouchID.isHidden = true
        cnstHeightForView.constant = 0
        if setPassVMObj.cameFrom == "ChangePasscode" {
        lblTitle.text = "Change Passcode"
        lblHeading.text = "Enter Old Passcode"
        } else if  setPassVMObj.cameFrom == "Splash" {
        lblTitle.text = "Enter Passcode"
        btnBack.isHidden = true
        } else if  setPassVMObj.cameFrom == "DeletePassCode"{
        lblTitle.text = "Enter Old Passcode"
        } else if setPassVMObj.cameFrom == "SplashWithTouchID" {
            btnBack.isHidden = true
            viewForTouchID.isHidden = false
            cnstHeightForView.constant = 100
        } else {
        lblTitle.text = "Set Passcode"
        }
    }
    //MARK:- Actions
    @IBAction func btnSubmitPassCode(_ sender: UIButton) {
        if checkValidation(){
        let passcode = "\(textFieldOne.text!)\(textFldTwo.text!)\(txtFldThree.text!)\(txtFldFour.text!)"
        let param = [ "User[passcode]":  passcode ] as [String:AnyObject]
            if setPassVMObj.cameFrom == "SetPasscode" {
                if setPassVMObj.isPassConfirmed == true {
                    if setPassVMObj.passCodeVal == passcode {
             setPassVMObj.changePasscodeApi(param: param) { (response) in
                self.setPassVMObj.handelReponse(response, completion: {
                    self.objUserSett.isPasscode = 1
                    self.objUserSett.isFingerPrint = KAppDelegate.objUserDetailModel.isFingerPrint
                    self.objUserSett.deactivatePasscode {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                        } } else {
                   Proxy.shared.displayStatusCodeAlert(AlertMsgs.KOldPassCodeIncorrect)
                    }
                } else {
                setPassVMObj.passCodeVal = passcode
                setPassVMObj.isPassConfirmed = true
                lblTitle.text = "Confirm Passcode"
                lblHeading.text = "Enter Confirm Passcode"
                refreshFields()
                }
          } else if setPassVMObj.cameFrom == "DeletePassCode" {
                if KAppDelegate.objUserDetailModel.passCode == passcode {
                    objUserSett.isPasscode = 0
                    objUserSett.isFingerPrint = KAppDelegate.objUserDetailModel.isFingerPrint
                    objUserSett.deactivatePasscode {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    Proxy.shared.displayStatusCodeAlert("Old Passcode is incorrect")
                }
            }  else if setPassVMObj.cameFrom == "ChangePasscode" {
                if KAppDelegate.objUserDetailModel.passCode == passcode {
                   lblHeading.text = "Enter New Passcode"
                   refreshFields()
                   setPassVMObj.cameFrom = "SetPasscode"
                } else {
                    Proxy.shared.displayStatusCodeAlert("Old Passcode is incorrect")
                }
            } else if setPassVMObj.cameFrom == "Splash" ||  setPassVMObj.cameFrom == "SplashWithTouchID" {
                if KAppDelegate.objUserDetailModel.passCode == passcode {
                  navigateToRole()
                } else {
                   Proxy.shared.displayStatusCodeAlert(AlertMsgs.KIncorrectPasscode)
                }
            }
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
       self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnUseTouchID(_ sender: UIButton) {
       useTouchID()
    }
    
    @IBAction func forgotPasscodeAction(_ sender: Any)
    {
        setPassVMObj.forgotPasscode {
            
        }
    }
    
    //MARK:- Custome Methods
    func navigateToRole(){
        if KAppDelegate.loginTypeVal == UserRole.Admin.rawValue {
            KAppDelegate.navigateToOtherVC(identifier: "AdminHomeVC")
        } else if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue {
            KAppDelegate.navigateToOtherVC(identifier: "ListOfPatientsVC")
        } else if KAppDelegate.loginTypeVal == UserRole.Patient.rawValue && KAppDelegate.objUserDetailModel.isParticipant == 0 {
            KAppDelegate.navigateToOtherVC(identifier: "DashboardPatientVC")
        } else if KAppDelegate.loginTypeVal == UserRole.Patient.rawValue && KAppDelegate.objUserDetailModel.isParticipant == 1 {
            KAppDelegate.loginTypeVal = UserRole.User.rawValue
            KAppDelegate.navigateToOtherVC(identifier: "UserDashboardVC")
        } else {
            KAppDelegate.navigateToOtherVC(identifier: "UserDashboardVC")
        }
    }
    func refreshFields(){
        textFieldOne.text = ""
        textFldTwo.text = ""
        txtFldThree.text = ""
        txtFldFour.text = ""
    }
    func useTouchID(){
       let context = LAContext()
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "Authenticate with Touch ID"
                    context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply:
                        ({(succes, error) in
                            if succes {
                                self.dismiss(animated: true, completion: nil)
                                Proxy.shared.showActivityIndicator()
                                self.navigateToRole()
                            } else {
                                //                                Proxy.shared.displayStatusCodeAlert("Touch ID Authentication Failed")
                            }
                        } ))
              } else {
                Proxy.shared.showAlertController(view: self, message: "Go to settings and Enable your Touch ID")
            }
        }
}
