
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

class UserDashboardVC: UIViewController, UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
   //MARK:- Outlets
    @IBOutlet weak var clcViewDashboard: UICollectionView!
    var arrIcons = [["Title":"Current Survey","Image":"ic_current_survey","NextVC":"UserHomeVC"],
                    ["Title":"View Survey","Image":"ic_shared","NextVC":"UserHomeVC"],
                    ["Title":"Quick Product Review","Image":"ic_shared","NextVC":"UserAddResearchVC"],["Title":"Profile","Image":"ic_profile-2","NextVC":"UserProfileUpdateVC"],["Title":"Notification","Image":"ic_home_notification","NextVC":"NotificationVC"],
        ["Title":"Gallery","Image":"ic_gallery","NextVC":"GalleryVC"],
        ["Title":"Research History","Image":"ic_history-1","NextVC":"ResearchHistoryVC"]]
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
        let dictDash = arrIcons[indexPath.row]
        cell.btnGotoNext.tag = indexPath.row
        cell.lblCellTitle.text = dictDash["Title"]
        cell.imgViewIcon.image = UIImage(named:"\(dictDash["Image"]!)")
        cell.btnGotoNext.addTarget(self, action: #selector(gotoNextVC(_:)), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = ((clcViewDashboard.frame.size.width-16)/3)
        let height =  width+40
        let size = CGSize(width: width, height: height)
        return size
    }
    @objc func gotoNextVC(_ sender:UIButton){
        let dictDash = arrIcons[sender.tag]
        let nextVC = dictDash["NextVC"]
         if dictDash["Title"] == "View Survey" {
            let surveyVC = mainStoryboard.instantiateViewController(withIdentifier: "UserHomeVC") as! UserHomeVC
        surveyVC.title = "View Survey"
             self.navigationController?.pushViewController(surveyVC, animated: true)
        } else {
            Proxy.shared.pushToNextVC(identifier: nextVC!, isAnimate: true, currentViewController: self)
        }
     }
}
