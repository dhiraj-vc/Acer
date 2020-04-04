
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
class ContactUsVC: UIViewController, PassImageDelegate {
    //MARK:-->IBOUTLETS & VARIABLES
    
    
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtVwComment: UITextView!
    @IBOutlet weak var btnDrawer: UIButton!
    
    //MARK : PHOTO UPLOAD OUTLETS
    @IBOutlet weak var vwPicUpload: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var cnstHeight: NSLayoutConstraint!
    @IBOutlet weak var vwSelectRole: UIView!
    @IBOutlet weak var cnstHeightVwSelectRole: NSLayoutConstraint!
    @IBOutlet weak var txtFldSelectRole: UITextField!
    @IBOutlet weak var lblContactTo: UILabel!
    @IBOutlet weak var cnstheightContactTo: NSLayoutConstraint!
    
    // for color
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    var objContactUsVM = ContactUsVM()
    
    // MARK: View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let loginTypeVal  = KAppDelegate.loginTypeVal
        print(loginTypeVal)
        
        if loginTypeVal == 1 {
        
        let color = UserDefaults.standard.string(forKey: "ColorKey")
        if color == "Green"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            submitBtn.setBackgroundImage(UIImage(named: "bar_green@2x.png"), for: UIControl.State.normal)
            
            
        }else if color == "Default"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            submitBtn.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
            
            
        }else if color == "Black"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            submitBtn.setBackgroundImage(UIImage(named: "bar_black@2x.png"), for: UIControl.State.normal)
            
            
            
        }else if color == "Gold"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            submitBtn.setBackgroundImage(UIImage(named: "bar_yellow@2x.png"), for: UIControl.State.normal)
            
            
        }else if color == "Blue"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            submitBtn.setBackgroundImage(UIImage(named: "bar_blue@2x.png"), for: UIControl.State.normal)
            
            
        }else if color == "Pink"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            submitBtn.setBackgroundImage(UIImage(named: "bar_pink@2x.png"), for: UIControl.State.normal)
            
            
        }else if color == "Red"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            submitBtn.setBackgroundImage(UIImage(named: "bar_red@2x.png"), for: UIControl.State.normal)
            
            
        }else {
            topBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            submitBtn.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
            
            }}else{
            print("the main code is mc")
        }
        
        galleryCameraImageObj = self
        txtFldSelectRole.inputView = objContactUsVM.picker
        
        if KAppDelegate.loginTypeVal == UserRole.User.rawValue {
            lblMainTitle.text = "Contact Me"
            txtFldSelectRole.rightImage(image: #imageLiteral(resourceName: "ic_dropdown"), imgW: 15, imgH: 8)
         } else{
            lblMainTitle.text = "Contact Us"
            lblContactTo.isHidden = true
            vwPicUpload.isHidden = true
            cnstHeight.constant = 0
            vwSelectRole.isHidden = true
            cnstHeightVwSelectRole.constant = 0
            cnstheightContactTo.constant = 0
        }        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.title == "Profile"{
            btnDrawer.setImage(UIImage(named: "ic_back"), for: .normal)
        }
        txtFldEmail.text = KAppDelegate.objUserDetailModel.emailId!       
        txtFldEmail.isUserInteractionEnabled = false
    }
    //MARK:-->BUTTON ACTION
    @IBAction func btnSubmitAction(_ sender: Any) {
        CheckValidation()
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        if self.title == "Profile"{
            Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
        }else{
            sideMenuViewController?._presentLeftMenuViewController()
        }
    }
    
    @IBAction func actionCamera(_ sender: UIButton) {
        objContactUsVM.valueUpdated = true
        Proxy.shared.pushToNextVC(identifier: "CameraViewController", isAnimate: false, currentViewController: self)
    }
    //MARK:- PROTOCOL FUNCTION
   public func passSelectedimage(selectImage: UIImage) {
        objContactUsVM.userPicVal = 1
        objContactUsVM.selectedImg = selectImage
        imgPreview.isHidden = false
        imgPreview.image = selectImage
      }
 }
