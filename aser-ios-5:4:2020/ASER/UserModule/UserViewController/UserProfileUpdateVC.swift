
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
import SDWebImage
class UserProfileUpdateVC: UIViewController,PassImageDelegate {
    //MARK:- OUTLETS & OBJECT CREATION
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var txtFldGender: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldAge: UITextField!
    @IBOutlet weak var tftFldPhoneNum: UITextField!
    @IBOutlet weak var txtFldCountry: UITextField!
    @IBOutlet weak var txtFldState: UITextField!
    @IBOutlet weak var txtFldZipCode: UITextField!
    @IBOutlet weak var txtFldCity : UITextField!
    @IBOutlet weak var txtFldApt: UITextField!
    @IBOutlet weak var txtFldChangePswrd: UITextField!
    @IBOutlet weak var txtFldStreet: UITextField!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnEditProfilePic: UIButton!
    @IBOutlet weak var btnEditCoverPic: UIButton!
    @IBOutlet weak var imgVwProfile: UIImageView!
    @IBOutlet weak var imgVwSmallImg: UIImageView!
    @IBOutlet weak var btnDrawer: UIButton!
    @IBOutlet weak var txtFldDoctorCode: UITextField!
    @IBOutlet weak var vwChangePWD: UIView!
    @IBOutlet weak var cnstHeightChangePWD: NSLayoutConstraint!
    @IBOutlet weak var viewDoctorCode: UIView!
    @IBOutlet weak var vWRating: FloatRatingView!
    
    var profileUpdateVmObj = UserProfileUpdateVM()
    var currentImage =  String()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.title == "Came From Admin" || self.title == "ParticipantVC" {
            btnDrawer.setImage(UIImage(named: ""), for: .normal)
            btnDrawer.setTitle("Back", for: .normal)
        }
        if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue
        {
            viewDoctorCode.isHidden = (KAppDelegate.loginTypeVal == UserRole.Medical.rawValue) ? false : true
        }
    
