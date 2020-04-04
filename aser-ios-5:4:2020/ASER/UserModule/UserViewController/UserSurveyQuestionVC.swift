
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

class UserSurveyQuestionVC: UIViewController, SelectedQuestion
{
    //MARK:-->IBOUTLETS
    @IBOutlet weak var tblvw: UITableView!
    var surveyVMObj = UserSurveyQuestionVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        selectQuest = self
        if KAppDelegate.arrForQuestion.count == 0 {
            if surveyVMObj.isEditProgram == "Edit"{
                surveyVMObj.getUpdateReserachData {
                    KAppDelegate.arrForQuestion.removeAllObjects()
                    self.setDictForEdit()
                }
            } else if surveyVMObj.isEditProgram == "Copy"{
                KAppDelegate.arrForQuestion.removeAllObjects()
                self.setDictForEdit()
            }
        } else {
            if surveyVMObj.isEditProgram == "Edit"{
                surveyVMObj.getUpdateReserachData {
                    KAppDelegate.arrForQuestion.removeAllObjects()
                    self.setDictForEdit()
                }
            } else if surveyVMObj.isEditProgram == "Copy"{
                KAppDelegate.arrForQuestion.removeAllObjects()
                self.setDictForEdit()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        tblvw.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(selectedDays(_:)), name: NSNotification.Name("SelectedDays"), object: nil)
    }
    //MARK:- Selected Question from question bank.
    func questionToAdd(_ dictQues: SurveyQuestModel) {
        surveyVMObj.arrSurveyQuestModel.removeAll()
        surveyVMObj.arrSurveyQuestModel.append(dictQues)
        setDictForEdit()
    }
    //MARK:--> BUTTON ACTION
    @IBAction func btnBAckAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        if checkTextFeildValues() {
            let mainDict = NSMutableDictionary()
            let dictForResearchProgram = NSMutableDictionary()
            dictForResearchProgram.setValue(KAppDelegate.addSurveyQuestionModel.assignCode, forKey: "assign_code")
            dictForResearchProgram.setValue(KAppDelegate.addSurveyQuestionModel.companyName, forKey: "company_name")
            dictForResearchProgram.setValue(KAppDelegate.addSurveyQuestionModel.produnctName, forKey: "product_name")
            dictForResearchProgram.setValue(KAppDelegate.addSurveyQuestionModel.duration, forKey: "submission_timeline")
            dictForResearchProgram.setValue(KAppDelegate.addSurveyQuestionModel.startDate, forKey: "start_date")
            dictForResearchProgram.setValue(KAppDelegate.addSurveyQuestionModel.endDate, forKey: "end_date")
            dictForResearchProgram.setValue(KAppDelegate.addSurveyQuestionModel.pictureSubmission!, forKey: "picture_submission")
            let dictJsonVal = Proxy.shared.jsonString(from:dictForResearchProgram as Any)
            mainDict.setValue(dictJsonVal, forKey: "ResearchProgram")
            let arrJsonVal = Proxy.shared.jsonString(from:KAppDelegate.arrForQuestion as Any)
            mainDict.setValue(arrJsonVal, forKey: "Surveyquestion")
            let newMain = NSMutableDictionary()
            newMain.setValue(mainDict, forKey: "main")
            if surveyVMObj.isEditProgram != "Edit" {
                surveyVMObj.addSurvayQuestion(param: newMain as! [String : AnyObject]) { (response) in
                    self.surveyVMObj.handelAddResponse(response, view: self)
                } } else {
                let mainQuesDict = NSMutableDictionary()
                let arrJsonVal = Proxy.shared.jsonString(from:KAppDelegate.arrForQuestion as Any)
                mainQuesDict.setValue(arrJsonVal, forKey: "Surveyquestion")
                surveyVMObj.editSurvayQuestion(param: mainQuesDict as! [String : AnyObject]) { (response) in
                    self.surveyVMObj.handelAddResponse(response, view: self)
                }
            }
        }
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        
        KAppDelegate.navigateToOtherVC(identifier: "UserDashboardVC")
        
  //      Proxy.shared.pushToNextVC(identifier:"CreateResearchProgramVC", isAnimate: false, currentViewController: self)
    }
    @IBAction func btnAddQuestion(_ sender: UIButton) {
        setQuestionDict()
    }
    @IBAction func btnAddQuestionFromBank(_ sender: UIButton) {
        Proxy.shared.pushToNextVC(identifier: "QuestionBankVC", isAnimate: true, currentViewController: self)
    }
}
