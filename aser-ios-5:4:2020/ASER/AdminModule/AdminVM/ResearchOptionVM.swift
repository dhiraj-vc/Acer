
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

class ResearchOptionVM:NSObject{
    var arrOptions = [["edit", "ic_edit_search"],["delete", "ic_delete_search"],["copy", "ic_copy_search"],["share", "ic_share_search"],["showAnswer", "ic_survey"],["saveTemplate", "ic_save_tempplate"],["shareOption", "ic_share_search"]]
    var cameFrom = String()
}
extension ResearchOptionVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (objResearchOptionVM.cameFrom == "Shared Survey") ? 2 : objResearchOptionVM.arrOptions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let returnCell = tblVwOptions.dequeueReusableCell(withIdentifier: "ResearchOptionTVC") as! ResearchOptionTVC
        returnCell.imgMenu.image = UIImage(named: objResearchOptionVM.arrOptions[indexPath.row][1])
        return returnCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
        
        if indexPath.row == 6 {
            let textToShare = "Please check my resarch on "
            
            if let myWebsite = NSURL(string: "https://apps.apple.com/us/app/aser/id1440724231") {
                let objectsToShare: [Any] = [textToShare, myWebsite]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                //                activityVC.popoverPresentationController?.sourceView = sender
                self.present(activityVC, animated: true, completion: nil)
                
             
            }
        }else {
            self.dismiss(animated: false, completion: {
                                NotificationCenter.default.post(name: NSNotification.Name("ShareProgram"), object: self.objResearchOptionVM.arrOptions[indexPath.row][0], userInfo:nil)
                            })
        }
    }
}