        galleryCameraImageObj = self
        txtFldGender.inputView = profileUpdateVmObj.genderPicker
        txtFldChangePswrd.rightImage(image:#imageLiteral(resourceName: "ic_next"), imgW: 10, imgH: 16)
        btnEditProfilePic.isHidden = true
        btnEditCoverPic.isHidden = true
        //MARK : FOR RESIGNING GENDER BUTTON
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
        Proxy.shared.addDoneBtnOnTF(txtFldGender, doneButton: doneBtn, cancelButton: UIBarButtonItem.init())
        //MARK : DISABLE TEXTFILED
        self.makeEditableFields(passVal: false)
        //MARK: DISPLAY METHOD FOR PROFILE LISTING
        if self.title == "ParticipantVC" {
            vwChangePWD.isHidden = true
            cnstHeightChangePWD.constant = 0
            profileUpdateVmObj.getParticipantData {
                self.showUserDetail(self.profileUpdateVmObj.objParticipantModel)
            }
        }else{
            showUserDetail(KAppDelegate.objUserDetailModel)
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(selectedCountry(_:)), name: NSNotification.Name("SelectedCountry"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteProfile(_:)), name: NSNotification.Name("DeleteProfile"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("SelectedCountry"), object: nil)
    }
    
    //MARK:-PICKER DONE Method
    @objc func doneAction()  {
        txtFldGender.resignFirstResponder()
        txtFldAge.becomeFirstResponder()
    }
    //MARK:-Actions
    @IBAction func actionBack(_ sender:UIButton){
        if self.title == "ParticipantVC"
        {
             KAppDelegate.loginTypeVal = UserRole.Admin.rawValue
            
            Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
           
        }
      else  if KAppDelegate.loginTypeVal == UserRole.User.rawValue
        {
            Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
        } else
        {
            sideMenuViewController?._presentLeftMenuViewController()
        }
    }
    //MARK:-
    @IBAction func actionProileClick(_ sender:UIButton){
         currentImage = "Profile"
        profileUpdateVmObj.valueUpdated = true
          if imgVwSmallImg.image == UIImage(named: "ic_profile-1"){
            profileUpdateVmObj.galleryFunctions.customActionSheet(false, controller: self)
          } else {
            profileUpdateVmObj.galleryFunctions.customActionSheet(true, controller: self)
        }
    }
    @IBAction func btnCoverImage(_ sender: UIButton) {
         currentImage = "Cover"
         profileUpdateVmObj.valueUpdated = true
         profileUpdateVmObj.galleryFunctions.customActionSheet(false, controller: self)
    }
    @IBAction func actionEdit(_ sender:UIButton){
        if sender.currentImage == UIImage(named: "ic_edit_profile") {
            btnEditProfilePic.isHidden = false
            btnEditCoverPic.isHidden = true
            btnEdit.setImage(UIImage(named: "ic_tick"), for: .normal)
            self.makeEditableFields(passVal: true)
        }else{ //MARK: EDIT
            if textFildValidation(){
                btnEditProfilePic.isHidden = true
                btnEditCoverPic.isHidden = true
                btnEdit.setImage(UIImage(named: "ic_edit_profile"), for: .normal)
                self.makeEditableFields(passVal: false)
                if profileUpdateVmObj.valueUpdated == true {
                    var gender = Int()
                    gender = (txtFldGender.text == "\(Gender.Male)") ? Gender.Male.rawValue : Gender.Female.rawValue
                    let paramDict = [
                        "User[full_name]":"\(txtFldName.text!)",
                        "User[zipcode]":"\(txtFldZipCode.text!)",
                        "User[country]":"\(txtFldCountry.text!)",
                        "User[gender]":"\(gender)",
                        "User[city]":"\(txtFldCity.text!)",
                        "User[contact_no]":"\(tftFldPhoneNum.text!)",
                        "User[street]":"\(txtFldStreet.text!)",
                        "User[state]":"\(txtFldState.text!)",
                        "User[age]":"\(txtFldAge.text!)",
                        "User[apartment]":"\(txtFldApt.text!)",
                        "User[user_country_id]" : "\(profileUpdateVmObj.countryID!)",
                        "User[user_state_id]" : "\(profileUpdateVmObj.stateId!)" ] as [String:AnyObject]
                    var paramImage = [String:UIImage]()
                    paramImage = ( profileUpdateVmObj.userPicVal == 1) ? [ "User[profile_file]": profileUpdateVmObj.selectedImg, "User[cover_file]": profileUpdateVmObj.selectedCoverImg ] : [:]
                    profileUpdateVmObj.updateProfile(param: paramDict, imageData:paramImage ) { (response) in
                        Proxy.shared.displayStatusCodeAlert(AlertMsgs.PROFILEUPDATED)
                        self.profileUpdateVmObj.valueUpdated = false
                        print(response)
                    }
                }
            }
        }
    }
    
    func makeEditableFields(passVal:Bool) {
        txtFldEmail.isUserInteractionEnabled = false
        txtFldApt.isUserInteractionEnabled = passVal
        txtFldAge.isUserInteractionEnabled = passVal
        txtFldName.isUserInteractionEnabled = passVal
        txtFldCity.isUserInteractionEnabled = passVal
        txtFldState.isUserInteractionEnabled = passVal
        txtFldStreet.isUserInteractionEnabled = passVal
        txtFldGender.isUserInteractionEnabled = passVal
        txtFldZipCode.isUserInteractionEnabled = passVal
        txtFldCountry.isUserInteractionEnabled = passVal
        tftFldPhoneNum.isUserInteractionEnabled = passVal
        txtFldCity.rightImage(image: #imageLiteral(resourceName: "ic_dropdown"), imgW: (passVal==true ? 15 : 0), imgH: (passVal==true ? 8 : 0))
        txtFldState.rightImage(image: #imageLiteral(resourceName: "ic_dropdown"), imgW: (passVal==true ? 15 : 0), imgH: (passVal==true ? 8 : 0))
        txtFldGender.rightImage(image: #imageLiteral(resourceName: "ic_dropdown"), imgW: (passVal==true ? 15 : 0), imgH: (passVal==true ? 8 : 0))
        txtFldCountry.rightImage(image: #imageLiteral(resourceName: "ic_dropdown"), imgW: (passVal==true ? 15 : 0), imgH: (passVal==true ? 8 : 0))
     }
    //MARK:- PROTOCOL FUNCTION
    func passSelectedimage(selectImage: UIImage) {
        profileUpdateVmObj.userPicVal = 1
        if currentImage == "Cover" {
            profileUpdateVmObj.selectedCoverImg = selectImage
            imgVwProfile.image = selectImage
        } else {
            profileUpdateVmObj.selectedImg = selectImage
            imgVwSmallImg.image = selectImage
        }
    }
    //MARK:- Notification Methods
    @objc func deleteProfile(_ notification: Notification) {
       // showUserDetail()
         if currentImage == "Cover" {
        self.imgVwProfile.sd_setImage(with: URL.init(string: KAppDelegate.objUserDetailModel.coverFile!), placeholderImage:UIImage(named: "ic_profile_bg"), completed: nil)
         } else {
        self.imgVwSmallImg.sd_setImage(with: URL.init(string: KAppDelegate.objUserDetailModel.profileImage!), placeholderImage:UIImage(named: "ic_profile-1"), completed: nil)
        }
    }
    
    @objc func selectedCountry(_ notification: Notification) {
        if let dictCountry = notification.object as? CountryModel {
            if let dictUser = notification.userInfo as? NSDictionary {
                if let type = dictUser["Name"] as? String {
                    if type == "State" {
                        profileUpdateVmObj.stateId = dictCountry.id ?? 0
                        txtFldState.text = dictCountry.name
                        txtFldCity.text = ""
                    } else if type == "City" {
                        txtFldCity.text = dictCountry.name
                    } else {
                        txtFldCountry.text = dictCountry.name
                        profileUpdateVmObj.countryID = dictCountry.id ?? 0
                        txtFldState.text = ""
                        txtFldCity.text = ""
                    }
                }
            }
        }
    }
}
