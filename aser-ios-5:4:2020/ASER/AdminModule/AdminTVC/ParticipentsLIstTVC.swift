
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
class ParticipentsLIstTVC: UITableViewCell {
    //MARK:-->IBOUTLETS
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblUsrName: UILabel!
    @IBOutlet weak var lblUsrDetail: UILabel!
    @IBOutlet weak var btnDelRef: UIButton!
    @IBOutlet weak var btnEditRef: UIButton!
    @IBOutlet weak var btnNotificationRef: UIButton!
    @IBOutlet weak var VwFLoatingRating: FloatRatingView!
    @IBOutlet weak var vwContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
