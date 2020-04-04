
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
class ProfileVM: NSObject {
    var pickerView = UIPickerView()
    var galleryFunctions = GalleryCameraImage()
}

extension ProfileVC:UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        objUserProfileUpdateVM.valueUpdated = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool{
        if textField == txtFldChangePswrd{
            Proxy.shared.pushToNextVC(identifier: "ChangePasswordVC", isAnimate: true, currentViewController: self)
            return false
        }        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtFldName:
            txtFldName.goToNextTextFeild(nextTextFeild: txtFldDesignation)
        case txtFldDesignation:
            txtFldDesignation.resignFirstResponder()
        default:
            break
        }
        return true
    }
}

extension ProfileVC: UIPickerViewDelegate,UIPickerViewDataSource {
    //MAKR:- PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return StaticData.AdminRole.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        txtFldRole.text = StaticData.AdminRole[row][0]
        return StaticData.AdminRole[row][0]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtFldRole.text = StaticData.AdminRole[row][0]
    }
}

