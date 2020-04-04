
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
class ContactUsVM {
    var galleryFunctions = GalleryCameraImage()
    var selectedImg = UIImage()
    var valueUpdated = false
    var userPicVal = Int()
    var selectedRole = "Admin"
    var urlString = "\(Apis.KContactUS)"
    var arrRole = ["Admin", "Research Admin"]
    var picker = UIPickerView()
    func contactUs(param:[String:AnyObject], completion: @escaping()-> Void) {
        WebServiceProxy.shared.postData(urlString, params: param, showIndicator: true) { (ApiResponse) in
            if ApiResponse.success{
                 completion()
            }else{
                Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
            }
        }
    }
    
    func userContactUs(_ param: [String:AnyObject], imageData:[String:UIImage], completion:@escaping()-> Void){
        WebServiceProxy.shared.uploadImage(param, parametersImage: imageData, addImageUrl: urlString, showIndicator: true) { (ApiResponse) in
            if ApiResponse.success{
                completion()
            }else{
                Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
            }
        }
        
    }
}
extension ContactUsVC:UITextFieldDelegate,UITextViewDelegate {
    // Check Validation for Input fields
//    else if txtFldEmail.isBlank{
//    Proxy.shared.displayStatusCodeAlert(AlertMsgs.email)
//    }else if !Proxy.shared.isValidEmail(txtFldEmail.text!){
//    Proxy.shared.displayStatusCodeAlert(AlertMsgs.validEmail)
//    }
    
    func CheckValidation(){
            if txtFldName.isBlank{
                Proxy.shared.displayStatusCodeAlert("Please enter subject")
            }else if txtVwComment.isBlank{
                Proxy.shared.displayStatusCodeAlert(AlertMsgs.COMMENT)
            }else{
                var param = NSMutableDictionary()
                  param = [
                    "subject" : txtFldName.text!,
                    "body" : txtVwComment.text! ]
                if  KAppDelegate.loginTypeVal == UserRole.User.rawValue{
                  var paramImage = [String:UIImage]()
                    paramImage = ( objContactUsVM.userPicVal == 1) ? [ "File[attachment]": objContactUsVM.selectedImg ] :  [:]
                    if txtFldSelectRole.text != "" {
                        objContactUsVM.userContactUs(param as! [String : AnyObject], imageData: paramImage) {
                            self.imgPreview.isHidden = true
                            self.txtFldSelectRole.text = ""
                            self.txtFldSelectRole.placeholder = "Select Role"
                            self.emptyTextfiled()
                            Proxy.shared.displayStatusCodeAlert(AlertMsgs.KEMAILSENT)
                        }
                    }else{
                        Proxy.shared.displayStatusCodeAlert(AlertMsgs.KSELECTROLE)
                    }
                  }else{
                    objContactUsVM.contactUs(param: param as! [String : AnyObject]) {
                        self.emptyTextfiled()
                        Proxy.shared.displayStatusCodeAlert(AlertMsgs.KEMAILSENT)
                    }
                }
            }
    }
    
    func emptyTextfiled(){
        self.txtFldName.text = ""
//        self.txtFldEmail.text = ""
        self.txtVwComment.text = ""
    }
    
    //MARK:- Text Field Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtFldName:
            txtFldName.goToNextTextFeild(nextTextFeild: txtFldEmail)            
        case txtFldEmail:
            txtFldEmail.resignFirstResponder()
            txtVwComment.becomeFirstResponder()
        default:
            break
         }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            txtVwComment.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        objContactUsVM.picker.delegate = self
        objContactUsVM.picker.dataSource = self
        objContactUsVM.picker.reloadAllComponents()
       
        return true
    }
}

extension ContactUsVC: UIPickerViewDelegate, UIPickerViewDataSource{
    //MARK:-PICKER VIEW DELEGATES
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        txtFldSelectRole.text = objContactUsVM.arrRole[row]
        return objContactUsVM.arrRole[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        objContactUsVM.selectedRole = objContactUsVM.arrRole[row]
        if row == 1 {
            objContactUsVM.urlString = "\(Apis.KContactUS)?admin=false"
        }else{
            objContactUsVM.urlString = "\(Apis.KContactUS)"
        }
    }
}
