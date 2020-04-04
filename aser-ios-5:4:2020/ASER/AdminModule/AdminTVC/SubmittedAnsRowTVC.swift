
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
class SubmittedAnsRowTVC: UITableViewCell {
    @IBOutlet weak var lblAnswerSubmitted: UILabel!
    @IBOutlet weak var imgOptionSubmitted: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class SubmittedAnsHeaderTVC: UITableViewCell{
    @IBOutlet weak var lblQuestion: UILabel!
}
