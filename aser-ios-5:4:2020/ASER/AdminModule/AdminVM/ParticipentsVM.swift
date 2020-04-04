
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
import Alamofire
class ParticipentsVM  {
    var arrParticipantModel = [ParticipantModel]()
    var pageCount = 0
    var totalPageCount = 0
    var researchId = Int()
    func getPaticipantsList(_ completion:@escaping() -> Void ){
        WebServiceProxy.shared.getData("\(Apis.KParticipantsList)\(researchId)?pageCount=\(pageCount)", showIndicator: true) { (response) in
            if response.success{
                if let dictResponse = response.data {
                    if let dictMeta = dictResponse["_meta"] as? NSDictionary{
                        if let totalPages = dictMeta["pageCount"] as? Int {
                            self.totalPageCount = totalPages
                        }
                    }
                    if self.pageCount == 0 {
                        self.arrParticipantModel = []
                    }
                    if let arrResponse = dictResponse["list"]  as? NSArray{
                        for index in 0..<arrResponse.count{
                            if let dictData = arrResponse[index] as? NSDictionary{
                                var objM = ParticipantModel()
                                objM.getParticipantsData(dictData: dictData)
                                self.arrParticipantModel.append(objM)
                            }
                        }
                    }
                    completion()
                }
            }else{
                 if self.pageCount == 0 {
                    Proxy.shared.displayStatusCodeAlert(response.message!)
                }
            }
        }
    }
   
    func deleteParticipant(id:Int, _ completion:@escaping() -> Void){
        let param = [
            "research_id":"\(researchId)",
            "id":"\(id)"
        ] as [String:AnyObject]
        let dictF = NSMutableDictionary()
        dictF.setValue(param, forKey: "ResearchProgram")
        WebServiceProxy.shared.postData(Apis.KDeleteParticipant, params: dictF as? Dictionary<String, AnyObject>, showIndicator: true) { (ApiResponse) in
            if ApiResponse.success{
                completion()
            }else{
                Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
            }
        }
    }
}

extension ParticipantsListVC : UITableViewDataSource, UITableViewDelegate {
    //MARK:--> TABLE VIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participantsListVMObj.arrParticipantModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVw.dequeueReusableCell(withIdentifier: "ParticipentsLIstTVC", for: indexPath) as! ParticipentsLIstTVC
        let dictVal = participantsListVMObj.arrParticipantModel[indexPath.row]
        cell.lblUsrName.text = dictVal.fullName!
        cell.imgVw.sd_setImage(with: URL.init(string: dictVal.profileImg!), placeholderImage:UIImage(named: "ic_profile-1"), completed: nil)
        cell.VwFLoatingRating.rating = dictVal.rating!
        cell.btnDelRef.tag = indexPath.row
        cell.btnEditRef.tag = dictVal.id!
        cell.btnNotificationRef.tag = dictVal.id!
        cell.btnNotificationRef.addTarget(self, action: #selector(notificationMethods(_:)), for: .touchUpInside)
        cell.btnDelRef.addTarget(self, action: #selector(deleteMethods(_:)), for: .touchUpInside)
        cell.btnEditRef.addTarget(self, action: #selector(editMethod(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == participantsListVMObj.arrParticipantModel.count-1{
            if participantsListVMObj.pageCount+1 < participantsListVMObj.totalPageCount{
                participantsListVMObj.pageCount += 1
                participantsListVMObj.getPaticipantsList{
                     self.tblVw.reloadData()
                }
            }
        }
    }
   
    
    @objc func deleteMethods(_ sender:UIButton){
        let id = participantsListVMObj.arrParticipantModel[sender.tag].id!
        Proxy.shared.alertControl(title: TitleValue.REMOVEPARTICIPANTS, message: AlertMsgs.KREMOVEPARTICIPANTS) { (alert, boolVal) in
            if boolVal == "true"{
                print("Success")
                //REMOVE PARTICIPANTS APIS
                self.participantsListVMObj.deleteParticipant(id: id, {
                    self.participantsListVMObj.arrParticipantModel.remove(at: sender.tag)
                    
                    if self.participantsListVMObj.arrParticipantModel.count<1{
                        self.tblVw.isHidden = true
                    }else{
                        self.tblVw.reloadData()
                    }
                })
            } else if boolVal == "false"{
                //HANDLE NO ACTIONS
            } else{
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func editMethod(_ sender:UIButton){
        //UPDATE PROFILE SCREEN IS IN USER STORYBOARD
        let stryBrd = UIStoryboard(name:("User"), bundle: nil)
        let objVC = stryBrd.instantiateViewController(withIdentifier: "UserProfileUpdateVC") as! UserProfileUpdateVC
        objVC.title = "ParticipantVC"
        objVC.profileUpdateVmObj.participantId = sender.tag
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @objc func notificationMethods(_ sender:UIButton){
        
         let reserchIdNew = UserDefaults.standard.string(forKey: "reserchIdNew")
        print(reserchIdNew)
        
        let userId = sender.tag
        print(userId)
        
        let url = "https://asernv.org/api/research-program/notification" // This will be your link
        print(url)
        let param: [String: Any] = [
            
            "research_id": reserchIdNew!,
            "user_id": userId
        ]
        
        Alamofire.request("https://asernv.org/api/research-program/notification", method: .post, parameters: param,headers:
            ["Authorization": "Bearer \(Proxy.shared.authNil())","User-Agent":"\(AppInfo.UserAgent)"]).responseJSON { response in
            
            switch response.result{
                
            case .success:
                Proxy.shared.hideActivityIndicator()
                let dict = response.value as! NSDictionary
                print(dict)
                
              
                
                
            case .failure(let error):
                Proxy.shared.hideActivityIndicator()
                print(error.localizedDescription)
                
            }
        }
        //UPDATE PROFILE SCREEN IS IN USER STORYBOARD
//        let stryBrd = UIStoryboard(name:("User"), bundle: nil)
//        let objVC = stryBrd.instantiateViewController(withIdentifier: "UserProfileUpdateVC") as! UserProfileUpdateVC
//        objVC.title = "ParticipantVC"
//        objVC.profileUpdateVmObj.participantId = sender.tag
//        self.navigationController?.pushViewController(objVC, animated: true)
    }
}
