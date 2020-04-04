
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

class DetailsVC: UIViewController {
    
    //MARK:-->IBOUTLETS & VARIBALES
    @IBOutlet weak var tblVwDetail: UITableView!
    @IBOutlet weak var cnstHeightForTable: NSLayoutConstraint!
    
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var bckBtn: UIButton!
    @IBOutlet weak var surveyQuestionLbl: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    var detailVMObj = DetailsVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = UserDefaults.standard.string(forKey: "ColorKey")
        if color == "Green"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
             cancelBtn.setBackgroundImage(UIImage(named: "bar_green@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Default"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            cancelBtn.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
           
            
        }else if color == "Black"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            
            cancelBtn.setBackgroundImage(UIImage(named: "bar_black@2x.png"), for: UIControl.State.normal)
            
            
        }else if color == "Gold"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            cancelBtn.setBackgroundImage(UIImage(named: "bar_yellow@2x.png"), for: UIControl.State.normal)
            
            
        }else if color == "Blue"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            
            cancelBtn.setBackgroundImage(UIImage(named: "bar_blue@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Pink"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            cancelBtn.setBackgroundImage(UIImage(named: "bar_pink@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Red"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            
            cancelBtn.setBackgroundImage(UIImage(named: "bar_red@2x.png"), for: UIControl.State.normal)
            
        }else {
            topBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            cancelBtn.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
            
        }
        
        tblVwDetail.layer.borderColor = UIColor.lightGray.cgColor
        tblVwDetail.layer.borderWidth = 1
        self.tblVwDetail.register(UINib.init(nibName: "DetailTVC", bundle: nil), forCellReuseIdentifier: "DetailTVC")
        tblVwDetail.reloadData()
        cnstHeightForTable.constant = tblVwDetail.contentSize.height
    }
    
    //MARK:--> BUTTON ACTION
    @IBAction func btnBack(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier:"CreateResearchProgramVC", isAnimate: false, currentViewController: self)
    }
    
    @IBAction func btnAddServeyQuestion(_ sender: UIButton) {
         Proxy.shared.pushToNextVC(identifier: "SurveyQuestionVC", isAnimate: true, currentViewController: self)
    }
}
