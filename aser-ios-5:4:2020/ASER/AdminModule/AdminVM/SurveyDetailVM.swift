
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
class SurveyDetailsVM {
    var createQuesArr = ["Are you above 18?", "Your gender" , "Your country" , "Your Ethnicity(optional)"]
    
}
extension SurveyDetailsVC:UITableViewDataSource,UITableViewDelegate {
    // MARK : TABLEVIEW
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveyDetailsVMObj.createQuesArr.count+1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == surveyDetailsVMObj.createQuesArr.count{
            return 280
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       var cell = UITableViewCell()
        if indexPath.row != surveyDetailsVMObj.createQuesArr.count {
            let returnCell = tblVwSurvey.dequeueReusableCell(withIdentifier: "ShowDetailTVC") as! ShowDetailTVC
            returnCell.lblQuesTitle.text = surveyDetailsVMObj.createQuesArr[indexPath.row]
            cell = returnCell
            
            
            
        }else{
            let returnCell = tblVwSurvey.dequeueReusableCell(withIdentifier: "SurveyQuestionTVC") as! SurveyQuestionTVC
            cell = returnCell
            
            
            
            
        }
        return cell
    }
    
}
