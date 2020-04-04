
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
class RemoveQuestionTVC: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var btnAddQues: UIButton!
    @IBOutlet weak var btnRemoveQues: UIButton!
    @IBOutlet weak var viewForButton: UIView!
    @IBOutlet weak var cnstHeightForView: NSLayoutConstraint!
    

    @IBOutlet weak var mandatoryBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    @IBAction func mandatoryAction(_ sender: Any) {
//
//        mandatoryBtn.isSelected = !mandatoryBtn.isSelected
//
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class OptionsTVC: UITableViewCell {
    @IBOutlet weak var lblOption: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class AddSureveyOptTVC: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var txtFldOtpionTitle: UITextField!
    @IBOutlet weak var removeOptions: ButtonSubClass!
    @IBOutlet weak var btnCorrectAnswer: ButtonSubClass!
  
    @IBOutlet weak var optionLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
}
