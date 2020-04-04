//
//  DrawerVC.swift
//  Student Residences
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
class DrawerVC : UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var imgViewDrawerBg: UIImageView!
    @IBOutlet weak var tblViewDrawer: UITableView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var cnstHeightTable: NSLayoutConstraint!
    @IBOutlet weak var viewForSwitch: UIView!
    @IBOutlet weak var cnstForHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSwitch: UIButton!
    
    
    @IBOutlet weak var imgBGView: UIImageView!
    @IBOutlet weak var tblBckgrndView: UIView!
    
    var drawerVMObj = DrawerVwModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        if KAppDelegate.loginTypeVal == UserRole.Admin.rawValue {
            
            let color = UserDefaults.standard.string(forKey: "ColorKey")
            if color == "Green"{
                
                imgViewDrawerBg.image = UIImage(named: "ic_drawer_green_bg")
//                topBarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
//                bottomBarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
                
            }else if color == "Default"{

               imgViewDrawerBg.image = UIImage(named: "ic_drawer_bg")
//                topBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
//                bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                
            }else if color == "Black"{
                
                imgViewDrawerBg.image = UIImage(named: "ic_drawer_black_bg")
//                topBarView.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1)
//                bottomBarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
                
                
            }else if color == "Gold"{
                
                imgViewDrawerBg.image = UIImage(named: "ic_drawer_gold_bg")
//                topBarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
//                bottomBarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
                
            }else if color == "Blue"{
                
                imgViewDrawerBg.image = UIImage(named: "ic_drawer_blue_bg")
//                topBarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
//                bottomBarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
                
            }else if color == "Pink"{
                 imgViewDrawerBg.image = UIImage(named: "ic_drawer_pink_bg")
                
//                topBarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
//                bottomBarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
                
            }else if color == "Red"{
                
                imgViewDrawerBg.image = UIImage(named: "ic_drawer_red_bg")
//                topBarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
//                bottomBarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
                
            }else {
                imgViewDrawerBg.image = UIImage(named: "ic_drawer_bg")
                
//                topBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
//                bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            }
            
  }else{
   if KAppDelegate.objUserDetailModel.isParticipant == 1 {
                viewForSwitch.isHidden = false
                cnstForHeight.constant = 30
                btnSwitch.isSelected = (KAppDelegate.objUserDetailModel.isParticipant == 0) ? true : false
            } else {
                viewForSwitch.isHidden = true
                cnstForHeight.constant = 0
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue || KAppDelegate.loginTypeVal == UserRole.Patient.rawValue {
         }else{
            self.imgProfilePic.sd_setImage(with: URL.init(string: KAppDelegate.objUserDetailModel.profileImage!), placeholderImage:UIImage(named: "ic_profile-1"), completed: nil)
            lblName.text! = KAppDelegate.objUserDetailModel.fullName!
            
            let color = UserDefaults.standard.string(forKey: "ColorKey")
            if color == "Green"{
                
                imgViewDrawerBg.image = UIImage(named: "ic_drawer_green_bg")
                //                topBarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
                //                bottomBarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
                
            }else if color == "Default"{
                
                imgViewDrawerBg.image = UIImage(named: "ic_drawer_bg")
                //                topBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                //                bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                
            }else if color == "Black"{
                
                imgViewDrawerBg.image = UIImage(named: "ic_drawer_black_bg")
                //                topBarView.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1)
                //                bottomBarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
                
                
            }else if color == "Gold"{
                
                imgViewDrawerBg.image = UIImage(named: "ic_drawer_gold_bg")
                //                topBarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
                //                bottomBarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
                
            }else if color == "Blue"{
                
                imgViewDrawerBg.image = UIImage(named: "ic_drawer_blue_bg")
                //                topBarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
                //                bottomBarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
                
            }else if color == "Pink"{
                imgViewDrawerBg.image = UIImage(named: "ic_drawer_pink_bg")
                
                //                topBarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
                //                bottomBarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
                
            }else if color == "Red"{
                
                imgViewDrawerBg.image = UIImage(named: "ic_drawer_red_bg")
                //                topBarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
                //                bottomBarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
                
            }else {
                imgViewDrawerBg.image = UIImage(named: "ic_drawer_bg")
                
                //                topBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                //                bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func btnActionSwitchUser(_ sender: UIButton) {
        drawerVMObj.changeRole(0) {
            KAppDelegate.loginTypeVal = UserRole.Patient.rawValue
            KAppDelegate.objUserDetailModel.isParticipant = 0
            KAppDelegate.navigateToOtherVC(identifier: "DashboardPatientVC")
            sender.isSelected = !sender.isSelected
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

