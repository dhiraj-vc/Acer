
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

import Foundation
import UIKit
class ListOfPatientsVM {
    var arrPatients = [PatientModel]()
    
    func getListOfPatients(_ completion:@escaping() -> Void)
    {
        WebServiceProxy.shared.getData("\(Apis.KPatientList)", showIndicator: true) { (response) in
            if response.success{
                if let responsedict =  response.data {
                    if let resArrr = responsedict["list"] as? NSArray {
                        for i in 0..<resArrr.count{
                            if let dictData = resArrr[i] as? NSDictionary{
                                let objVM = PatientModel()
                                objVM.getPatientDet(dictData)
                                self.arrPatients.append(objVM)
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
extension ListOfPatientsVC: UITableViewDelegate,UITableViewDataSource{
    
    // MARK: Table delegates and data sources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objListOfPatientsVM.arrPatients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListOfPatientsTVC", for: indexPath) as! ListOfPatientsTVC
        let dictPatientDet = objListOfPatientsVM.arrPatients[indexPath.row]
        cell.lblPatientsName.text = dictPatientDet.fullname
        cell.btnMsgChat.tag = dictPatientDet.patientID!
        cell.btnMsgChat.addTarget(self, action: #selector(gotoChat(sender:)), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(gotoDelete(sender:)), for: .touchUpInside)

        cell.imgVwPatients.sd_setImage(with: URL(string: dictPatientDet.profileImage!), placeholderImage: UIImage(named: "ic_profile-1"))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictPatientDet = objListOfPatientsVM.arrPatients[indexPath.row]
        let patientDet = mainStoryboard.instantiateViewController(withIdentifier: "PatientDetialVC") as! PatientDetialVC
        patientDet.objPatientDetVM.patientID = dictPatientDet.patientID!
        self.navigationController?.pushViewController(patientDet, animated: true)
    }
    // MARK: Table button actions
    @objc func gotoChat(sender:UIButton){
        let chatVC = mainStoryboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.objChatVM.messageToId = sender.tag
        KAppDelegate.currentViewCont = chatVC
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    @objc func gotoDelete(sender:UIButton){
        let dictPatientDet = objListOfPatientsVM.arrPatients[sender.tag]

        let patientId = dictPatientDet.patientID
        
        let alert = UIAlertController(title: nil, message: "Do you really want to delete doctor?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in

        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            WebServiceProxy.shared.getData("\(Apis.KPatientDelete)?patient_id=\(String(describing: patientId!))&access-token=\(Proxy.shared.authNil())"
            , showIndicator: true) { (response) in
                if response.success{
                    if let responsedict =  response.data
                    {
                            self.objListOfPatientsVM.arrPatients.remove(at: sender.tag)
                        
                        if self.objListOfPatientsVM.arrPatients.count == 0
                            {
                                self.tblVwListOfPatients.isHidden = true

                            }else{
                                self.tblVwListOfPatients.isHidden = false
                                
                                self.tblVwListOfPatients.reloadData()
                            }
                    }
                }else{
                    Proxy.shared.displayStatusCodeAlert(response.message!)
                }
            }
        }))

        self.present(alert, animated: true, completion: nil)
     
        
    }
}
