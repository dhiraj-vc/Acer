
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

class ResearchTVC: UITableViewCell {
    //MARK:-->IBOUTLETS
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    @IBOutlet weak var btnSetAlarm: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
