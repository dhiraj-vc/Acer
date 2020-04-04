
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

class MedicalDrawerVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var imgViewDrawerBg: UIImageView!
    @IBOutlet weak var tblViewDrawer: UITableView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSwitch: UIButton!
    var drawerVMObj = MedicalDrawerVM()
    @IBOutlet weak var viewForSwitch: UIView!
    @IBOutlet weak var cnstForHeight: NSLayoutConstraint!
    
    //Mark: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue {
            viewForSwitch.isHidden = true
            cnstForHeight.constant = 0
        } else {
            viewForSwitch.isHidden = false
            cnstForHeight.constant = 30
            btnSwitch.isSelected = (KAppDelegate.objUserDetailModel.isParticipant == 1) ? true : false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.imgProfilePic.sd_setImage(with: URL.init(string: KAppDelegate.objUserDetailModel.profileImage!), placeholderImage:UIImage(named: "ic_profile-1"), completed: nil)
        lblName.text! = KAppDelegate.objUserDetailModel.fullName!
        drawerVMObj.getUnreadCount {
            self.tblViewDrawer.reloadData()
        }
        
    }
    
    //MARK:- Actions
    @IBAction func btnActionSwitchUser(_ sender: UIButton) {
        drawerVMObj.changeRole(1) {
            KAppDelegate.loginTypeVal = UserRole.User.rawValue
            KAppDelegate.objUserDetailModel.isParticipant = 1
            KAppDelegate.navigateToOtherVC(identifier: "UserDashboardVC")
            sender.isSelected = !sender.isSelected
        }
    }
}
