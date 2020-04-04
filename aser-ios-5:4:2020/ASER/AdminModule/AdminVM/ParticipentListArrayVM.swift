
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

class ParticipentAddListVM {
    var arrParticipantModel = [ParticipantModel]()
    var researchId = Int()
    var totalPageCount = 0
    var pageCount = 0
    var cameFrom = String()
    var alertMessage = String()
    
    func getParticipantListToAdd(_ completion:@escaping() -> Void){
        let param = [ "research_id" : researchId] as [String:AnyObject]
        WebServiceProxy.shared.postData("\(Apis.KParticipantListWhileAdd)\(pageCount)", params: param, showIndicator: true) { (response) in
            if response.success{
                self.handleResponse(response, completion: {
                    completion()
                })
            }else{
                if self.pageCount == 0 {
                    Proxy.shared.displayStatusCodeAlert(response.message!)
                }
            }
        }
    }
    
    //MARK : SHARE PROGRAM APIS
    func getAdminListForShareResearch(_ completion:@escaping() -> Void){
        let param = [ "research_id": researchId ] as [String:AnyObject]        
        WebServiceProxy.shared.postData("\(Apis.KAdminListForShare)\(pageCount)", params: param, showIndicator: true) { (response) in
            if response.success{
                self.cameFrom = "ShareProgram"
                self.handleResponse(response, completion: {
                    completion()
                })
            }else{
                if self.pageCount == 0 {
                    Proxy.shared.displayStatusCodeAlert(response.message!)
                }
            }
        }
    }
    
    func addParticipantToResearch(_ urlStr:String, params: Dictionary<String, AnyObject>? = nil, completion:@escaping() -> Void) {
        WebServiceProxy.shared.postData(urlStr, params: params, showIndicator: true) { (response) in
            if response.success{
                completion()
            }
            Proxy.shared.displayStatusCodeAlert(response.message!) //MESSAGE IN BOTH CASE
        }
    }
    
    
    func deleteAdminFromSurvey(_ id:Int, completion:@escaping() -> Void){
        WebServiceProxy.shared.getData("\(Apis.KRemoveFromSharedSurvey)\(researchId)&id=\(id)", showIndicator: true) { (ApiResponse) in
            if ApiResponse.success{
                completion()
            }else{
                Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
            }
        }
    }
    
    func handleResponse(_ response:ApiResponse, completion:@escaping() -> Void){
        if let dictResponse = response.data{
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
                        let objM = ParticipantModel()
                        objM.getParticipantsData(dictData: dictData)
                        //APPEND MODEL TO THE SAME ARRAY TYPE
                        self.arrParticipantModel.append(objM)
                    }
                }
            }
            completion()
        }
    }
}

extension ParticipentAddListVC: UITableViewDelegate,UITableViewDataSource {
    
    //MARK:-->IBOUTLETS & VARIABLES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objPartcipantAddVM.arrParticipantModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVwPrt.dequeueReusableCell(withIdentifier: "ParticipentAryListTVC", for: indexPath) as! ParticipentAryListTVC
        if self.title == "ShareProgram"{
            cell.vwRating.isHidden = true
        }
       
        
        let dictVal = objPartcipantAddVM.arrParticipantModel[indexPath.row]
        cell.vwRating.rating = dictVal.rating!
        cell.lblUserName.text = dictVal.fullName!
        cell.imgVw.sd_setImage(with: URL.init(string: dictVal.profileImg!), placeholderImage:UIImage(named: "ic_profile-1"), completed: nil)
        if  objPartcipantAddVM.cameFrom == "ShareProgram"{
                cell.cnstWidthBtn.constant = dictVal.shared ? 80 : 65
                cell.btnAddRef.setTitle(( dictVal.shared ? "Remove" : "Share"), for: .normal)
        }else{
            cell.btnAddRef.setTitle("Add", for: .normal)
        }
        cell.btnAddRef.indexPath = indexPath.row
        cell.btnAddRef.section = indexPath.section //#selector
        cell.btnAddRef.tag = dictVal.id!
        cell.btnAddRef.addTarget(self, action: #selector(addMethods(_:)), for: .touchUpInside)
        return cell
    }
    // himanshu new
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == objPartcipantAddVM.arrParticipantModel.count-1{
            if objPartcipantAddVM.pageCount+1 < objPartcipantAddVM.totalPageCount{
                objPartcipantAddVM.pageCount += 1
                if objPartcipantAddVM.cameFrom == "ShareProgram"{
                     objPartcipantAddVM.getAdminListForShareResearch {
                         self.tblVwPrt.reloadData()
                    }
                }else{
                    objPartcipantAddVM.getParticipantListToAdd {
                        self.tblVwPrt.reloadData()
                    }
                }
            }
        }
    }

    @objc func addMethods(_ sender:ButtonSubClass){
        let indexpath = NSIndexPath.init(row: sender.indexPath!, section: sender.section!)
        let dictVal = objPartcipantAddVM.arrParticipantModel[indexpath.row]
        if dictVal.shared {
            Proxy.shared.alertControl(title: TitleValue.alert, message: AlertMsgs.DOYOUWANTOREMOVETHISADMINFROMSHAREDLIST) { (alert, boolVal) in
                if boolVal == "true"{
                    self.objPartcipantAddVM.deleteAdminFromSurvey(sender.tag, completion: {
                        self.objPartcipantAddVM.arrParticipantModel[sender.indexPath!].shared = false
                        self.tblVwPrt.reloadData()
                    })

                } else if boolVal == "false"{
                    //HANDLE NO ACTIONS
                } else{
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }else{
            Proxy.shared.alertControl(title: TitleValue.alert, message: objPartcipantAddVM.alertMessage) { (alert, boolVal) in
                if boolVal == "true"{
                    print("Success")
                    //REMOVE & SHARE APIS
                    var urlStr = ""
                    var param = NSMutableDictionary()
                    
                    if self.objPartcipantAddVM.cameFrom == "ShareProgram"{
                        urlStr = Apis.KShareSurveyToAdmin
                        param = [  "ShareSarvey[research_id]": self.objPartcipantAddVM.researchId,
                                   "ShareSarvey[share_with_id]": sender.tag ]
                    }else{
                        urlStr = Apis.KAddParticipantToResearch
                        param = [ "user_id" : sender.tag,
                                  "research_id" : self.objPartcipantAddVM.researchId ]
                    }
                    self.objPartcipantAddVM.addParticipantToResearch(urlStr, params: param as? Dictionary<String, AnyObject>, completion: {
                        if self.objPartcipantAddVM.cameFrom == "ShareProgram"{
                            self.objPartcipantAddVM.arrParticipantModel[sender.indexPath!].shared = true
                        } else{
                            self.objPartcipantAddVM.arrParticipantModel.remove(at: sender.indexPath!)
                        }
                        
                        if self.objPartcipantAddVM.arrParticipantModel.count<1{
                            self.tblVwPrt.isHidden = true
                        }else{
                            self.tblVwPrt.reloadData()
                        }
                    })
                } else if boolVal == "false"{
                    //HANDLE NO ACTIONS
                } else{
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func handleResponse(){
        if self.objPartcipantAddVM.arrParticipantModel.count>0{
            self.tblVwPrt.isHidden = false
            self.tblVwPrt.reloadData()
        }else{
            self.tblVwPrt.isHidden = true
//           if objPartcipantAddVM.pageCount+1 < objPartcipantAddVM.totalPageCount{
        }
    }
}

