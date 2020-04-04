
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

class ResearchHistoryVC: UIViewController {
    //MARK:--> IBOUTLETS & VARIABLES
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var btnDrawer: UIButton!
    @IBOutlet weak var lblMainTitle: UILabel!
    var researchHistoryVMObj = ResearchHIstoryVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginTypeVal  = KAppDelegate.loginTypeVal
        print(loginTypeVal)
        
        if loginTypeVal == 1 {
        
            let color = UserDefaults.standard.string(forKey: "ColorKey")
            if color == "Green"{
                
                topBarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
                bottomBarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
                
            }else if color == "Default"{
                
                topBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                
            }else if color == "Black"{
                
                topBarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
                bottomBarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
                
                
            }else if color == "Gold"{
                
                topBarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
                bottomBarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
                
            }else if color == "Blue"{
                
                topBarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
                bottomBarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
                
            }else if color == "Pink"{
                
                topBarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
                bottomBarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
                
            }else if color == "Red"{
                
                topBarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
                bottomBarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
                
            }else {
                topBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            }
        
        }else{
            print("the main coder is fool")
        }
        
        
        tblVw.tableFooterView = UIView()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.title == "Notification"{
            btnDrawer.setImage(UIImage(named: "ic_back"), for: .normal)
        }
        researchHistoryVMObj.researchHistoryList {
           if self.researchHistoryVMObj.arrCreateRPModel.count>0{
                self.tblVw.isHidden = false
                self.tblVw.reloadData()
            }else{
                self.tblVw.isHidden = true
            }
         }
    }
    //MARK:--> BUTTON ACTION
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
}
