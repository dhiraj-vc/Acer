
//
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
import Foundation

class DoctorSubscriptionVM: NSObject
{
    var packageArray = [DoctorSubscriptionPlans]()
    
    var selectedIndex : Int = -1
    
    // MARK: Get Doctor Subscriptioj Plan
    func getDoctorSubscriptionPlan(_ completion:@escaping() -> Void){
        let urlString = "\(Apis.KDoctorPlans)"
        
        WebServiceProxy.shared.getData(urlString, showIndicator: true) { (response) in
            if response.success{
                
                if let responsedict =  response.data
                {
                    if let resArrr = responsedict["list"] as? NSArray {
                        for i in 0..<resArrr.count{
                            if let dictData = resArrr[i] as? NSDictionary
                            {
                                let planId = dictData.value(forKey: "ios_plan_id") as! String
                                
                                let objPres = DoctorSubscriptionPlans()
                                objPres.getPresDet(dictReport: dictData)
                                self.packageArray.append(objPres)
                                
                                // Compare Plan id
                                if KAppDelegate.objUserDetailModel.doctorSubPlanDict != nil
                                {
                                    let dict = KAppDelegate.objUserDetailModel.doctorSubPlanDict!.value(forKey: "Plan") as! NSDictionary
                                    
                                    if planId == dict.value(forKey: "ios_plan_id") as! String
                                    {
                                        self.selectedIndex = i
                                    }
                                }
                            }
                        }
                    }
                }
                completion()
            }else{
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
        }
    }
    
    // MARK: Sedn SubscriptionDetail to Server Side
    
    func sendSubscriptionIdToServer(param : [String:AnyObject],completion: @escaping() -> Void){
        
        var urlStr = ""
        
        if KAppDelegate.objUserDetailModel.doctorSubPlanDict != nil
        {
            urlStr = Apis.KTransactionUpdateSuccess
        }else{
            urlStr = Apis.KTransactionSuccess

        }
        WebServiceProxy.shared.postData("\(urlStr)", params: param, showIndicator: true)  { (response) in
            if response.success{
                
                if let responsedict =  response.data
                {
                    if let detailDict = responsedict["plan"] as? NSDictionary
                    {
                        KAppDelegate.objUserDetailModel.doctorSubPlanDict = detailDict
                        
                    }
                }
                completion()
            }else{
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
        }
    }
    
}

// MARK : TABlE DELEGATES
extension DoctorSubscriptionVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorSubVMobj.packageArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"DoctorSubscriptionPlanTVC" , for: indexPath)
            as! DoctorSubscriptionPlanTVC
        
        let dictPres = doctorSubVMobj.packageArray[indexPath.row]
        
        cell.ubscriptionName.text = String(format: "%@: $%d for %d Month",dictPres.title!,dictPres.plan_pricing!,dictPres.plan_validity!)
        
        if dictPres.patients_limit == 0
        {
            cell.subscriptionPrice.text = "Unlimited patients"
        }else{
            cell.subscriptionPrice.text = String(format: "%d Patients",dictPres.patients_limit!)
        }
        if doctorSubVMobj.selectedIndex == indexPath.row
        {
            cell.checBoxBtn.setImage(UIImage(named: "ic_radio_selected"), for: .normal)
        }else{
            cell.checBoxBtn.setImage(UIImage(named: "ic_radio_unselected"), for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        doctorSubVMobj.selectedIndex = indexPath.row
        
        self.subscriptionTable.reloadData()
    }
}
