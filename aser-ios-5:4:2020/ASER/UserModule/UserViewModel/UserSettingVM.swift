
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
import Foundation
import LocalAuthentication
class UserSettingVM:NSObject{
    var arrSettingOpt = [["Enable Passcode","Change Passcode"],["Enable Fingerprint"],["Delete account"]]
    var isFingerPrint = Int()
    var isPasscode = Int()
    
    func deactivateAccount(_ completion:@escaping() -> Void){
        WebServiceProxy.shared.getData(Apis.KDeactivateUserAccount, showIndicator: true) { (response) in
            if response.success{
                completion()
            }else{
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
        }
    }
    func deactivatePasscode(_ completion:@escaping() -> Void){
        let param = [ "User[is_passcode]": isPasscode,
                      "User[is_fingerprint]": isFingerPrint ] as [String:AnyObject]
        WebServiceProxy.shared.postData("\(Apis.KEnableSecurity)\(Proxy.shared.authNil())", params: param, showIndicator: true) { (response) in
            if response.success{
                if let userDetDict = response.data {
                    if let detailDict = userDetDict["user"] as? NSDictionary {
                        KAppDelegate.objUserDetailModel.userDict(dict: detailDict)
  }
                      completion()
                }
                
            }else{
                Proxy.shared.displayStatusCodeAlert("Operation Failed! Try Again..")
            }
        }
    }
    func getTouchIDStatus(view:UIViewController, completion:@escaping() -> Void){
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            if isFingerPrint == 0 {
                let reason = "Authenticate with Touch ID"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply:
                    ({(succes, error) in
                        if succes {
                            view.dismiss(animated: true, completion: nil)
                            completion()
                        } else {
                            //                                Proxy.shared.displayStatusCodeAlert("Touch ID Authentication Failed")
                        }
                    } ))
            } else {
                completion()
            }
        } else {
            Proxy.shared.showAlertController(view: view, message: "Go to settings and Enable your Touch ID")
        }
    }
    
}
extension UserSettingVC : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        switch KAppDelegate.loginTypeVal {
        case UserRole.Medical.rawValue, UserRole.Patient.rawValue:
            if KAppDelegate.loginTypeVal == UserRole.Patient.rawValue && KAppDelegate.objUserDetailModel.isParticipant == 1 {
                return objUserSettingVM.arrSettingOpt.count
            } else {
               if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue
               {
                return objUserSettingVM.arrSettingOpt.count
                }else{
                return 1
                }
            }
        case UserRole.User.rawValue:
            return objUserSettingVM.arrSettingOpt.count
        case UserRole.Admin.rawValue:
             return 2
        default:
            break
        }
        if KAppDelegate.loginTypeVal > 2 {
            return 1
        } else if KAppDelegate.loginTypeVal == UserRole.Admin.rawValue {
            return 2
        } else {
            return objUserSettingVM.arrSettingOpt.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if KAppDelegate.objUserDetailModel.isPasscode == 0 && section == 0 {
            return 1
        } else {
            return objUserSettingVM.arrSettingOpt[section].count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell = tblVwOptions.dequeueReusableCell(withIdentifier: "UserSettingTVC") as! UserSettingTVC
        returnCell.lblOptionName.text = objUserSettingVM.arrSettingOpt[indexPath.section][indexPath.row]
        if indexPath.section == 0 && indexPath.row == 0 || indexPath.section == 1 && indexPath.row == 0 {
            if KAppDelegate.objUserDetailModel.isPasscode == 0 && indexPath.section == 0 {
                returnCell.btnSwitch.setImage(UIImage(named: "ic_off"), for: .normal)
            } else if KAppDelegate.objUserDetailModel.isFingerPrint == 0 && indexPath.section == 1 {
                returnCell.btnSwitch.setImage(UIImage(named: "ic_off"), for: .normal)
            } else {
                returnCell.btnSwitch.setImage(UIImage(named: "ic_on"), for: .normal)
            }
        } else {
            returnCell.btnSwitch.setImage(UIImage(named: "ic_next-1"), for: .normal)
        }
        return returnCell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnCell = tblVwOptions.dequeueReusableCell(withIdentifier: "UserSettingTitleTVC") as! UserSettingTVC
        var title = String()
        switch section {
        case 0:
            title = "AppLock Passcode"
        case 1:
            title = "Finger Print"
        case 2:
            title = "Account"
        default:
            title = ""
        }
        returnCell.lblOptionName.text = title
        return returnCell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellIndex = IndexPath(row: indexPath.row, section: indexPath.section)
        let cell = tblVwOptions.cellForRow(at: cellIndex) as! UserSettingTVC
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                if cell.btnSwitch.currentImage == UIImage(named:"ic_on") {
                    let setPassVC = mainStoryboard.instantiateViewController(withIdentifier: "SetPassCodeVC") as! SetPassCodeVC
                    setPassVC.setPassVMObj.cameFrom = "DeletePassCode"
                    self.navigationController?.present(setPassVC, animated: true, completion: nil)
                } else {
                    objUserSettingVM.isPasscode = 1
                    let setPassVC = mainStoryboard.instantiateViewController(withIdentifier: "SetPassCodeVC") as! SetPassCodeVC
                    setPassVC.setPassVMObj.cameFrom = "SetPasscode"
                    self.navigationController?.present(setPassVC, animated: true, completion: nil)
                }
            } else {
                let setPassVC = mainStoryboard.instantiateViewController(withIdentifier: "SetPassCodeVC") as! SetPassCodeVC
                setPassVC.setPassVMObj.cameFrom = "ChangePasscode"
                self.navigationController?.present(setPassVC, animated: true, completion: nil)
            }
        case 1:
            if cell.btnSwitch.currentImage == UIImage(named:"ic_on") {
                objUserSettingVM.isFingerPrint = 0
            } else {
                objUserSettingVM.isFingerPrint = 1
            }
            objUserSettingVM.getTouchIDStatus(view: self) {
                self.objUserSettingVM.deactivatePasscode {
                    self.tblVwOptions.reloadData()
                }
            }
        case 2:
            //DEACTIVATE ACCOUNT
            if indexPath.row == 0 {
                Proxy.shared.alertControl(title: TitleValue.alert, message: AlertMsgs.KCONFIRMACCOUNTDELETE) { (alert, boolVal) in
                    if boolVal == "true"{
                        self.objUserSettingVM.deactivateAccount {
                            Proxy.shared.displayStatusCodeAlert(AlertMsgs.KACCOUNTDELETED)
                            KAppDelegate.loginTypeVal = UserRole.Admin.rawValue
                            Proxy.shared.pushToNextVC(identifier: "WelcomeVC", isAnimate: true, currentViewController: self)
                        }
                    } else if boolVal == "false"{
                    } else {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        default:
            break
        }
    }
}
