
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
class SearchProgramVwModel: NSObject {
    var createQuesArr = ["Are you above 18?", "Your gender" , "Your country" , "Your Ethnicity(optional)"]
    var researchId = Int()
    var cameFrom = String()
    var objResearchDetailModel = ResearchDetailModel()
    
    func getReserachData(_ completion:@escaping() -> Void ){
        WebServiceProxy.shared.getData("\(Apis.KResearchProgramDetail)\(researchId)", showIndicator: true) { (ApiResponse) in
            if ApiResponse.success{
                self.objResearchDetailModel.arrSurveyQuestModel = []
                if let jsonDict = ApiResponse.data {
                    if let researchDict = jsonDict["research"] as? NSDictionary {
                        print(researchDict)
                        self.objResearchDetailModel.getResearchDetail(dictDat: researchDict)
                    }
                }
                completion()
            }else{
                Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
            }
        }
    }
    
    func deleteSurvey(_ id:Int, completion:@escaping() -> Void){        
        let urlStr:String = (cameFrom == "Shared Survey") ? Apis.KRemoveFromSharedSurvey : Apis.KDeleteResearch
        WebServiceProxy.shared.getData("\(urlStr)\(id)", showIndicator: true) { (ApiResponse) in
            if ApiResponse.success{
                completion()
            }else{
                Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
            }
        }
    }
}

extension SearchProgramVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if  (tableView == tblQuestions) {
            return 1
        } else {
            return searchProgVMObj.objResearchDetailModel.arrSurveyQuestModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (tableView == tblQuestions) {
            return searchProgVMObj.createQuesArr.count
        }
        else {
            let dictData = searchProgVMObj.objResearchDetailModel.arrSurveyQuestModel[section]
            switch dictData.typeId{
                case Options.NO_OPTION.rawValue, Options.TYPE_ANS.rawValue:
                    return 0
                case Options.MULTIPLE.rawValue, Options.CHOOSE_ONE.rawValue:
                    return searchProgVMObj.objResearchDetailModel.arrSurveyQuestModel[section].arrOptionModel.count
                default:
                    return searchProgVMObj.objResearchDetailModel.arrSurveyQuestModel.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblQuestions {
            let cell = tblQuestions.dequeueReusableCell(withIdentifier: "SearchProgramTVC") as! SearchProgramTVC
            cell.lblQuestionTitle.text = "\(indexPath.row+1) \(searchProgVMObj.createQuesArr[indexPath.row])"
            return cell
        } else {
            let dictData = searchProgVMObj.objResearchDetailModel.arrSurveyQuestModel[indexPath.section]
            let cellOptions = tblViewAddQuestion.dequeueReusableCell(withIdentifier: "OptionsTVC") as! OptionsTVC
            let reserchIdNew = dictData.researchId
            print(reserchIdNew!)
            UserDefaults.standard.set(reserchIdNew, forKey: "reserchIdNew")
           
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
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tblViewAddQuestion.dequeueReusableCell(withIdentifier: "ResearchQuestAnsTVC") as! ResearchQuestAnsTVC
        if  searchProgVMObj.objResearchDetailModel.arrSurveyQuestModel.count>0{
            let modelDict = searchProgVMObj.objResearchDetailModel.arrSurveyQuestModel[section]
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
        let footerView = tblViewAddQuestion.dequeueReusableCell(withIdentifier: "FooterViewTVC") as! FooterViewTVC
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView == tblQuestions) ? 50.0 :  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView == tblQuestions) ? 50.0 : 68.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (tableView == tblQuestions) ? 0.0 : UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return (tableView == tblQuestions) ? 0.0 : 300.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  (tableView == tblQuestions) ? 0.0 : UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return  (tableView == tblQuestions) ? 0.0 : 41
    }
}
