
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
class CreateResearchProgramVC: UIViewController {
    //MARK : OUTLETS
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var btnDrawer: UIButton!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var tblVwResearchList: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnCreateNew: UIButton!
    
    var objCreateResPrVM = CreateResearchProgramVM()
    
    @IBOutlet weak var createBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UserDefaults.standard.string(forKey: "ColorKey")
        if color == "Green"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            btnCreateNew.setBackgroundImage(UIImage(named: "bar_green@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Default"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
             btnCreateNew.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
            
        }else if color == "Black"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
             btnCreateNew.setBackgroundImage(UIImage(named: "bar_black@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Gold"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
             btnCreateNew.setBackgroundImage(UIImage(named: "bar_yellow@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Blue"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
             btnCreateNew.setBackgroundImage(UIImage(named: "bar_blue@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Pink"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
             btnCreateNew.setBackgroundImage(UIImage(named: "bar_pink@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Red"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
             btnCreateNew.setBackgroundImage(UIImage(named: "bar_red@2x.png"), for: UIControl.State.normal)
            
        }else {
            topBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
             btnCreateNew.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
        }
        if self.title == "Shared Survey"
        {
            createBtn.isHidden = true
        }
        else
        {
            createBtn.isHidden = false

        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshSharedList), name: NSNotification.Name("RefreshSharedList"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        if self.title == "Shared Survey"{
            self.objCreateResPrVM.cameFrom = "Shared Survey"
            self.lblMainTitle.text = "Shared Survey List"
        } else {
            self.lblMainTitle.text = "Research Program List"
        }
        objCreateResPrVM.getResearchList {
            if self.objCreateResPrVM.arrCreateRPModel.count>0{                
                self.tblVwResearchList.isHidden = false
                self.tblVwResearchList.reloadData()
            } else {
                if self.title == "Shared Survey" {
                    self.tblVwResearchList.isHidden = true
                    self.scrollView.isHidden = true
                    self.lblMainTitle.text = "Shared Survey List"
                } else {
                    self.lblMainTitle.text = "Create Quick Product Review"
                    self.scrollView.isHidden = false
                }                
            } 
        }
    }
    
    //MARK:- ACTIONS
    @IBAction func btnOpenDrawer(_ sender: UIButton)
    {
       self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnCreate(_ sender: UIButton) {
        KAppDelegate.arrForQuestion.removeAllObjects()
        let pushControllerObj = mainStoryboard.instantiateViewController(withIdentifier: "CreateResProgVC") as! CreateResProgVC
        pushControllerObj.createResProgVMObj.cameFrom = "CreateResearchPrgVC"
        self.navigationController?.pushViewController(pushControllerObj, animated: true)
    }
    
    @objc func refreshSharedList(){
        self.title = "Shared Survey"
        viewWillAppear(true)
    }
    
}
