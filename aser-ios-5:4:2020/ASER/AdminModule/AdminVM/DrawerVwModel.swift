//
//  DrawerVwModel.swift
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
class DrawerVwModel: NSObject {
    var drawerArray = [
        ["Home","ic_home","AdminHomeVC"] ,
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
}

extension DrawerVC: UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    //MARK:- Table view DataSource    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawerVMObj.drawerArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let drawerCell = tableView.dequeueReusableCell(withIdentifier: "DrawerTVC") as! DrawerTVC
        if KAppDelegate.loginTypeVal == UserRole.User.rawValue && indexPath.row == 4 {
            drawerCell.imgViewIcon.image = UIImage(named: "ic_contact_us")
            drawerCell.lblTitle.text = "Contact Me"
        } else{
            drawerCell.imgViewIcon.image = UIImage(named:drawerVMObj.drawerArray[indexPath.row][1] )
            drawerCell.lblTitle.text = drawerVMObj.drawerArray[indexPath.row][0]
        }
//        drawerCell.lblBottomLine.isHidden = (indexPath.row==5 || indexPath.row==7) ? false : true
        drawerCell.lblBottomLine.isHidden = true
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
        
        if KAppDelegate.loginTypeVal == UserRole.User.rawValue || KAppDelegate.loginTypeVal == UserRole.Patient.rawValue{
                //HERE TITLE IS USED AS CAME FROM FOR SOME CASES DO NOT DELETE OR CHNAGE IT
                switch indexPath.row{
                case 0: navigationSSA("UserDashboardVC")

                case 1: navigationSSA("WKWebViewVC", title: "Privacy Policy")
                case 2: navigationSSA("WKWebViewVC", title: "Guidelines")
                case 3: navigationSSA("WKWebViewVC", title: "About Us" )
                case 7:
                    Proxy.shared.logout{
                        KAppDelegate.loginTypeVal = UserRole.Admin.rawValue
                        Proxy.shared.rootWithoutDrawer(identifier: "WelcomeVC")
                    }
                default:
                    navigationSSA(drawerVMObj.drawerArray[indexPath.row][2])
                    break
                }
             
        } else { //MARK : ADMIN ROLE
                   if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue{
                    
                    switch indexPath.row{
                    case 7:
                        KAppDelegate.loginTypeVal = UserRole.Admin.rawValue
                        Proxy.shared.rootWithoutDrawer(identifier: "WelcomeVC")
                        default:
                        break
                     }
                   }else{
                    switch indexPath.row{

                    case 1: navigationSSA("WKWebViewVC", title: "Privacy Policy")
                    case 2: navigationSSA("WKWebViewVC", title: "Guidelines")
                    case 3: navigationSSA("WKWebViewVC", title: "About Us" )
                    case 7:
                        Proxy.shared.logout{
                            Proxy.shared.rootWithoutDrawer(identifier: "WelcomeVC")
                        }
                    default:
                        navigationSSA(drawerVMObj.drawerArray[indexPath.row][2])
                        break
                    }
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

