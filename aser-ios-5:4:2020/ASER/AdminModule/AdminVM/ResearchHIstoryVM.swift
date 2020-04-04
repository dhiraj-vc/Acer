
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
class ResearchHIstoryVM: NSObject {
    var cameFrom = String()
    var arrCreateRPModel = [CreateResearchProgramModel]()
    var totalPageCount = 0
    var pageCount = 0
    func researchHistoryList(_ completion:@escaping() -> Void) {
        var urlStr = ""
        if KAppDelegate.loginTypeVal == UserRole.User.rawValue{
            urlStr = "\(Apis.KResearchAssignedList)?pageCount=\(pageCount)&completed=true"
        }else{
            urlStr = "\(Apis.KResearchProgList)?pageCount=\(pageCount)&completed=true"
        }
        
        WebServiceProxy.shared.getData(urlStr, showIndicator: true) { (response) in
            if response.success{
                if let responseDict = response.data {
                    if let dictMeta = responseDict["_meta"] as? NSDictionary{
                        if let totalPages = dictMeta["pageCount"] as? Int {
                            self.totalPageCount = totalPages
                        }
                    }
                    if self.pageCount == 0 {
                        self.arrCreateRPModel = []
                    }
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
                if self.pageCount == 0 {
                    Proxy.shared.displayStatusCodeAlert(response.message!)
                }
            }
        }
    }

}
extension ResearchHistoryVC : UITableViewDataSource,UITableViewDelegate{
     //MARK:--> TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return researchHistoryVMObj.arrCreateRPModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dictDat = researchHistoryVMObj.arrCreateRPModel[indexPath.row]
        let cell = tblVw.dequeueReusableCell(withIdentifier: "ResearchTVC", for: indexPath) as! ResearchTVC
        cell.lblCompany.text = "Company: \(dictDat.companyName!)"
        cell.lblProduct.text = "Product: \(dictDat.productName!)"
        
        let startDate = Proxy.shared.getDateFrmString(getDate:dictDat.reserachStartDate!, format: "yyyy-MM-dd")
        cell.btnStartDate.setTitle("Start Date: \(Proxy.shared.getStringFrmDate(getDate: startDate, format: "dd,MMM yyyy"))", for: .normal)
        let endDate = Proxy.shared.getDateFrmString(getDate:dictDat.reserachEndDate!, format: "yyyy-MM-dd")
        cell.btnEndDate.setTitle("End Date: \(Proxy.shared.getStringFrmDate(getDate: endDate, format: "dd,MMM yyyy"))", for: .normal)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if KAppDelegate.loginTypeVal == UserRole.User.rawValue{
            //TODO USER MODULE
        }else{
            let objVC = mainStoryboard.instantiateViewController(withIdentifier: "SubmittedSurveyAnsVC") as! SubmittedSurveyAnsVC
            objVC.title = "ShareProgram"
            objVC.objSubSurveyAnsVM.researchId = researchHistoryVMObj.arrCreateRPModel[indexPath.row].id!
            self.navigationController?.pushViewController(objVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == researchHistoryVMObj.arrCreateRPModel.count-1{
            if researchHistoryVMObj.pageCount+1 < researchHistoryVMObj.totalPageCount{
                researchHistoryVMObj.pageCount += 1
                researchHistoryVMObj.researchHistoryList {
                    self.tblVw.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
