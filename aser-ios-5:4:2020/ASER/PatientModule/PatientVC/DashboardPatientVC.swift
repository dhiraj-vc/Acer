
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

class DashboardPatientVC: UIViewController,UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var doctorCodeTF: UITextField!
    @IBOutlet weak var addCodeView: UIView!
    @IBOutlet weak var noDocView: UIView!
    @IBOutlet weak var docDetailView: UIView!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var vwDashboardTblVw: NSLayoutConstraint!
    @IBOutlet weak var tblVwDashBoardPatients: UITableView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserFeature: UILabel!
    var objDashboardPatientVM = DashboardPatientVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblUserName.text = KAppDelegate.objUserDetailModel.doctorDet.docName
        lblUserFeature.text  =  KAppDelegate.objUserDetailModel.doctorDet.designation
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.delegate = self // This is not required
        backgroundView.addGestureRecognizer(tap)
        
        if KAppDelegate.objUserDetailModel.doctorDet.profileFile == nil
        {
            
            docDetailView.isHidden = true
            
            noDocView.isHidden = false
        }
        else
        {
            imgVwUser.sd_setImage(with: URL(string: "\( KAppDelegate.objUserDetailModel.doctorDet.profileFile!)"), placeholderImage: UIImage(named: "ic_profile-1"))
            
            docDetailView.isHidden = false
            
            noDocView.isHidden = true
            
        }
        self.tblVwDashBoardPatients.register(UINib.init(nibName: "DashboardPatientTVC", bundle: nil), forCellReuseIdentifier: "DashboardPatientTVC")
        tblVwDashBoardPatients.reloadData()
        DispatchQueue.main.async {
            self.vwDashboardTblVw.constant = CGFloat(self.tblVwDashBoardPatients.contentSize.height)
        }
    }
    //Mark: -BtnAtraction.....
    
    @IBAction func addNewDoctor(_ sender: Any)
    {
        self.backgroundView.isHidden = false
        
        self.addCodeView.isHidden = false

    }
    
    @IBAction func btnOpenDrawer(_ sender: UIButton)
    {
        sideMenuViewController?._presentLeftMenuViewController()
    }
    
    @IBAction func btnChat(_ sender: UIButton) {
        let chatVC = mainStoryboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.objChatVM.messageToId = KAppDelegate.objUserDetailModel.doctorDet.doctorId
        KAppDelegate.currentViewCont = chatVC
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @IBAction func addDoctorToList(_ sender: Any)
    {
        if doctorCodeTF.text == ""
        {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.ENTERASSIGNCODE)
        }
        else
        {
            let param = [ "User[access_code]": doctorCodeTF.text! ,
                          ] as [String:AnyObject]
            WebServiceProxy.shared.postData("\(Apis.KAddDoctor)?access-token=\(Proxy.shared.authNil())", params: param, showIndicator: true) {  (ApiResponse) in
                
                    if let userDetDict = ApiResponse.data
                    {
                        if let detailDict = userDetDict["doctor"] as? NSDictionary
                        {
//                            let  finalDict = userDetDict.value(forKey: "doctor")
                            
                            self.doctorCodeTF.resignFirstResponder()
                            
                            KAppDelegate.objUserDetailModel.doctorDet.docName = detailDict.value(forKey: "full_name") as! String

                            KAppDelegate.objUserDetailModel.doctorDet.designation = detailDict.value(forKey: "designation") as! String

                            KAppDelegate.objUserDetailModel.doctorDet.profileFile = detailDict.value(forKey: "designation") as! String
                            
                            self.lblUserName.text = KAppDelegate.objUserDetailModel.doctorDet.docName
                            self.lblUserFeature.text  =  KAppDelegate.objUserDetailModel.doctorDet.designation

                            self.imgVwUser.sd_setImage(with: URL(string: "\( KAppDelegate.objUserDetailModel.doctorDet.profileFile!)"), placeholderImage: UIImage(named: "profile_file"))
                            
                            self.backgroundView.isHidden = true
                            
                            self.addCodeView.isHidden = true
                            
                            self.docDetailView.isHidden = false
                            
                            self.noDocView.isHidden = true
                        }
                }
            }
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil)
    {
        backgroundView.isHidden = true
        
        addCodeView.isHidden = true
    }
}
