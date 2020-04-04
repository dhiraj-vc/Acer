
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
class UserHomeVC: UIViewController {
    //MARK:--> IBOUTLETS & VARIABLES
    @IBOutlet weak var tblVwHome: UITableView!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var objUserHomeVM = UserHomeVM()

    @IBOutlet weak var topListBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVwHome.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshHomeList), name: NSNotification.Name("RefreshHomeList"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        //CHECK FOR ASSIGNED RESEARCH LIST
        if self.title == "View Survey"{
            self.lblMainTitle.text = "View Survey"
            self.scrollView.isHidden = false
            topListBtn.isHidden = true
            
        }else{
            topListBtn.isHidden = false

            objUserHomeVM.getCurrentResearchList {
                if self.objUserHomeVM.arrCreateRPModel.count>0 {
                    self.lblMainTitle.text = "Research Program List"
                    self.tblVwHome.isHidden = false
                    self.tblVwHome.reloadData()
                }else{
                    self.lblMainTitle.text = "Research Program List"
                    self.scrollView.isHidden = false
            }
         }
        }
        //ENTERED ASSIGNED CODE NOTIFCATION RESEARCH LIST
         NotificationCenter.default.addObserver(self, selector: #selector(assignCode(_:)), name: NSNotification.Name("assignCode"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(alarmSet(_:)), name: NSNotification.Name("AlarmSet"), object: nil)
    }
    @objc func refreshHomeList(){
       viewWillAppear(true)
    }
    
    @objc func assignCode(_ notification: Notification) {
        if self.title == "View Survey"{
            if let responseDict = notification.object as? NSDictionary{
                if let responseArr = responseDict["program"] as? NSDictionary{
                    let objCreateRPModel = CreateResearchProgramModel()
                    objCreateRPModel.getResearchList(dictDat: responseArr)
                    objUserHomeVM.arrCreateRPModel.append(objCreateRPModel)
                    self.lblMainTitle.text = "Research Program List"
                    self.tblVwHome.isHidden = false
                    self.tblVwHome.reloadData()
                }
            }
        }else{
            objUserHomeVM.getCurrentResearchList {
                if self.objUserHomeVM.arrCreateRPModel.count>0 {
                    self.lblMainTitle.text = "Research Program List"
                    self.tblVwHome.isHidden = false
                    self.tblVwHome.reloadData()
                }
            }
        }
    }
     @objc func alarmSet(_ notification: Notification) {
        viewWillAppear(true)
    }
    
    //MARK:- Actions
    @IBAction func actionEnterAssignCode(_ sender: UIButton) {
//       Proxy.shared.presentToNextVC(identifier: "EnterAssignCodeVC", isAnimate: true, currentViewController: self)
        let objVC = mainStoryboard.instantiateViewController(withIdentifier: "EnterAssignCodeVC") as! EnterAssignCodeVC
        if self.title == "View Survey"{
            objVC.title =  "View Survey"
        }
        self.navigationController?.present(objVC, animated: true)
    }
    @IBAction func btnDrawer(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Back"{
            Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func btnEnterCode(_ sender: UIButton) {
        let objVC = mainStoryboard.instantiateViewController(withIdentifier: "EnterAssignCodeVC") as! EnterAssignCodeVC
        if self.title == "View Survey"{
            objVC.title =  "View Survey"
        }
        self.navigationController?.present(objVC, animated: true)
    }
  }

