
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

class EndSurveyQuestionVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var tblViewQuestions: UITableView!
    var endSurveyObj = EndSurveyQuesVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        endSurveyObj.getSureveyAnswer {
            self.tblViewQuestions.reloadData()
        }
    }
    //MARK:- Actions
    @IBAction func btnBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnSubmitAnswer(_ sender: UIButton) {
        let arrayForAns = NSMutableArray()
        for i in 0..<endSurveyObj.arrEndQuestions.count{
            let dictAns = NSMutableDictionary()
            let indexPath = IndexPath(row: i, section: 0)
            let cell = tblViewQuestions.cellForRow(at: indexPath) as! SurveyQuestionTVC
            dictAns.setValue( cell.txtViewAnswers.text, forKey: "\(endSurveyObj.arrEndQuestions[i].question!)")
            arrayForAns.add(dictAns)
        }
        let finalStr = Proxy.shared.jsonString(from: arrayForAns)
        let param = ["is_answered": 1 ,
                     "endSurveyQuestions": finalStr!] as [String:AnyObject]
                endSurveyObj.submitAnswer(param) {
                  KAppDelegate.navigateToOtherVC(identifier: "UserDashboardVC")
                }
    }
}
