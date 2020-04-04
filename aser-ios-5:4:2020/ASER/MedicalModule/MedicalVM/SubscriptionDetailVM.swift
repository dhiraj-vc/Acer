
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

import Foundation
import UIKit

class SubscriptionDetailVM: NSObject
{

}
// MARK : TABlE DELEGATES
extension SubscriptionDetailVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"PlansDetailTVC" , for: indexPath)
            as! PlansDetailTVC

        let dictPres = doctorSubVMobj.packageArray[0]

        if indexPath.row == 0
        {
            cell.titleLbl.text = String(format: "%@ Pack",dictPres.title!)
            cell.descLbl.text = ""
        }else if indexPath.row == 1{
            cell.titleLbl.text = String(format: "%d Month", dictPres.plan_validity!)//"Price per Month:"
            
            cell.descLbl.text = String(format: "$%d",dictPres.plan_pricing!)

        } else if indexPath.row == 2 {
            cell.titleLbl.text = "Patients’ Limit:"
            
            if dictPres.patients_limit == 0
            {
                cell.descLbl.text = "Unlimited patients"
            } else{
                cell.descLbl.text = String(format: "%d Patients",dictPres.patients_limit!)
            }

        }
        else if indexPath.row == 3
        {
            cell.titleLbl.text = "Basic Features:"
            
            if dictPres.patients_limit == 0
            {
                cell.descLbl.text = "Doctor can add his Unlimited Patients, Communicate with these Unlimited patients inside the app via text, share the description, receive the pictures or documents. Doctor and his Unlimited patients will receive push notifications on message alert. The patient can book appointment on the app with his/her doctor. They can also cancel or reschedule the appointments. Their record will be available on the app anytime for their future use. The doctor can add or remove the patients. The added patient can enjoy the research study (free) features of the app with same ID and Password."
                
            } else {
                cell.descLbl.text = String(format: "Doctor can add his %d Patients, Communicate with these %d patients inside the app via text, share the description, receive the pictures or documents. Doctor and his %d patients will receive push notifications on message alert. The patient can book appointment on the app with his/her doctor. They can also cancel or reschedule the appointments. Their record will be available on the app anytime for their future use. The doctor can add or remove the patients. The added patient can enjoy the research study (free) features of the app with same ID and Password.",dictPres.patients_limit!,dictPres.patients_limit!,dictPres.patients_limit!)            }       

        } else if indexPath.row == 4 {
            cell.titleLbl.text = ""
            
            cell.descLbl.text = "Payment will be charged to iTunes Account at confirmation of purchases."

        }else if indexPath.row == 5{
            cell.titleLbl.text = ""
            
            cell.descLbl.text = "Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period."
        } else if indexPath.row == 6 {
            cell.titleLbl.text = ""

            cell.descLbl.text = "Account will be charged for renewal within 24-hours prior to the end of the current period."
        } else {
            cell.titleLbl.text = ""
            
            cell.descLbl.text = "Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 3
        {
            return 250
        } else if indexPath.row == 7 || indexPath.row == 5{
            return 90
        } else {
            return 60
        }
    }

}
