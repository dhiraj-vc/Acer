
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
import CZPicker

class AdminHomeVC: UIViewController, UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout, CZPickerViewDelegate,CZPickerViewDataSource{

    
    //MARK:- Outlets
    @IBOutlet weak var clcViewDashboard: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    
//    Create Research
//    var colorArray = ["Default","Black","Gold","Green","Blue","Pink","Red"]
    var colorArray = ["Default","Gold","Green","Blue","Pink","Red"]
   var arrIcons = [["Title":"Create Research","Image":"ic_create","NextVC":"CreateResearchProgramVC"],
                         ["Title":"Shared Survey","Image":"ic_shared","NextVC":"UserHomeVC"],
                         ["Title":"Profile","Image":"ic_profile-2","NextVC":"ProfileVC"],["Title":"Notification","Image":"ic_home_notification","NextVC":"NotificationVC"],["Title":"Templates","Image":"ic_create","NextVC":"TemplatesListVC"],
                         ["Title":"Research History","Image":"ic_history-1","NextVC":"ResearchHistoryVC"],["Title":"Research Id","Image":"ic_shared","NextVC":"ResearchIdVC"],
    ["Title":"Change Color","Image":"ic_history-1","NextVC":"12"]]
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK:- Actions
    @IBAction func btnOpenDrawer(_ sender: UIButton) {
        sideMenuViewController?._presentLeftMenuViewController()
    }
   //MARK:- CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCVC", for: indexPath) as! DashboardCVC
        
        let color = UserDefaults.standard.string(forKey: "ColorKey")
        if color == "Green"{
           cell.btnGotoNext .setBackgroundImage(UIImage(named: "gradationgreen.png"), for: UIControl.State.normal)
            topView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            bottomView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
        }else if color == "Black"{
            
            cell.btnGotoNext .setBackgroundImage(UIImage(named: "gradationblack.png"), for: UIControl.State.normal)
            topView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            bottomView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
           
        }else if color == "Gold"{
            cell.btnGotoNext .setBackgroundImage(UIImage(named: "gradationgold.png"), for: UIControl.State.normal)
            topView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            bottomView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            
        }else if color == "Blue"{
            cell.btnGotoNext .setBackgroundImage(UIImage(named: "gradationblue.png"), for: UIControl.State.normal)
            topView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            bottomView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            
        }else if color == "Pink"{
            cell.btnGotoNext .setBackgroundImage(UIImage(named: "gradationpink.png"), for: UIControl.State.normal)
            
            topView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            bottomView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            
        }else if color == "Red"{
            cell.btnGotoNext .setBackgroundImage(UIImage(named: "gradationred.png"), for: UIControl.State.normal)
            
            topView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            bottomView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            
        }else{
            cell.btnGotoNext .setBackgroundImage(UIImage(named: "ic_box_red"), for: UIControl.State.normal)
            topView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        }
        
        
        
        let dictDash = arrIcons[indexPath.row]
        cell.btnGotoNext.tag = indexPath.row
        cell.lblCellTitle.text = dictDash["Title"]
        cell.imgViewIcon.image = UIImage(named:"\(dictDash["Image"]!)")
        cell.btnGotoNext.addTarget(self, action: #selector(gotoNextVC(_:)), for: .touchUpInside)
        return cell
    }
    
    
    
//    func  collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = ((clcViewDashboard.frame.size.width-16)/3)
        let height =  width+40
        let size = CGSize(width: width, height: height)
        return size
    }
    @objc func gotoNextVC(_ sender:UIButton){
        let dictDash = arrIcons[sender.tag]
        let nextVC = dictDash["NextVC"]
        if dictDash["Title"] == "Shared Survey" {
            let surveyVC = mainStoryboard.instantiateViewController(withIdentifier: "CreateResearchProgramVC") as! CreateResearchProgramVC
            surveyVC.title = "Shared Survey"
            self.navigationController?.pushViewController(surveyVC, animated: true)
        } else if dictDash["Title"] == "Change Color"{
            print("No color selected")
            let picker = CZPickerView(headerTitle: "Header", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
            picker!.delegate = self
            picker!.dataSource = self
            picker!.needFooterView = true
            picker!.show()
        } else if dictDash["Title"] == "Research Id"{
            Proxy.shared.presentToNextVC(identifier: nextVC!, isAnimate: true, currentViewController: self)
        }else {
            Proxy.shared.pushToNextVC(identifier: nextVC!, isAnimate: true, currentViewController: self)
        }
    }
    
    // picker view delegate
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return colorArray.count
    }
   
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return colorArray[row]
//        "option \(row)";
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
      
        NSLog("Clicked \(colorArray[row])")
        if colorArray[row] == "Green"{
            UserDefaults.standard.set("Green", forKey: "ColorKey")
            topView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            bottomView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            clcViewDashboard.reloadData()
        }else if colorArray[row] == "Default"{
            UserDefaults.standard.set("Default", forKey: "ColorKey")
            topView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            clcViewDashboard.reloadData()
        }
//        else if colorArray[row] == "Black"{
//            UserDefaults.standard.set("Default", forKey: "ColorKey")
//            topView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
//            bottomView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
//            
//            clcViewDashboard.reloadData()
//        }
        else if colorArray[row] == "Gold"{
            UserDefaults.standard.set("Gold", forKey: "ColorKey")
            topView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
             bottomView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            clcViewDashboard.reloadData()
        }else if colorArray[row] == "Blue"{
            UserDefaults.standard.set("Blue", forKey: "ColorKey")
            topView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            bottomView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            clcViewDashboard.reloadData()
        }else if colorArray[row] == "Pink"{
            UserDefaults.standard.set("Pink", forKey: "ColorKey")
            topView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            bottomView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            clcViewDashboard.reloadData()
        }else if colorArray[row] == "Red"{
            UserDefaults.standard.set("Red", forKey: "ColorKey")
            topView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            bottomView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            clcViewDashboard.reloadData()
        }
        
        let color = UserDefaults.standard.string(forKey: "ColorKey")
        print(color!)
    }
}
