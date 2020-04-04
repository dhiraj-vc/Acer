
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

class SubmittedSurveyAnsVM: NSObject {
    var arrSubmittedSurveyAnsModel = [SubmittedSurveyAnsModel]()
    var totalPageCount = 0
    var pageCount = 0
    var researchId = Int()
 
//    let dictData: Array<Any> = []
    
    func getSubmittedSurveyData(_ completion:@escaping() -> Void){
        
        
        WebServiceProxy.shared.getData("\(Apis.KSurveyReview)\(researchId)", showIndicator: true) { (response) in
            if response.success{
                if let dictResponse = response.data {
                   
                    if let arrResponse = dictResponse["questions"]  as? NSArray{
                        self.arrSubmittedSurveyAnsModel = []
                        for index in 0..<arrResponse.count{
                            if let dictData = arrResponse[index] as? NSDictionary{
                                var objM = SubmittedSurveyAnsModel()
                                objM.getSubmittedSurveyList(dictData: dictData)
                                self.arrSubmittedSurveyAnsModel.append(objM)
                            }
                        }
                    }
                    completion()
                }
            }else{
                    Proxy.shared.displayStatusCodeAlert(response.message!)
            }
        }
    }
}



extension SubmittedSurveyAnsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
            return  objSubSurveyAnsVM.arrSubmittedSurveyAnsModel.count

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objSubSurveyAnsVM.arrSubmittedSurveyAnsModel[section].arrAnswerModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let dictData = objSubSurveyAnsVM.arrSubmittedSurveyAnsModel[indexPath.section].arrAnswerModel[indexPath.row]
    let cellOptions = tblVwSubmittedSurvey.dequeueReusableCell(withIdentifier: "SubmittedAnsRowTVC") as! SubmittedAnsRowTVC

        cellOptions.lblUserName.text = dictData.userName!
        
        if dictData.submittedImg != ""{
            cellOptions.imgOptionSubmitted.isHidden = false
           
            cellOptions.imgOptionSubmitted.sd_setImage(with: URL.init(string: dictData.submittedImg!), placeholderImage:UIImage(named: "ic_profile-1"), completed: nil)
            imageString = dictData.submittedImg!
            cellOptions.downloadBtn.tag = (indexPath.section*100)+indexPath.row
            cellOptions.downloadBtn.addTarget(self, action: #selector(downLoadAction(_:)), for: .touchUpInside )
            
        }else{
            cellOptions.imgOptionSubmitted.isHidden = true
        }
        if dictData.writtenAns! != ""{
             cellOptions.lblAnswerSubmitted.text = dictData.writtenAns!
        }else if dictData.optionString != ""{
            cellOptions.lblAnswerSubmitted.text = dictData.optionString!
        }else{
            cellOptions.lblAnswerSubmitted.text = "Not set"

        }
        return cellOptions
    }
    
    @objc func downLoadAction(_ sender : UIButton){
        print("hello \(sender.tag)")
        let section = sender.tag / 100
        let row = sender.tag % 100
        let indexPath = IndexPath(row: row, section: section)

        print(section as Any)
        print(row as Any)
        let  dictData = objSubSurveyAnsVM.arrSubmittedSurveyAnsModel[indexPath.section].arrAnswerModel[indexPath.row]
        print(dictData.optionString as Any)
        let imagestring = dictData.submittedImg!
        if let url = URL(string: imagestring),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
    

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerDict = objSubSurveyAnsVM.arrSubmittedSurveyAnsModel[section]
        let headerView = tblVwSubmittedSurvey.dequeueReusableCell(withIdentifier: "SubmittedAnsHeaderTVC") as! SubmittedAnsHeaderTVC
        headerView.lblQuestion.text = "\(headerDict.question!)"
        
        return headerView
    }
    
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == objSubSurveyAnsVM.arrSubmittedSurveyAnsModel.count-1{
//            if objSubSurveyAnsVM.pageCount+1 < objSubSurveyAnsVM.totalPageCount{
//                objSubSurveyAnsVM.pageCount += 1
//                objSubSurveyAnsVM.getSubmittedSurveyData {
//                    self.tblVwSubmittedSurvey.reloadData()
//                }
//            }
//        }
//    }
    
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tblVwSubmittedSurvey.dequeueReusableCell(withIdentifier: "FooterViewTVC") as! FooterViewTVC
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return  200.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return  41
    }
}
