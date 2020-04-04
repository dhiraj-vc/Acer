
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
class UserSettingVC: UIViewController {
    //MARK: VARIABLE & OUTLEST DECLARATION
    var objUserSettingVM = UserSettingVM()
    @IBOutlet weak var tblVwOptions: UITableView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        objUserSettingVM.isFingerPrint = KAppDelegate.objUserDetailModel.isFingerPrint
        objUserSettingVM.isPasscode = KAppDelegate.objUserDetailModel.isPasscode
        tblVwOptions.reloadData()
        tblVwOptions.estimatedRowHeight = 44
        tblVwOptions.rowHeight = UITableView.automaticDimension
        tblVwOptions.tableFooterView = UIView()
    }
    override func viewDidLoad() {
        
    }
    @IBAction func actionBack(_ sender: UIButton) {
    sideMenuViewController?._presentLeftMenuViewController()
    }
}
