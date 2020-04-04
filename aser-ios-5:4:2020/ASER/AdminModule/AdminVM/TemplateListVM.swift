
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

class TemplateListVM: NSObject {
    var arrTemplates = [NotificationModel]()
    func getTemplateList(_ completion:@escaping() -> Void){
        WebServiceProxy.shared.getData("\(Apis.KTemplateList)", showIndicator: true) { (response) in
            if response.success{
                if let responsedict =  response.data {
                    if let resArrr = responsedict["list"] as? NSArray {
                        for i in 0..<resArrr.count{
                            if let dictData = resArrr[i] as? NSDictionary{
                                let objVM = NotificationModel()
                                objVM.getNotification(dictData)
                                self.arrTemplates.append(objVM)
                            }
                        }
                    }
                }
            completion()
            }else{
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
         }
    }
}
extension TemplatesListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templateListVMObj.arrTemplates.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVC") as! NotificationTVC
        let dictTemp = templateListVMObj.arrTemplates[indexPath.row]
        cell.lblTitle.text = dictTemp.title
        cell.lblDescription.text = dictTemp.description
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detVC = mainStoryboard.instantiateViewController(withIdentifier: "TemplateDetailVC") as! TemplateDetailVC
        let dictTemp = templateListVMObj.arrTemplates[indexPath.row]
        detVC.templateDetailObj.tempId = dictTemp.id!
        detVC.templateDetailObj.tempTitle =  dictTemp.title!
        self.navigationController?.pushViewController(detVC, animated: true)
    
    }
 }
