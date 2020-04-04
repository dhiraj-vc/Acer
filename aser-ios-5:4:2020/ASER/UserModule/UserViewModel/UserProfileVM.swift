
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
import Foundation
import UIKit
class UserProfileVM: NSObject {
    var countryID, stateId, cityID : Int?
    var genderPicker = UIPickerView()
    var genderVal = Int()
    enum PickerType {
        case Gender
        case Country
        case State
    }
    var selectedPicker = PickerType.Gender
    //MARK : SAVE DATA WHEN USER LOGIN FOR THE 1ST TIME
    
    func saveProfileData(param : [String:AnyObject],completion: @escaping ResponseHandler){
        WebServiceProxy.shared.postData("\(Apis.KProfileComplete)", params: param, showIndicator: true)  { (ApiResponse) in
            completion(ApiResponse)
        }
    }
}

extension UserProfileCompletionVC{
    func checkValidation() -> Bool {
        if txtFldGender.isBlank{
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.SELECTGENDER)
            return false
        } else if txtFldAge.isBlank{
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.ENTERAGE)
            return false
        }  else if (txtFldAge.text!=="0"){
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.AGEVALID)
            return false
        } else if !(txtFldAge.text!.count>0 && txtFldAge.text!.count<4) {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.AGEVALID)
            return false
        } else if tftFldPhoneNum.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.ENTERPHONENOS)
            return false
        } else if tftFldPhoneNum.text!.count>15 || tftFldPhoneNum.text!.count<6 {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.VALIDPHONENOS)
            return false
        } else if txtFldCountry.isBlank{
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.SELECTCOUNTRY)
            return false
        } else if txtFldState.isBlank{
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.SELECTSTATE)
            return false
        } else if txtFldZipCode.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.ENTERZIPCODE)
            return false
        } else if txtFldZipCode.text!.count<1 || txtFldZipCode.text!.count>7 {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.VALIDZIPCODE)
            return false
        }  else if txtFldZipCode.text! == "0" {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.VALIDZIPCODE)
            return false
        } else if txtFldCity.isBlank{
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.ENTERCITY)
            return false
//        }
//        else if txtFldApt.isBlank{
//            Proxy.shared.displayStatusCodeAlert(AlertMsgs.ENTERAPART)
//            return false
//        }
//        else if txtFldStreet.isBlank{
//            Proxy.shared.displayStatusCodeAlert(AlertMsgs.ENTERSTREET)
//            return false
        }  else{
            return true
        }
    }
}



extension UserProfileCompletionVC:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case txtFldAge:
            if range.location >= 3  {
                return false
            }
        case txtFldZipCode:
            if range.location >= 7 {
                return false
            }
        case tftFldPhoneNum :
            if range.location >= 15 {
                return false
            }
        default:
             return true
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool{
        userProfileVmObj.genderPicker.delegate = self
        userProfileVmObj.genderPicker.dataSource = self
        userProfileVmObj.genderPicker.reloadAllComponents()
        switch textField {
        case txtFldGender:
//            userProfileVmObj.genderPicker.isHidden = false
            userProfileVmObj.selectedPicker = .Gender
            return true
            //        case txtFldChangePswrd:
            //            Proxy.shared.pushToNextVC(identifier: "ChangePasswordVC", isAnimate: true, currentViewController: self)
        //            return false
        case txtFldCountry:
            self.view.endEditing(true)
            presentView(selectedType: "Country")
            return false
        case txtFldState:
            self.view.endEditing(true)
            (userProfileVmObj.countryID != nil) ? presentView(selectedType: "State", Id: userProfileVmObj.countryID ?? 0) : Proxy.shared.displayStatusCodeAlert("Please select country first")
            return false
        case txtFldCity:
            self.view.endEditing(true)
            (userProfileVmObj.stateId != nil) ? presentView(selectedType: "City", Id: userProfileVmObj.stateId ?? 0) : Proxy.shared.displayStatusCodeAlert("Please select state first")
            return false
        default:
            return true
        }
     }
    
    func presentView(selectedType:String, Id:Int = 0){
        let presentControllerObj = mainStoryboard.instantiateViewController(withIdentifier: "SelectCounrtyVC") as! SelectCounrtyVC
        presentControllerObj.selectCountryVMobj.Id = Id
        presentControllerObj.selectCountryVMobj.selectionType = selectedType
        self.present(presentControllerObj, animated: true, completion: nil)
    }
    
    //MARK:- Text Field Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtFldGender:
            txtFldGender.goToNextTextFeild(nextTextFeild: txtFldAge)
        case txtFldAge:
            txtFldAge.goToNextTextFeild(nextTextFeild: tftFldPhoneNum)
        case tftFldPhoneNum:
            tftFldPhoneNum.goToNextTextFeild(nextTextFeild: txtFldCountry)
        case txtFldCountry:
            txtFldCountry.goToNextTextFeild(nextTextFeild: txtFldState)
        case txtFldState:
            txtFldState.goToNextTextFeild(nextTextFeild: txtFldCity)
        case txtFldCity:
            txtFldCity.goToNextTextFeild(nextTextFeild: txtFldApt)
        case txtFldZipCode:
            txtFldApt.goToNextTextFeild(nextTextFeild: txtFldApt)            
        case txtFldApt:
            txtFldApt.goToNextTextFeild(nextTextFeild: txtFldStreet)
        case txtFldStreet:
            txtFldStreet.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
extension UserProfileCompletionVC:UIPickerViewDelegate,UIPickerViewDataSource{
    //MAKR:- PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch userProfileVmObj.selectedPicker {
        case .Gender:
            return StaticData.GenderArray.count
        case .Country:
            return 0
        case .State:
            return 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch userProfileVmObj.selectedPicker {
        case .Gender:
            txtFldGender.text = StaticData.GenderArray[row]
            return StaticData.GenderArray[row]
        case .Country:
            return ""
        case .State:
            return ""
        }
       
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch userProfileVmObj.selectedPicker {
        case .Gender:
//            txtFldGender.text
            var genderString: String
            genderString = StaticData.GenderArray[row]
            if StaticData.GenderArray[row]=="Others"{
                let alertController = UIAlertController(title: "Please Specify", message: "", preferredStyle: UIAlertController.Style.alert)
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "please specify"
                }
                let saveAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { alert -> Void in
                    let firstTextField = alertController.textFields![0] as UITextField
                    genderString = firstTextField.text!
                    print(firstTextField)
                    self.txtFldGender.text = genderString
//                    self.userProfileVmObj.selectedPicker.isHidden = true
//                    self.txtFldAge.becomeFirstResponder()
                    
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
                    (action : UIAlertAction!) -> Void in
                 
                })
               
                
                alertController.addAction(saveAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }else{
                
                if StaticData.GenderArray[row]=="Male"{
                self.txtFldGender.text = "Male"
                }else if  StaticData.GenderArray[row]=="Female"{
                    self.txtFldGender.text = "Female"
                    
                }
            }
//            self.txtFldGender.text = genderString
            userProfileVmObj.genderVal = (StaticData.GenderArray[row]=="Male") ? 0 : 1
        //Pending
        case .Country: break
        case .State: break
        }
        
    }
}
