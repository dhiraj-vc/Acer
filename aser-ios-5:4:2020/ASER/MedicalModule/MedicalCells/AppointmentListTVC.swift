
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

class AppointmentListTVC: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var imgViewPatient: UIImageView!
    @IBOutlet weak var lblPatientName: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblAppointmentStatus: UILabel!
    @IBOutlet weak var lblHealthIssue: UILabel!
    @IBOutlet weak var lblDateAndTime: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnReSchedule: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var cnstHeightForButtons: NSLayoutConstraint!
    @IBOutlet weak var btnPrescription: UIButton!
    @IBOutlet weak var lblAppointmentId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
