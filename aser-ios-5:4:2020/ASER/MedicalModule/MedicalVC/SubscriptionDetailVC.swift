
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

class SubscriptionDetailVC: UIViewController {

    // MARK: Variabls
    var doctorSubVMobj = DoctorSubscriptionVM()
    var subDetilVMobj = SubscriptionDetailVM()

    // MARK: IB Oulets
    @IBOutlet weak var detailTable: UITableView!

    // MARK: view Life Cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool){
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectMethod), name: NSNotification.Name("InAppProductPurchasedNotification"), object: nil)
    }
    // MARK: IB Actions
    @IBAction func backTap(_ sender: Any){
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
   
    @IBAction func proceedTap(_ sender: Any){
        let dictPres = doctorSubVMobj.packageArray[0]

        InAppPurchase.sharedInstance.unlockProduct(dictPres.ios_plan_id)

        InAppPurchase.sharedInstance.planId = dictPres.plan_id!
    }
    @IBAction func termOfUseTap(_ sender: Any){
        
        let detailVC = mainStoryboard.instantiateViewController(withIdentifier: "WKWebViewVC") as! WKWebViewVC
        detailVC.title = "Terms & Conditions"
        detailVC.checkStr = "subscription"
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    @IBAction func privayTap(_ sender: Any){
        
        let detailVC = mainStoryboard.instantiateViewController(withIdentifier: "WKWebViewVC") as! WKWebViewVC
        detailVC.title = "Privacy Policy"
        detailVC.checkStr = "subscription"
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    @objc func didSelectMethod(_ objNotification: Notification){
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
}
