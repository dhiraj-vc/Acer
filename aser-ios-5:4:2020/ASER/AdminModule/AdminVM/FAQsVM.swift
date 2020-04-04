
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
class FAQsVM : NSObject {
    var arrFAQModel = [FAQSModel]()
    var selectedSection = 0
    var pageCount = 0
    var totalPageCount = 0
    
    func getFaqList(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KFAQ)?pageCount=\(pageCount)", showIndicator: true) { (ApiResponse) in
            if ApiResponse.success{
                if let responsedict =  ApiResponse.data {
                    
                    if let dictMeta = responsedict["_meta"] as? NSDictionary{
                        if let totalPages = dictMeta["pageCount"] as? Int {
                            self.totalPageCount = totalPages
                        }
                    }
                    if self.pageCount == 0 {
                         self.arrFAQModel = []
                    }
                    if let resArrr = responsedict["faqs"] as? NSArray {
                        for i in 0..<resArrr.count{
                            if let dictData = resArrr[i] as? NSDictionary{
                                let objVM = FAQSModel()
                                objVM.getFaqList(dictData:dictData)
                                self.arrFAQModel.append(objVM)
                            }
                        }
                    }
                }
                completion()
            }else{
                if self.pageCount == 0{
                    Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
                }
            }
        }
    }
}

extension FAQsVC: UITableViewDataSource,UITableViewDelegate{
    //MARK:-->TABLE VIEW DELEGATE
    func numberOfSections(in tableView: UITableView) -> Int {
        return  objFAQsVM.arrFAQModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return objFAQsVM.selectedSection == section ? 1 : 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVw.dequeueReusableCell(withIdentifier: "FAQCellVw", for: indexPath) as! FAQCellVw
        cell.selectionStyle = .none
        if objFAQsVM.selectedSection == indexPath.section{
            cell.lblAnswer.text! = objFAQsVM.arrFAQModel[indexPath.section].answer!
        }
        return cell
    }
    //MARK :- TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        // custom view for header. will be adjusted to default or specified header height
        let headerView = tblVw.dequeueReusableHeaderFooterView(withIdentifier: "FAQHeaderVw") as! FAQHeaderVw
         headerView.lblQuestion.text = objFAQsVM.arrFAQModel[section].question!
        if objFAQsVM.selectedSection == section {
               headerView.btnMoveToNext.setImage(UIImage(named: "ic_upward") , for: .normal)
            }else{
               headerView.btnMoveToNext.setImage(UIImage(named: "ic_dropdown") , for: .normal)
        }
        headerView.btnMoveToNext.tag = section
        headerView.btnMoveToNext.addTarget(self, action: #selector(moveTonextVC(_:)), for: .touchUpInside)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == objFAQsVM.arrFAQModel.count-1{
            if objFAQsVM.pageCount+1 < objFAQsVM.totalPageCount{
                objFAQsVM.pageCount += 1
                objFAQsVM.getFaqList {
                        self.tblVw.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    @objc func moveTonextVC( _ sender : UIButton ){
        objFAQsVM.selectedSection = (objFAQsVM.selectedSection == sender.tag) ? -1 : sender.tag
        self.tblVw.reloadData()
    }
}
