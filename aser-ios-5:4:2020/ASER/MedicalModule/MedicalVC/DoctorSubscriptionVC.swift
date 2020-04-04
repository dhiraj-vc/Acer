
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

class DoctorSubscriptionVC: UIViewController
{
    // MARK: IB Outlets
    @IBOutlet weak var subscriptionTable: UITableView!
    
    // MARK: Variables
    var doctorSubVMobj = DoctorSubscriptionVM()

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.doctorSubVMobj.getDoctorSubscriptionPlan{
        self.subscriptionTable.reloadData()
    }
}
    
    //MARK:-ACTIONS
    @IBAction func restoreTap(_ sender: Any){
        InAppPurchase.sharedInstance.restoreTransactions()

    }
    @IBAction func menuTap(_ sender: Any){
        sideMenuViewController?._presentLeftMenuViewController()

    }
    @IBAction func actionSubscription(_ sender: Any){
        if doctorSubVMobj.selectedIndex == -1
        {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.PaymentAlert)
        } else {

            let detailVC = mainStoryboard.instantiateViewController(withIdentifier: "SubscriptionDetailVC") as! SubscriptionDetailVC
            detailVC.doctorSubVMobj.packageArray = [doctorSubVMobj.packageArray[doctorSubVMobj.selectedIndex]]
            self.navigationController?.pushViewController(detailVC, animated: true)
            
        }
    }
    

}
