
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

class NotificationVM {
    
    var arrNotificationModel = [NotificationModel]()
    
    func getUserNotification(_ completion:@escaping() -> Void){
        WebServiceProxy.shared.getData("\(Apis.KNotification)\(Proxy.shared.authNil())", showIndicator: true) { (response) in
            if response.success{
                if let responsedict =  response.data {
                    if let resArrr = responsedict["notifications"] as? NSArray {
                        for i in 0..<resArrr.count{
                            if let dictData = resArrr[i] as? NSDictionary{
                                let objVM = NotificationModel()
                                objVM.getNotification(dictData)
                                self.arrNotificationModel.append(objVM)
                            }
                        }
                    }
                }
              
            }else{
                    Proxy.shared.displayStatusCodeAlert(response.message!)
            }
              completion()
        }
        
    }
}
extension NotificationVC: UITableViewDelegate,UITableViewDataSource {
    //MARK:-->TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationVMObj.arrNotificationModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVw.dequeueReusableCell(withIdentifier: "NotificationTVC", for: indexPath) as! NotificationTVC
        let modelDict = notificationVMObj.arrNotificationModel[indexPath.row]
        cell.lblTitle.text = modelDict.title
        cell.lblDescription.text = modelDict.description
        cell.btnTIme.setTitle(modelDict.time, for: .normal)
        cell.btnDate.setTitle(modelDict.date, for: .normal)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modelDict = notificationVMObj.arrNotificationModel[indexPath.row]
        if KAppDelegate.loginTypeVal == UserRole.User.rawValue {
            if modelDict.action == "reminder" && modelDict.controller == "timer" || modelDict.action == "miss-survey" && modelDict.controller == "timer" {
                Proxy.shared.pushToNextVC(identifier: "UserHomeVC", isAnimate: true, currentViewController: self)
            }
         } else {
            if modelDict.action == "save-answer" && modelDict.controller == "research-program" {
            let survayAnsVC = mainStoryboard.instantiateViewController(withIdentifier: "SubmittedSurveyAnsVC") as! SubmittedSurveyAnsVC
            let resID = modelDict.modelId
            survayAnsVC.objSubSurveyAnsVM.researchId =  resID!
            self.navigationController?.pushViewController(survayAnsVC, animated: true)
            } else if modelDict.action == "share-program" && modelDict.controller == "research-program" {
                let newVC = mainStoryboard.instantiateViewController(withIdentifier: "CreateResearchProgramVC") as! CreateResearchProgramVC
                newVC.title = "Shared Survey"
               self.navigationController?.pushViewController(newVC, animated: true)
             } else if modelDict.action == "template" && modelDict.controller == "save-as-template" {
                Proxy.shared.pushToNextVC(identifier: "TemplatesListVC", isAnimate: true, currentViewController: self)
            } else {
                Proxy.shared.pushToNextVC(identifier: "CreateResearchProgramVC", isAnimate: true, currentViewController: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
