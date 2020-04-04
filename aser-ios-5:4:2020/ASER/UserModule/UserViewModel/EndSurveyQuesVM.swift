
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

class EndSurveyQuesVM: NSObject {
   var arrEndQuestions = [SurveyQuestModel]()
    //MARK: API METHODS
    func getSureveyAnswer(_ completion:@escaping() -> Void){
         WebServiceProxy.shared.getData(Apis.KEndSurveyQuestions, showIndicator: true) { (response) in
            if response.success{
                 if let arrResponse = response.data!["list"]  as? NSArray{
                        for index in 0..<arrResponse.count{
                            if let dictData = arrResponse[index] as? NSDictionary{
                                let objM = SurveyQuestModel()
                                objM.getQuestionList(dictData: dictData)
                                self.arrEndQuestions.append(objM)
                            }
                        }
                    }
                completion()
            }  else {
                Proxy.shared.displayStatusCodeAlert(response.message!)
             }
        }
    }
    func submitAnswer(_ param:[String:AnyObject], completion:@escaping() -> Void){
        WebServiceProxy.shared.postData(Apis.KSubmitEndSurvey, params: param, showIndicator: true) {  (response) in
            if response.success{
               completion()
            }  else {
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
        }
    }
}
extension EndSurveyQuestionVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endSurveyObj.arrEndQuestions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyQuestionTVC") as! SurveyQuestionTVC
        let dictQues = endSurveyObj.arrEndQuestions[indexPath.row]
        cell.lblQuestions.text = dictQues.question
        cell.txtViewAnswers.tag = indexPath.row
        return cell
    }
}
