
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

class ChatListVM: NSObject {
    var arrChatList = [ChatModel]()
    func getChatList(_ completion:@escaping() -> Void){
        WebServiceProxy.shared.getData("\(Apis.KChatList)", showIndicator: true) { (response) in
            if response.success{
                if let responsedict =  response.data {
                    self.arrChatList.removeAll()
                    if let resArrr = responsedict["list"] as? NSArray
                    {
                        if resArrr.count == 0
                        {
                            Proxy.shared.displayStatusCodeAlert("No chat found")
                        }else
                        {
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
            }else{
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
        }
    }
}
extension ChatListVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objChatListVM.arrChatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTVC") as! ChatListTVC
        let dictData = objChatListVM.arrChatList[indexPath.row]
        cell.imgViewUser.sd_setImage(with: URL(string: dictData.profileImg!), placeholderImage: UIImage(named:"ic_profile-1"))
        cell.lblName.text = dictData.fullName
        cell.lblSendTime.text = Proxy.shared.changeDateFormat(dictData.createdOn!, oldFormat: "yyyy-MM-dd HH:mm:ss", dateFormat: "dd MMM, yyyy hh:mm a")
        cell.lblRecievedMsg.text = dictData.message
        cell.lblUnreadCount.isHidden = (dictData.unreadCount!>0) ? false : true
        cell.lblUnreadCount.text = "\(dictData.unreadCount!)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictData = objChatListVM.arrChatList[indexPath.row]
        let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        nextVC.objChatVM.messageToId = dictData.chatId!
        KAppDelegate.currentViewCont = nextVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}
