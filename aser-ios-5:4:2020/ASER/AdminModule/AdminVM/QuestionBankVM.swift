
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

class QuestionBankVM: NSObject {
    var arrQuestions = [SurveyQuestModel]()
    func getQuestionModel(_ completion:@escaping() -> Void ){
        WebServiceProxy.shared.getData("\(Apis.KQuestionBankList)", showIndicator: true) { (ApiResponse) in
            if ApiResponse.success{
                self.arrQuestions = []
                if let jsonDict = ApiResponse.data {
                    if let arrQuest = jsonDict["list"] as? NSArray {
                        for i in 0..<arrQuest.count {
                            let objQuest = SurveyQuestModel()
                            if let quesDict = arrQuest[i] as? NSDictionary {
                                objQuest.getQuestionList(dictData: quesDict)
                                self.arrQuestions.append(objQuest)
                            }
                        }
                    }
                }
                completion()
            }else{
                Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
            }
        }
    }
}
extension QuestionBankVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objQuestionsVM.arrQuestions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dictData = objQuestionsVM.arrQuestions[section]
        switch dictData.typeId{
        case Options.NO_OPTION.rawValue, Options.TYPE_ANS.rawValue:
            return 0
        case Options.MULTIPLE.rawValue, Options.CHOOSE_ONE.rawValue:
            return objQuestionsVM.arrQuestions[section].arrOptionModel.count
        default:
            return objQuestionsVM.arrQuestions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dictData = objQuestionsVM.arrQuestions[indexPath.section]
        let cellOptions = tblViewQuestions.dequeueReusableCell(withIdentifier: "OptionsTVC") as! OptionsTVC
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
        let headerView = tblViewQuestions.dequeueReusableCell(withIdentifier: "ResearchQuestAnsTVC") as! ResearchQuestAnsTVC
        let modelDict = objQuestionsVM.arrQuestions[section]
            headerView.lblQuestionTitle.text = modelDict.question!
        headerView.btnSelectQues.tag = section
        headerView.btnSelectQues.addTarget(self, action: #selector(selectedQues(sender:)), for: .touchUpInside)
        return headerView
    }
    
    @objc func selectedQues(sender:UIButton){
        let indexVal = sender.tag
        let modelDict = objQuestionsVM.arrQuestions[indexVal]
        selectQuest.questionToAdd(modelDict)
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modelDict = objQuestionsVM.arrQuestions[indexPath.section]
        selectQuest.questionToAdd(modelDict)
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tblViewQuestions.dequeueReusableCell(withIdentifier: "FooterViewTVC") as! FooterViewTVC
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 41
    }
}
