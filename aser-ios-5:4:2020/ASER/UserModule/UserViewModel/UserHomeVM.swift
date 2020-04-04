
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
class UserHomeVM {
    var arrCreateRPModel = [CreateResearchProgramModel]()
    func getCurrentResearchList(_ completion:@escaping() -> Void){
        WebServiceProxy.shared.getData(Apis.KResearchAssignedList, showIndicator: true) { (response) in
            if response.success{
                self.arrCreateRPModel = []
                if let responseDict = response.data {
                    if let responseArr = responseDict["list"] as? NSArray{
                        for index in 0..<responseArr.count{
                            if let dictData = responseArr[index] as? NSDictionary{
                                let objCreateRPModel = CreateResearchProgramModel()
                                objCreateRPModel.getResearchList(dictDat: dictData)
                                self.arrCreateRPModel.append(objCreateRPModel)
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
}

extension UserHomeVC: UITableViewDelegate,UITableViewDataSource {
    //MARK:-->TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objUserHomeVM.arrCreateRPModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVwHome.dequeueReusableCell(withIdentifier: "ResearchTVC") as! ResearchTVC
        if objUserHomeVM.arrCreateRPModel.count>0{
        let dictDat = objUserHomeVM.arrCreateRPModel[indexPath.row]
            cell.lblCompany.text = "Company: \(dictDat.companyName!)"
            cell.lblProduct.text = "Product: \(dictDat.productName!)"
            cell.btnSetAlarm.tag = indexPath.row
          //  cell.btnSetAlarm.isHidden = (self.title == "View Survey") ? true : false
//            cell.btnSetAlarm.isSelected = (dictDat.isReminder == 0) ? false : true
            
            if self.title == "View Survey"{
                cell.btnSetAlarm.isHidden = true
            } else {
                cell.btnSetAlarm.isHidden = false
                
                if dictDat.isReminder == 0
                {
                    cell.btnSetAlarm.setImage(UIImage(named: "ic_bell"), for: .normal)
                }else{
                    cell.btnSetAlarm.setImage(UIImage(named: "ic_selected_bell"), for: .normal)
                }
            }
            
            cell.btnSetAlarm.addTarget(self, action: #selector(setAlarm(sender:)), for: .touchUpInside)
            let startDate = Proxy.shared.getDateFrmString(getDate:dictDat.reserachStartDate!, format: "yyyy-MM-dd")
            cell.btnStartDate.setTitle("Start Date: \(Proxy.shared.getStringFrmDate(getDate: startDate, format: "dd,MMM yyyy"))", for: .normal)
            let endDate = Proxy.shared.getDateFrmString(getDate:dictDat.reserachEndDate!, format: "yyyy-MM-dd")
            cell.btnEndDate.setTitle("End Date: \(Proxy.shared.getStringFrmDate(getDate: endDate, format: "dd,MMM yyyy"))", for: .normal)
        }
        return cell         
    }
    //NAVIGATE TO QUESTANIORE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchProgramDetailVC")  as! SearchProgramDetailVC
         let dictDat = objUserHomeVM.arrCreateRPModel[indexPath.row]
        objVC.objSearchPDVW.researchID = dictDat.id!
        if self.title == "View Survey"{
            objVC.title = "View Survey"
        }
        objVC.objSearchPDVW.arrCreateRPModel = [objUserHomeVM.arrCreateRPModel[indexPath.row]]
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    //MARK:- btnSetAlarmAction
    @objc func setAlarm(sender:UIButton) {
         let dictDat = objUserHomeVM.arrCreateRPModel[sender.tag]
        if sender.image(for: .normal) == UIImage(named: "ic_selected_bell") {
            let param = [ "Reminder[research_id]":  dictDat.id!] as [String:AnyObject]
            WebServiceProxy.shared.postData(Apis.KSetAlarm, params: param, showIndicator: true) { (ApiResponse) in
                if ApiResponse.success {
                    Proxy.shared.displayStatusCodeAlert(AlertMsgs.AlarmSetRemoved)
                    self.viewWillAppear(true)
                }
                else{
                    Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
                }
            }
        } else {
        let setAlarm = mainStoryboard.instantiateViewController(withIdentifier: "SetAlarmVC") as! SetAlarmVC
        setAlarm.researchId = dictDat.id!
        self.navigationController?.present(setAlarm, animated: true, completion: nil)
        }
    }
}
