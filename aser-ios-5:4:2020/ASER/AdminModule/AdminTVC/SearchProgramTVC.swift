
//
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
class SearchProgramTVC: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var lblQuestionTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class ResearchQuestAnsTVC:UITableViewCell{
    @IBOutlet weak var lblQuestionTitle: UILabel!
    @IBOutlet weak var lblSubmissionTimeline: UILabel!
    @IBOutlet weak var lblPictureSubmission: UILabel!
    @IBOutlet weak var lblAnswerType: UILabel!
    @IBOutlet weak var btnSelectQues: UIButton!
}
