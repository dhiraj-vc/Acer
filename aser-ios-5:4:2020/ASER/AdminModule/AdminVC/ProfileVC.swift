
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
class ProfileVC: UIViewController,PassImageDelegate  {
    //MARK:-->IBOUTLETS
    @IBOutlet weak var imgVwProfile: UIImageView!
    
    @IBOutlet weak var imgViewMain: UIImageView!
    
    
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldChangePswrd: UITextField!
    @IBOutlet weak var txtFldRole: UITextField!
    @IBOutlet weak var btnEdit: UIButton!

    @IBOutlet weak var txtFldDesignation: UITextField!
    
    // for color
    @IBOutlet weak var btnEditProfilePic: UIButton!
    @IBOutlet weak var btnEditCoverPhoto: UIButton!
    @IBOutlet weak var imgVwSmallImg: UIImageView!
    @IBOutlet weak var tobbarView: UIView!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var contactusBtn: UIButton!
    
    
    
    //MARK:- View Model Object
    var profileVmObj = ProfileVM()
    var objUserProfileUpdateVM = UserProfileUpdateVM()
    var currentImage = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UserDefaults.standard.string(forKey: "ColorKey")
        if color == "Green"{
            
            tobbarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            contactusBtn.setBackgroundImage(UIImage(named: "bar_green@2x.png"), for: UIControl.State.normal)
            imgViewMain.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            
            
        }else if color == "Default"{
            
            tobbarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            contactusBtn.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
            imgViewMain.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            
        }else if color == "Black"{
            
            tobbarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            contactusBtn.setBackgroundImage(UIImage(named: "bar_black@2x.png"), for: UIControl.State.normal)
            
            
            
        }else if color == "Gold"{
            
            tobbarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            contactusBtn.setBackgroundImage(UIImage(named: "bar_yellow@2x.png"), for: UIControl.State.normal)
            imgViewMain.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            
        }else if color == "Blue"{
            
            tobbarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            contactusBtn.setBackgroundImage(UIImage(named: "bar_blue@2x.png"), for: UIControl.State.normal)
            imgViewMain.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            
        }else if color == "Pink"{
            
            tobbarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            contactusBtn.setBackgroundImage(UIImage(named: "bar_pink@2x.png"), for: UIControl.State.normal)
            imgViewMain.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            
        }else if color == "Red"{
            
            tobbarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            contactusBtn.setBackgroundImage(UIImage(named: "bar_red@2x.png"), for: UIControl.State.normal)
            imgViewMain.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            
        }else {
            tobbarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            contactusBtn.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
            imgViewMain.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            
        }
        txtFldChangePswrd.rightImage(image:#imageLiteral(resourceName: "ic_next"), imgW: 10, imgH: 16)
        btnEditProfilePic.isHidden = true
        btnEditCoverPhoto.isHidden = true
        profileVmObj.pickerView.delegate = self
        profileVmObj.pickerView.dataSource = self
        profileVmObj.pickerView.reloadAllComponents()
        txtFldRole.inputView = profileVmObj.pickerView
        galleryCameraImageObj = self
        self.makeEditableFields(passVal: false)
        setProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(deleteProfile(_:)), name: NSNotification.Name("DeleteProfile"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("DeleteProfile"), object: nil)
    }
    //MARK:-->BUTTON ACTION
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
        
    }
    @IBAction func btnEditAction(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "ic_edit_profile"){
            btnEdit.setImage(#imageLiteral(resourceName: "ic_tick"), for: .normal)
            btnEditProfilePic.isHidden = false
            btnEditCoverPhoto.isHidden = true
            makeEditableFields(passVal: true)
        }else{
            if txtFldDesignation.isBlank{
                Proxy.shared.displayStatusCodeAlert(AlertMsgs.ENTERDESIGNATION)
            }else if txtFldName.isBlank{
                Proxy.shared.displayStatusCodeAlert(AlertMsgs.NAME)
            }else{
                btnEdit.setImage(#imageLiteral(resourceName: "ic_edit_profile"), for: .normal)
                btnEditProfilePic.isHidden = true
                btnEditCoverPhoto.isHidden = true
                self.makeEditableFields(passVal: false)
                //MARK : UPDATE PROFILE
                if objUserProfileUpdateVM.valueUpdated == true {
                    var subRoleID = String()
                    if txtFldRole.text ==  StaticData.AdminRole[0][0]{
                        subRoleID = StaticData.AdminRole[0][1]
                    }else if txtFldRole.text ==  StaticData.AdminRole[1][0]{
                        subRoleID = StaticData.AdminRole[1][1]
                    }
                    let paramDict = [
                        "User[designation]":"\(txtFldDesignation.text!)",
                        "User[full_name]":"\(txtFldName.text!)",
                        "User[sub_role_id]": subRoleID ] as [String:AnyObject]
                    var paramImage = [String:UIImage]()
                    paramImage = ( objUserProfileUpdateVM.userPicVal == 1) ? [ "User[profile_file]": objUserProfileUpdateVM.selectedImg , "User[cover_file]": objUserProfileUpdateVM.selectedCoverImg] :  [:]
                    
                    objUserProfileUpdateVM.updateProfile(param: paramDict, imageData:paramImage ) { (response) in
                        //TODO
                        Proxy.shared.displayStatusCodeAlert(AlertMsgs.PROFILEUPDATED)
                        self.objUserProfileUpdateVM.valueUpdated = false
                    }
                }
            }
        }
    }
    
    @IBAction func btnCameraAction(_ sender: Any) {
        currentImage = "Profile"
        if imgVwSmallImg.image == UIImage(named: "ic_profile-1"){
        profileVmObj.galleryFunctions.customActionSheet(false, controller: self)
        } else {
        profileVmObj.galleryFunctions.customActionSheet(true, controller: self)
        }
        objUserProfileUpdateVM.valueUpdated = true
    }
    
    @IBAction func btnSaveCoverPhoto(_ sender: UIButton) {
        currentImage = "Cover"
        profileVmObj.galleryFunctions.customActionSheet(false, controller: self)
        objUserProfileUpdateVM.valueUpdated = true
    }
    
    @IBAction func bntContactUsAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "ContactUsVC", isAnimate: true, currentViewController: self, title: "Profile")
    }
    
    //MARK:- Notification Methods
    
    @objc func deleteProfile(_ notification: Notification) {
        if currentImage == "Cover" {
            self.imgVwProfile.sd_setImage(with: URL.init(string: KAppDelegate.objUserDetailModel.coverFile!), placeholderImage:UIImage(named: "ic_profile_bg"), completed: nil)
        } else {
            self.imgVwSmallImg.sd_setImage(with: URL.init(string: KAppDelegate.objUserDetailModel.profileImage!), placeholderImage:UIImage(named: "ic_profile-1"), completed: nil)
        }
    }
    
    func makeEditableFields(passVal:Bool) {
        txtFldName.isUserInteractionEnabled = passVal
        txtFldDesignation.isUserInteractionEnabled = passVal
        txtFldEmail.isUserInteractionEnabled = false
        txtFldRole.isUserInteractionEnabled = false
        
    }
    
    //MARK:- PROTOCOL FUNCTION
    func passSelectedimage(selectImage: UIImage) {
        objUserProfileUpdateVM.userPicVal = 1
        if currentImage == "Cover" {
            objUserProfileUpdateVM.selectedCoverImg = selectImage
            imgVwProfile.image = selectImage
        } else {
            objUserProfileUpdateVM.selectedImg = selectImage
            imgVwSmallImg.image = selectImage
        }
    }
    func setProfileData(){
        self.imgVwProfile.sd_setImage(with: URL.init(string: KAppDelegate.objUserDetailModel.coverFile!), placeholderImage:UIImage(named: "ic_profile_bg"), completed: nil)
        self.imgVwSmallImg.sd_setImage(with: URL.init(string: KAppDelegate.objUserDetailModel.profileImage!), placeholderImage:UIImage(named: "ic_profile-1"), completed: nil)
        txtFldName.text = KAppDelegate.objUserDetailModel.fullName
        txtFldEmail.text = KAppDelegate.objUserDetailModel.emailId
        if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue {
        txtFldRole.text =  KAppDelegate.objUserDetailModel.accessCode
        } else {
        txtFldRole.text =  KAppDelegate.objUserDetailModel.adminRole
        }
        txtFldDesignation.text = KAppDelegate.objUserDetailModel.designation
    }
}

