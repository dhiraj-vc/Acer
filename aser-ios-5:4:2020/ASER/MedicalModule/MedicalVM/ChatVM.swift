
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
class ChatVM {
    var timer = Timer()
    var messageToId = Int()
    var arrChatList = [ChatModel]()
    func getNewChat(_ completion:@escaping() -> Void){
        WebServiceProxy.shared.getData("\(Apis.KGetNewMsg)\(messageToId)", showIndicator: false) { (response) in
            if response.success{
                if let responsedict =  response.data {
                    if let resArrr = responsedict["messages"] as? NSArray
                    {
                        if resArrr.count == 0
                        {
                            Proxy.shared.displayStatusCodeAlert("No chat found")
                        }else{
                            for i in 0..<resArrr.count{
                                if let dictData = resArrr[i] as? NSDictionary{
                                    let objVM = ChatModel()
                                    objVM.getChatDet(dictData)
                                    self.arrChatList.append(objVM)
                                }
                            }
                        }
                    }
                }
                completion()
            }
        }
    }
    func getChat(_ completion:@escaping() -> Void){
        WebServiceProxy.shared.getData("\(Apis.KGetOldMsg)\(messageToId)", showIndicator: true) { (response) in
            self.handleResponse(response, completion: {
               completion()
            })
        }
    }
    
    func sendMessages(_ params:[String : AnyObject], completion:@escaping() -> Void){
        WebServiceProxy.shared.postData("\(Apis.KSendMsg)", params: params, showIndicator: false) { (response) in
            if response.success{
                if let responsedict =  response.data {
                    if let dictData = responsedict["data"] as? NSDictionary {
                        let objVM = ChatModel()
                        objVM.getChatDet(dictData)
                        self.arrChatList.append(objVM)
                    }
                }
            }else{
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
             completion()
        }
    }
    func handleResponse(_ response: ApiResponse, completion:@escaping() -> Void){
        if response.success{
            arrChatList.removeAll()
            if let responsedict =  response.data {
                if let resArrr = responsedict["list"] as? NSArray {
                    for i in 0..<resArrr.count{
                        if let dictData = resArrr[i] as? NSDictionary{
                            let objVM = ChatModel()
                            objVM.getChatDet(dictData)
                            self.arrChatList.append(objVM)
                        }
                    }
                }
                if self.arrChatList.count>1 {
                    self.arrChatList = self.arrChatList.sorted{ $0.createdOn! < $1.createdOn!}
                }
            }
            completion()
        }
    }
}
extension ChatVC: UITableViewDelegate,UITableViewDataSource, UITextViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objChatVM.arrChatList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dictChat = objChatVM.arrChatList[indexPath.row]
        if dictChat.fromUserId == KAppDelegate.objUserDetailModel.idUser {
            let returnCell = tableView.dequeueReusableCell(withIdentifier: "SendMsgTVC")  as! SendMsgTVC
            returnCell.lblSendMsg.text = dictChat.message
            returnCell.lblCreatedOn.text = Proxy.shared.changeDateFormat(dictChat.createdOn!, oldFormat: "yyyy-MM-dd HH:mm:ss", dateFormat: "dd MMM,yyyy hh:mm a")
            return returnCell
        } else {
            let returnCell = tableView.dequeueReusableCell(withIdentifier: "RecivedMsgTVC", for: indexPath) as! RecivedMsgTVC
            returnCell.lblRecivedMsg.text = dictChat.message
            returnCell.imgVwUser.sd_setImage(with: URL(string: dictChat.profileImg!), placeholderImage: UIImage(named:"ic_profile-1"))
            returnCell.lblCreatedOn.text = Proxy.shared.changeDateFormat(dictChat.createdOn!, oldFormat: "yyyy-MM-dd HH:mm:ss", dateFormat: "dd MMM,yyyy hh:mm a")
            return returnCell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 70
        return UITableView.automaticDimension
    }
    
    //MARK:- text view delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
//        txtViewMsgs.resignFirstResponder()
        return false
    }
}

