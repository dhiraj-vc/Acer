
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
import SDWebImage

class UserProfileUpdateVM: NSObject {
    var countryID, stateId, cityID : Int?
    var genderPicker = UIPickerView()
    enum PickerType {
        case Gender
        case Country
        case State
    }
    var selectedPicker = PickerType.Gender
    var galleryFunctions = GalleryCameraImage()
    var selectedImg = UIImage()
    var selectedCoverImg = UIImage()
    var valueUpdated = false
    var userPicVal = Int()
    var participantId = Int()
    var objParticipantModel =  UserDetailModel()
    func updateProfile(param : [String:AnyObject],imageData:[String:UIImage], completion: @escaping ResponseHandler) {
        var urlStr = String()
        if participantId != 0{
            urlStr = "\(Apis.KParticipantProfileUpdate)\(participantId)"
        }else{
            urlStr =  Apis.KProfileUpdate
        }
        WebServiceProxy.shared.uploadImage(param, parametersImage: imageData, addImageUrl: urlStr, showIndicator: true) { (ApiResponse) in
            if ApiResponse.success{
                self.userPicVal = 0
                if let userDetDict = ApiResponse.data {
                    if let detailDict = userDetDict["detail"] as? NSDictionary {
                        if self.participantId != 0{
                            print("Participant Update")
                        }else{
                            KAppDelegate.objUserDetailModel.userDict(dict: detailDict)
                        }
                    }
                }
                completion(ApiResponse)
            }else{
                Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
            }
        }
    }
    
    func getParticipantData(_ completion:@escaping() -> Void){
        WebServiceProxy.shared.getData("\(Apis.KParticipantProfile)\(participantId)", showIndicator: true) { (response) in
            if response.success{
                if let userDetDict = response.data {
                    if let detailDict = userDetDict["user"] as? NSDictionary {
                        self.objParticipantModel.userDict(dict: detailDict)
                    }
                }
                completion()
            }else{
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
        }
    }
}

extension UserProfileUpdateVC:UITextFieldDelegate{
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        profileUpdateVmObj.valueUpdated = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool{
        profileUpdateVmObj.genderPicker.delegate = self
        profileUpdateVmObj.genderPicker.dataSource = self
        profileUpdateVmObj.genderPicker.reloadAllComponents()
        switch textField {
        case txtFldGender:
            profileUpdateVmObj.selectedPicker = .Gender
            return true
        case txtFldChangePswrd:
            Proxy.shared.pushToNextVC(identifier: "ChangePasswordVC", isAnimate: true, currentViewController: self)
            return false
        case txtFldCountry:
            profileUpdateVmObj.valueUpdated = true
            presentView(selectedType: "Country")
            return false
        case txtFldState:
            profileUpdateVmObj.valueUpdated = true
            (profileUpdateVmObj.countryID != nil) ? presentView(selectedType: "State", Id: profileUpdateVmObj.countryID ?? 0) : Proxy.shared.displayStatusCodeAlert("Please select country first")
            return false
        case txtFldCity:
            profileUpdateVmObj.valueUpdated = true
            (profileUpdateVmObj.stateId != nil) ? presentView(selectedType: "City", Id: profileUpdateVmObj.stateId ?? 0) : Proxy.shared.displayStatusCodeAlert("Please select state first")
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtFldName:
            txtFldName.goToNextTextFeild(nextTextFeild: txtFldGender)
        case txtFldCountry:
            txtFldAge.goToNextTextFeild(nextTextFeild: tftFldPhoneNum)
        case txtFldAge:
            txtFldAge.goToNextTextFeild(nextTextFeild: tftFldPhoneNum)
        case txtFldCity:
            txtFldCity.goToNextTextFeild(nextTextFeild: txtFldApt)
        case txtFldApt:
            txtFldApt.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
extension UserProfileUpdateVC:UIPickerViewDelegate,UIPickerViewDataSource {
    //MAKR:- PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch profileUpdateVmObj.selectedPicker {
        case .Gender:
            return StaticData.GenderArray.count
        case .Country:
            return 0
        case .State:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch profileUpdateVmObj.selectedPicker {
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
        switch profileUpdateVmObj.selectedPicker {
        case .Gender:
            txtFldGender.text = StaticData.GenderArray[row]
        //Pending
        case .Country: break
        case .State: break
        }
    }
}

extension UserProfileUpdateVC {
    func showUserDetail(_ userData:UserDetailModel) {
        self.imgVwProfile.sd_setImage(with: URL.init(string: userData.coverFile!), placeholderImage:UIImage(named: "cover"), completed: nil)
        self.imgVwSmallImg.sd_setImage(with: URL.init(string: userData.profileImage!), placeholderImage:UIImage(named: "ic_profile-1"), completed: nil)
        profileUpdateVmObj.countryID = Int(userData.userCountryID!)
        profileUpdateVmObj.stateId =  Int(userData.userStateId!)
        txtFldName.text = userData.fullName!
        txtFldGender.text = userData.gender!
        txtFldEmail.text = userData.emailId!
        txtFldAge.text = userData.age!
        tftFldPhoneNum.text = userData.contactNo!
        txtFldCountry.text = userData.country!
        txtFldState.text = userData.state!
        txtFldZipCode.text = userData.zipCode!
        txtFldCity.text = userData.city!
        txtFldApt.text = userData.apartment!
        txtFldStreet.text = userData.street!
        if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue {
            txtFldDoctorCode.text = userData.accessCode
            if KAppDelegate.loginTypeVal == UserRole.User.rawValue {
                vWRating.rating = userData.rating!
            }
        }
    }
    
    func textFildValidation() -> Bool {
        if txtFldName.isBlank{
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.NAME)
            return false
        } else if txtFldAge.isBlank{
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.ENTERAGE)
            return false
        }  else if (txtFldAge.text!=="0"){
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.AGEVALID)
            return false
        } else if (txtFldAge.text!.count<1) {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.AGEVALID)
            return false
        } else if tftFldPhoneNum.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.ENTERPHONENOS)
            return false
        } else if tftFldPhoneNum.text!.count<6 {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.VALIDPHONENOS)
            return false
        } else if txtFldZipCode.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.ENTERZIPCODE)
            return false
        } else if txtFldZipCode.text!.count<1 {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.VALIDZIPCODE)
            return false
        }  else if txtFldZipCode.text! == "0" {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.VALIDZIPCODE)
            return false
        } else if (KAppDelegate.loginTypeVal == UserRole.Medical.rawValue) {
            if txtFldDoctorCode.isBlank {
                Proxy.shared.displayStatusCodeAlert(AlertMsgs.ENTERASSIGNCODE)
                return false
            } else{
                return true
            }
        } else{
            return true
        }
    }
    
    
}
