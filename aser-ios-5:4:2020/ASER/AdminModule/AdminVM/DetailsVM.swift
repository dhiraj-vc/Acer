
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

class DetailsVM{
    var createQuesArr = ["Are you above 18?", "Your gender" , "Your country" , "Your Ethnicity(optional)"]
    
}

extension DetailsVC : UITableViewDelegate,UITableViewDataSource{
    //MARK:-->TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailVMObj.createQuesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVwDetail.dequeueReusableCell(withIdentifier: "DetailTVC", for: indexPath) as! DetailTVC
        cell.lblQuesttion.text! =  "\(indexPath.row+1). \(detailVMObj.createQuesArr[indexPath.row])"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}
