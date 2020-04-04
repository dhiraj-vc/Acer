
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

class ParticipentAddListVC: UIViewController {
    //MARK:-->IBOUTLETS
    @IBOutlet weak var tblVwPrt: UITableView!
    
    
    // for color
    @IBOutlet weak var topBarVw: UIView!
    @IBOutlet weak var bottomBarVw: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var lblMainTitle: UILabel!
   
    @IBOutlet weak var addBtn: UIButton!
    
    var objPartcipantAddVM = ParticipentAddListVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UserDefaults.standard.string(forKey: "ColorKey")
        if color == "Green"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            
        }else if color == "Default"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            
        }else if color == "Black"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            
            
        }else if color == "Gold"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            
        }else if color == "Blue"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            
        }else if color == "Pink"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            
        }else if color == "Red"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            
        }else {
            topBarVw.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.title == "ShareProgram"{
            lblMainTitle.text = "Admin List"
            objPartcipantAddVM.alertMessage = AlertMsgs.KSHARERESEARCHWITHADMIN
            objPartcipantAddVM.getAdminListForShareResearch {
                self.handleResponse()
            }
            
        }else{
            lblMainTitle.text = "Add Participants"
            objPartcipantAddVM.alertMessage = AlertMsgs.KADDPARTICIPANTS
            objPartcipantAddVM.getParticipantListToAdd {
                self.handleResponse()
            }
        }
    }
    
    //MARK:-->BUTTON ACTION
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnAddParticipents(_ sender: Any)
    {
    }
}