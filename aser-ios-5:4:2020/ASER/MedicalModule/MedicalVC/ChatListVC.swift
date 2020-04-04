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

class ChatListVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var tblViewChatList: UITableView!
    @IBOutlet weak var btnCall: UIButton!
    
    var objChatListVM = ChatListVM()
    
    //Mark: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCall.isHidden = (KAppDelegate.loginTypeVal == UserRole.Medical.rawValue) ? true : false
       
    }
    override func viewWillAppear(_ animated: Bool) {
        objChatListVM.getChatList {
            self.tblViewChatList.reloadData()
        }
    }
    
    //MARK:- Actions
    @IBAction func btnBack(_ sender: UIButton) {
        sideMenuViewController?._presentLeftMenuViewController()
    }
    
    @IBAction func btnCallAction(_ sender: UIButton) {
        if let url = URL(string: "tel://\(AppInfo.EmergencyNo)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
