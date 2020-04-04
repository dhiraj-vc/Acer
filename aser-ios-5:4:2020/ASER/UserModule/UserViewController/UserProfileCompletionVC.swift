
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
class UserProfileCompletionVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var txtFldGender: UITextField!
    @IBOutlet weak var txtFldAge: UITextField!
    @IBOutlet weak var tftFldPhoneNum: UITextField!
    @IBOutlet weak var txtFldCountry: UITextField!
    @IBOutlet weak var txtFldState: UITextField!
    @IBOutlet weak var txtFldZipCode: UITextField!
    @IBOutlet weak var txtFldCity : UITextField!
    @IBOutlet weak var txtFldApt: UITextField!
    @IBOutlet weak var txtFldStreet: UITextField!

    
    //countrywala controller himanshu
    //MARK:- View Model Object
    var userProfileVmObj = UserProfileVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFldCountry.text = "United States"
        userProfileVmObj.countryID = 231
        txtFldGender.inputView = userProfileVmObj.genderPicker
        txtFldGender.rightImage(image: #imageLiteral(resourceName: "ic_dropdown"), imgW: 15, imgH: 8)
        txtFldCountry.rightImage(image: #imageLiteral(resourceName: "ic_dropdown"), imgW: 15, imgH: 8)
        txtFldState.rightImage(image: #imageLiteral(resourceName: "ic_dropdown"), imgW: 15, imgH: 8)
        txtFldCity.rightImage(image: #imageLiteral(resourceName: "ic_dropdown"), imgW: 15, imgH: 8)
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
        Proxy.shared.addDoneBtnOnTF(txtFldGender, doneButton: doneBtn, cancelButton: UIBarButtonItem.init())
         }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(selectedCountry(_:)), name: NSNotification.Name("SelectedCountry"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("SelectedCountry"), object: nil)
    }
    //MARK:-Custom Method
    @objc func doneAction()  {
        txtFldGender.resignFirstResponder()
        txtFldAge.becomeFirstResponder()
    }
     //MARK:-Actions
    @IBAction func actionSave(_ sender:UIButton){
        if checkValidation(){ //User
            let param = [
                "gender": "\(userProfileVmObj.genderVal)",
                "age": "\(txtFldAge.text!)",
                "contact_no": tftFldPhoneNum.text!,
                "state" : txtFldState.text!,
                "country" : txtFldCountry.text!,
                "user_country_id" : userProfileVmObj.countryID!,
                "user_state_id" : userProfileVmObj.stateId!,
                "zipcode" : txtFldZipCode.text!,
                "city" : txtFldCity.text!,
                "apartment" : txtFldApt.text!,
                "street" : txtFldStreet.text! ] as [String:AnyObject]
            let paramDict = NSMutableDictionary()
            paramDict.setValue(param, forKey: "User")
            
            userProfileVmObj.saveProfileData(param: paramDict as! Dictionary<String, AnyObject>) { (response) in
                //self.signInVMObj.handelReponseForPushController(response, view: self)
                if response.success {                   
                    if let userDetDict = response.data {
                        if let detailDict = userDetDict["detail"] as? NSDictionary {
                            KAppDelegate.objUserDetailModel.userDict(dict: detailDict)
                            }
                        }
                    } else {
                        Proxy.shared.displayStatusCodeAlert(response.message!)
                    }
                 KAppDelegate.navigateToOtherVC(identifier: "UserDashboardVC")
            }
        }
    }
    //MARK:- Notification Methods
    @objc func selectedCountry(_ notification: Notification) {
        if let dictCountry = notification.object as? CountryModel {
            if let dictUser = notification.userInfo {
                if let type = dictUser["Name"] as? String {
                    if type == "State" {
                        userProfileVmObj.stateId = dictCountry.id ?? 0
                        txtFldState.text = dictCountry.name
                        txtFldCity.text = ""
                    } else if type == "City" {
                        txtFldCity.text = dictCountry.name
                    } else {
                        txtFldCountry.text = dictCountry.name
                        userProfileVmObj.countryID = dictCountry.id ?? 0
                        txtFldState.text = ""
                        txtFldCity.text = ""
                    }
                }
            }
        }
    }
}
