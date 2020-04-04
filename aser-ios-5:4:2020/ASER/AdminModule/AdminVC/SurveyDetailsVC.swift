
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

class SurveyDetailsVC: UIViewController {
    //MARK:-->IBOUTLETS & VARIABLES
    @IBOutlet weak var tblVwSurvey: UITableView!
    var surveyDetailsVMObj = SurveyDetailsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:--> BUTTON ACTION
    @IBAction func btnBAckAction(_ sender: Any) {
       Proxy.shared.popToBackVC(isAnimate: true,currentViewController: self)
       // sideMenuViewController?._presentLeftMenuViewController()
    }
    
    @IBAction func btnAddParticipantAction(_ sender: Any){
        Proxy.shared.pushToNextVC(identifier:"ParticipantsListVC", isAnimate: false, currentViewController: self)
    }
}
