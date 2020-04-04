
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

class MedicalDrawerVM: NSObject {
    var drawerArray = [
        ["Home","ic_home","ListOfPatientsVC"] ,
        ["Profile","ic_profile","UserProfileUpdateVC"],
        ["Choose Package","ic_subscriptiontwo","DoctorSubscriptionVC"],
        ["Appointments","ic_appointments_drawer","AppointmentListVC"],
        ["Chat","ic_chat_wht","ChatListVC"],
        ["Privacy Policy","ic_privacy","WKWebViewVC"],
        ["Guidelines and Terms", "ic_guidelines", "WKWebViewVC"],
        ["About Us","ic_about_us","WKWebViewVC"],
        ["Contact Us","ic_contact_us","ContactUsVC"],
        ["Settings","ic_settings","UserSettingVC"],
        ["FAQs","ic_FAQ","FAQsVC"],
        ["Logout","ic_logout","WelcomeVC"]]
    
    var drawerArray2 = [
        ["Home","ic_home","ListOfPatientsVC"] ,
        ["Profile","ic_profile","UserProfileUpdateVC"],
        ["Appointments","ic_appointments_drawer","AppointmentListVC"],
        ["Chat","ic_chat_wht","ChatListVC"],
        ["Privacy Policy","ic_privacy","WKWebViewVC"],
        ["Guidelines and Terms", "ic_guidelines", "WKWebViewVC"],
        ["About Us","ic_about_us","WKWebViewVC"],
        ["Contact Us","ic_contact_us","ContactUsVC"],
        ["Settings","ic_settings","UserSettingVC"],
        ["FAQs","ic_FAQ","FAQsVC"],
        ["Logout","ic_logout","WelcomeVC"]]
    
    func changeRole(_ userType:Int, completion:@escaping() -> Void){
        WebServiceProxy.shared.getData("\(Apis.KChangeRole)\(userType)", showIndicator: true) { (response) in
            if response.success{
                completion()
            }
        }
    }
    func getUnreadCount(_ completion:@escaping() -> Void){
        WebServiceProxy.shared.getData("\(Apis.KGetUnreadCount)", showIndicator: true) { (response) in
            if response.success{
                if let count = response.data!["count"] as? Int {
                    KAppDelegate.objUserDetailModel.unReadChat = count
                } else if let count = response.data!["count"] as? String {
                    KAppDelegate.objUserDetailModel.unReadChat = Int(count)!
                }
            }
            completion()
        }
    }
}

extension MedicalDrawerVC: UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    //MARK:- Table view DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue
        {
            return drawerVMObj.drawerArray.count
        }else{
            return drawerVMObj.drawerArray2.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let drawerCell = tableView.dequeueReusableCell(withIdentifier: "DrawerTVC") as! DrawerTVC
        
        drawerCell.imgViewIcon.image = UIImage(named:drawerVMObj.drawerArray[indexPath.row][1] )
        
        if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue
        {
            drawerCell.lblTitle.text = drawerVMObj.drawerArray[indexPath.row][0]
            drawerCell.lblBottomLine.isHidden = (indexPath.row==4 || indexPath.row==6) ? false : true
            if drawerCell.lblTitle.text == "Chat" && KAppDelegate.objUserDetailModel.unReadChat! > 0 {
                drawerCell.btnUnreadCount.isHidden = false
                drawerCell.btnUnreadCount.setTitle("\(KAppDelegate.objUserDetailModel.unReadChat!)", for: .normal)
            } else {
                drawerCell.btnUnreadCount.isHidden = true
            }

        } else {
            drawerCell.lblTitle.text = drawerVMObj.drawerArray2[indexPath.row][0]
            drawerCell.lblBottomLine.isHidden = (indexPath.row==3 || indexPath.row==5) ? false : true
            if drawerCell.lblTitle.text == "Chat" && KAppDelegate.objUserDetailModel.unReadChat! > 0 {
                drawerCell.btnUnreadCount.isHidden = false
                drawerCell.btnUnreadCount.setTitle("\(KAppDelegate.objUserDetailModel.unReadChat!)", for: .normal)
            } else {
                drawerCell.btnUnreadCount.isHidden = true
            }

        }
        
        drawerCell.selectionStyle = .none
        return drawerCell
    }
    //MARK:- Table View Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue{
            //HERE TITLE IS USED AS CAME FROM FOR SOME CASES DO NOT DELETE OR CHNAGE IT
            switch indexPath.row{
            case 5: navigationSSA("WKWebViewVC", title: "Privacy Policy")
            case 6: navigationSSA("WKWebViewVC", title: "Guidelines")
            case 7: navigationSSA("WKWebViewVC", title: "About Us" )
            case 11:
                Proxy.shared.logout{
                    KAppDelegate.objUserDetailModel.doctorDet.profileFile = nil
                    KAppDelegate.objUserDetailModel.doctorDet.docName = ""
                    KAppDelegate.objUserDetailModel.doctorDet.designation  = ""
  
                    KAppDelegate.loginTypeVal = UserRole.Admin.rawValue
                    Proxy.shared.rootWithoutDrawer(identifier: "WelcomeVC")
                }
            default:
                navigationSSA(drawerVMObj.drawerArray[indexPath.row][2])
                break
            }
        } else{
            switch indexPath.row{
            case 0: navigationSSA("DashboardPatientVC", title: "HOME")
            case 4: navigationSSA("WKWebViewVC", title: "Privacy Policy")
            case 5: navigationSSA("WKWebViewVC", title: "Guidelines")
            case 6: navigationSSA("WKWebViewVC", title: "About Us" )
            case 10:
                Proxy.shared.logout{
                    KAppDelegate.loginTypeVal = UserRole.Admin.rawValue
                    Proxy.shared.rootWithoutDrawer(identifier: "WelcomeVC")
                }
            default:
                navigationSSA(drawerVMObj.drawerArray2[indexPath.row][2])
                break
            }
        }
    }
    
    func navigationSSA(_ viewController:String, title : String = " "){
        let newVC = mainStoryboard.instantiateViewController(withIdentifier: viewController)
        if title != " "{
            newVC.title = title
        }
        let navig = UINavigationController(rootViewController: (newVC))
        navig.isNavigationBarHidden = true
        navig.shouldPerformSegue(withIdentifier: "\(newVC)", sender: self)
        KAppDelegate.currentViewCont = newVC
        sideMenuViewController?.contentViewController = navig
        sideMenuViewController?.hideMenuViewController()
    }
}

