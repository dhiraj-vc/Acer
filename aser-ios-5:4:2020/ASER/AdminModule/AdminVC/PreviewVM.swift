//
//  PreviewVM.swift
//  ASER
//
//  Created by Ankit Kumar on 23/11/19.
//  Copyright © 2019 Priti Sharma. All rights reserved.
//

import Foundation
import UIKit

class PreviewVM: NSObject {
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

//extension PreviewVC : UITableViewDelegate, UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
////        if  (tableView == tblQuestions) {
////            return 1
////        } else {
////            return previewVMObj.objResearchDetailModel.arrSurveyQuestModel.count
////        }
//        return 1//previewVMObj.objResearchDetailModel.arrSurveyQuestModel.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        if  (tableView == tblQuestions) {
////            return previewVMObj.createQuesArr.count
////        }
////        else {
////            let dictData = previewVMObj.objResearchDetailModel.arrSurveyQuestModel[section]
////            switch dictData.typeId{
////                case Options.NO_OPTION.rawValue, Options.TYPE_ANS.rawValue:
////                    return 0
////                case Options.MULTIPLE.rawValue, Options.CHOOSE_ONE.rawValue:
////                    return previewVMObj.objResearchDetailModel.arrSurveyQuestModel[section].arrOptionModel.count
////                default:
////                    return previewVMObj.objResearchDetailModel.arrSurveyQuestModel.count
////            }
////        }
////        let dictData = previewVMObj.objResearchDetailModel.arrSurveyQuestModel[section]
////                  switch dictData.typeId{
////                      case Options.NO_OPTION.rawValue, Options.TYPE_ANS.rawValue:
////                          return 0
////                      case Options.MULTIPLE.rawValue, Options.CHOOSE_ONE.rawValue:
////                          return previewVMObj.objResearchDetailModel.arrSurveyQuestModel[section].arrOptionModel.count
////                      default:
////                          return previewVMObj.objResearchDetailModel.arrSurveyQuestModel.count
////                  }
//        return 4
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        if tableView == tblQuestions {
////            let cell = tblQuestions.dequeueReusableCell(withIdentifier: "SearchProgramTVC") as! SearchProgramTVC
////            cell.lblQuestionTitle.text = "\(indexPath.row+1) \(previewVMObj.createQuesArr[indexPath.row])"
////            return cell
////        } else {
//            let dictData = previewVMObj.objResearchDetailModel.arrSurveyQuestModel[indexPath.section]
//            let cellOptions = tblViewAddQuestion.dequeueReusableCell(withIdentifier: "OptionsTVC") as! OptionsTVC
////            if dictData.arrOptionModel.count>0{
////                if dictData.arrOptionModel[indexPath.row].isAnswer! ==  BoolVal.TRUE.rawValue {
////                    if dictData.typeId == Options.MULTIPLE.rawValue{
////                        cellOptions.btnCheckBox.setImage(UIImage(named: "ic_chk"), for: .normal)
////                    }else{
////                        cellOptions.btnCheckBox.setImage(UIImage(named: "ic_radio_selected"), for: .normal)
////                    }
////                }
////                else{
////                    if dictData.typeId == Options.MULTIPLE.rawValue{
////                        cellOptions.btnCheckBox.setImage(UIImage(named: "ic_unchk"), for: .normal)
////                    }else{
////                        cellOptions.btnCheckBox.setImage(UIImage(named: "ic_radio_unselected"), for: .normal)
////                    }
////                }
////                let modelDict = dictData.arrOptionModel[indexPath.row]
////                cellOptions.lblOption.text = modelDict.option!
////            }
//            return cellOptions
////        }
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = tblViewAddQuestion.dequeueReusableCell(withIdentifier: "ResearchQuestAnsTVC") as! ResearchQuestAnsTVC
//        if  previewVMObj.objResearchDetailModel.arrSurveyQuestModel.count>0{
//            let modelDict = previewVMObj.objResearchDetailModel.arrSurveyQuestModel[section]
//            headerView.lblQuestionTitle.text = modelDict.question!
//            headerView.lblSubmissionTimeline.text = modelDict.submissionTimeLine!
//            headerView.lblPictureSubmission.text = modelDict.pictureSubVal!
//            var answerType = ""
//            switch modelDict.typeId!{
//                case Options.NO_OPTION.rawValue: answerType = "No question"
//                case Options.MULTIPLE.rawValue: answerType = "Multiple Choice"
//                case Options.CHOOSE_ONE.rawValue: answerType = "Choose One"
//                case Options.TYPE_ANS.rawValue: answerType = "Write Answer"
//            default:break
//            }
//            headerView.lblAnswerType .text = answerType
//        }
//        return headerView
//    }
//    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = tblViewAddQuestion.dequeueReusableCell(withIdentifier: "FooterViewTVC") as! FooterViewTVC
//        return footerView
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return  UITableView.automaticDimension
//    }
//    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return  68.0
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return  UITableView.automaticDimension
//    }
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return  300.0
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return   UITableView.automaticDimension
//    }
//    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
//        return   41
//    }
//}
