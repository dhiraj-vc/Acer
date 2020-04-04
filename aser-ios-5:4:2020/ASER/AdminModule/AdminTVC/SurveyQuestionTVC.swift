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
class SurveyQuestionTVC: UITableViewCell {
    //MARK:->IBOUTLETS
    @IBOutlet weak var lblQuestions: UILabel!
    @IBOutlet weak var txtFldQuestion: UITextField!
    @IBOutlet weak var txtFldTimeline: UITextField!
    @IBOutlet weak var txtFldOptions: UITextField!
    @IBOutlet weak var txtFldPictureSubmission: UITextField!
    @IBOutlet weak var txtViewAnswers: UITextView!
    
    @IBOutlet weak var optionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
class ShowDetailTVC: UITableViewCell {
    //MARK:-->IBOUTLETS
    @IBOutlet weak var lblQuesTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class UserQuestionTVC: UITableViewCell {
    //MARK:-->IBOUTLETS
    @IBOutlet weak var lblQuesTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

