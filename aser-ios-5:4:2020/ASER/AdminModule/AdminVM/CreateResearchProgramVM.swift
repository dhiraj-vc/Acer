
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

class CreateResearchProgramVM: NSObject {
    var arrCreateRPModel = [CreateResearchProgramModel]()
    var list = false
    var pageCount = 0
    var totalPageCount = 0
    var cameFrom = String()
    func getResearchList(_ completion:@escaping() -> Void){
        var urlStr = ""
        if cameFrom == "Shared Survey"{
            urlStr = "\(Apis.KSharedResearchList)?page=\(pageCount))"
        }else{
             urlStr = "\(Apis.KResearchProgList)?pageCount=\(pageCount))"
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

extension CreateResearchProgramVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objCreateResPrVM.arrCreateRPModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dictDat = objCreateResPrVM.arrCreateRPModel[indexPath.row]
        let cell = tblVwResearchList.dequeueReusableCell(withIdentifier: "ResearchTVC") as! ResearchTVC
       
        cell.lblProduct.text = "Product: \(dictDat.productName!)"
        
        if self.title == "Shared Survey"{
             cell.lblCompany.text = "Share By: \(dictDat.shareBy!)"
        }else{
             cell.lblCompany.text = "Company: \(dictDat.companyName!)"
        }
        let startDate = Proxy.shared.getDateFrmString(getDate:dictDat.reserachStartDate!, format: "yyyy-MM-dd")
        cell.btnStartDate.setTitle("Start Date: \(Proxy.shared.getStringFrmDate(getDate: startDate, format: "dd,MMM yyyy"))", for: .normal)
        let endDate = Proxy.shared.getDateFrmString(getDate:dictDat.reserachEndDate!, format: "yyyy-MM-dd")
        cell.btnEndDate.setTitle("End Date: \(Proxy.shared.getStringFrmDate(getDate: endDate, format: "dd,MMM yyyy"))", for: .normal)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //PRogram DETSAIL
         let objVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchProgramVC") as! SearchProgramVC
        if self.title == "Shared Survey"{
            objVC.searchProgVMObj.cameFrom = "Shared Survey"
            objVC.searchProgVMObj.researchId = objCreateResPrVM.arrCreateRPModel[indexPath.row].researchId!
        }else{
            objVC.searchProgVMObj.researchId = objCreateResPrVM.arrCreateRPModel[indexPath.row].id!
        }
        
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == objCreateResPrVM.arrCreateRPModel.count-1{
            if objCreateResPrVM.pageCount+1 < objCreateResPrVM.totalPageCount{
                objCreateResPrVM.pageCount += 1
                objCreateResPrVM.getResearchList {
                    self.tblVwResearchList.reloadData()
                }
            }
        }
    }
}
