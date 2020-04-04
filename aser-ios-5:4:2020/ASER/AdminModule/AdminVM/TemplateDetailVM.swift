
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

class TemplateDetailVM: NSObject {
    var tempId = Int()
    var tempTitle = String()
    var objResearchDetailModel = ResearchDetailModel()
    
    func getTemplateData(_ completion:@escaping() -> Void ){
        WebServiceProxy.shared.getData("\(Apis.KGetTemplateData)\(tempId)", showIndicator: true) { (ApiResponse) in
            if ApiResponse.success{
                self.objResearchDetailModel.arrSurveyQuestModel = []
                if let jsonDict = ApiResponse.data {
                    if let researchDict = jsonDict["detail"] as? NSDictionary {
                        self.objResearchDetailModel.getResearchDetail(dictDat: researchDict)
                    }
                }
                completion()
            }else{
                Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
            }
        }
    }
}
extension TemplateDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return templateDetailObj.objResearchDetailModel.arrSurveyQuestModel.count
      }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dictData = templateDetailObj.objResearchDetailModel.arrSurveyQuestModel[section]
            switch dictData.typeId{
            case Options.NO_OPTION.rawValue, Options.TYPE_ANS.rawValue:
                return 0
            case Options.MULTIPLE.rawValue, Options.CHOOSE_ONE.rawValue:
                return templateDetailObj.objResearchDetailModel.arrSurveyQuestModel[section].arrOptionModel.count
            default:
                return templateDetailObj.objResearchDetailModel.arrSurveyQuestModel.count
            }
      }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let dictData = templateDetailObj.objResearchDetailModel.arrSurveyQuestModel[indexPath.section]
            let cellOptions = tableView.dequeueReusableCell(withIdentifier: "OptionsTVC") as! OptionsTVC
            if dictData.arrOptionModel.count>0{
                if dictData.arrOptionModel[indexPath.row].isAnswer! ==  BoolVal.TRUE.rawValue {
                    if dictData.typeId == Options.MULTIPLE.rawValue{
                        cellOptions.btnCheckBox.setImage(UIImage(named: "ic_chk"), for: .normal)
                    }else{
                        cellOptions.btnCheckBox.setImage(UIImage(named: "ic_radio_selected"), for: .normal)
                    }
                }
                else{
                    if dictData.typeId == Options.MULTIPLE.rawValue{
                        cellOptions.btnCheckBox.setImage(UIImage(named: "ic_unchk"), for: .normal)
                    }else{
                        cellOptions.btnCheckBox.setImage(UIImage(named: "ic_radio_unselected"), for: .normal)
                    }
                }
                let modelDict = dictData.arrOptionModel[indexPath.row]
                cellOptions.lblOption.text = modelDict.option!
            }
            return cellOptions
     }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "ResearchQuestAnsTVC") as! ResearchQuestAnsTVC
        if  templateDetailObj.objResearchDetailModel.arrSurveyQuestModel.count>0{
            let modelDict = templateDetailObj.objResearchDetailModel.arrSurveyQuestModel[section]
            headerView.lblQuestionTitle.text = modelDict.question!
            headerView.lblSubmissionTimeline.text = modelDict.submissionTimeLine!
            headerView.lblPictureSubmission.text = modelDict.pictureSubVal!
            var answerType = ""
            switch modelDict.typeId!{
            case Options.NO_OPTION.rawValue: answerType = "No question"
            case Options.MULTIPLE.rawValue: answerType = "Multiple Choice"
            case Options.CHOOSE_ONE.rawValue: answerType = "Choose One"
            case Options.TYPE_ANS.rawValue: answerType = "Write Answer"
            default:break
            }
            headerView.lblAnswerType .text = answerType
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tblTemplate.dequeueReusableCell(withIdentifier: "FooterViewTVC") as! FooterViewTVC
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300.0
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return  300.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 41
    }
    
    
}
