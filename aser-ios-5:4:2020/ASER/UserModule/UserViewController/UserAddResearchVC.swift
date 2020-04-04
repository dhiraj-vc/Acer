
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

class UserAddResearchVC: UIViewController {

    //MARK:-->IBOUTLETS
    @IBOutlet weak var tblVwCretareResearch: UITableView!
    @IBOutlet weak var btnDrawer: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var cnstHeightForNextBtn: NSLayoutConstraint!
    //MARK: - Variables
    var createResProgVMObj  = UserAddResearchVM()
    var surveyVMObj = SurveyQuestionVM()
    //MARK: - VIewMEthods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        tblVwCretareResearch.tableHeaderView = UIView()
        tblVwCretareResearch.layer.borderColor = UIColor.lightGray.cgColor
        tblVwCretareResearch.layer.borderWidth = 1
        createResProgVMObj.pickerForBool.delegate = self
        createResProgVMObj.pickerForBool.dataSource = self
        createResProgVMObj.selectDate.datePickerMode = .date
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(selectedCat(_:)), name: NSNotification.Name("SelectedCountry"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("SelectedCountry"), object: nil)
    }
    
    //MARK:- Notification Methods
    @objc func selectedCat(_ notification: Notification) {
        if let dictCountry = notification.object as? CountryModel {
           createResProgVMObj.selectedCat = dictCountry.name!
            let indexPath = IndexPath(row: 2, section: 0)
            tblVwCretareResearch.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    //MARK:-->BUTTON ACTION
    @IBAction func btnBAckAction(_ sender: Any) {
       Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnSubmitAction(_ sender: Any)
    {
        if checkTextFeildValues() {
            let duration = Proxy.shared.getDuration(from: self.createResProgVMObj.startDate, to: self.createResProgVMObj.endDate)
            self.createResProgVMObj.dictForTextValues.setValue(duration, forKey: "Duration")
            KAppDelegate.addSurveyQuestionModel.ResearchProgramDict = self.createResProgVMObj.dictResearchProgram
            KAppDelegate.addSurveyQuestionModel.addValues(dict:  self.createResProgVMObj.dictForTextValues)
           if self.createResProgVMObj.cameFrom == "CopySurvey" {
                        let detailObj = mainStoryboard.instantiateViewController(withIdentifier: "UserSurveyQuestionVC") as! UserSurveyQuestionVC
                        detailObj.surveyVMObj.isEditProgram = "Copy"
                        detailObj.surveyVMObj.arrSurveyQuestModel = self.createResProgVMObj.objResearchDetailModel.arrSurveyQuestModel
                        self.navigationController?.pushViewController(detailObj, animated: true)
                    } else {
                        let detailObj = mainStoryboard.instantiateViewController(withIdentifier: "UserSurveyQuestionVC") as! UserSurveyQuestionVC
                        detailObj.surveyVMObj.isEditProgram = ""
                        self.navigationController?.pushViewController(detailObj, animated: true)
                    }
          
        }
    }
    
    @IBAction func actionSubmit(_ sender: UIButton)
    {
        if checkTextFeildValues()
        {
            let duration = Proxy.shared.getDuration(from: createResProgVMObj.startDate, to: createResProgVMObj.endDate)
            createResProgVMObj.dictForTextValues.setValue(duration, forKey: "Duration")
            KAppDelegate.addSurveyQuestionModel.ResearchProgramDict = createResProgVMObj.dictResearchProgram
            KAppDelegate.addSurveyQuestionModel.addValues(dict:  createResProgVMObj.dictForTextValues)
            
            if (KAppDelegate.addSurveyQuestionModel.pictureSubmission == "1") || (KAppDelegate.addSurveyQuestionModel.pictureSubmission == "0") {
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
                let arrForQuestions = NSMutableArray()
                if self.createResProgVMObj.objResearchDetailModel.arrSurveyQuestModel.count>0 {
                    KAppDelegate.addSurveyQuestionModel.duration = self.createResProgVMObj.objResearchDetailModel.submissionTimeLine
                    for i in 0..<self.createResProgVMObj.objResearchDetailModel.arrSurveyQuestModel.count {
                        let dictForQuestion = NSMutableDictionary()
                        if let dictQues = self.createResProgVMObj.objResearchDetailModel.arrSurveyQuestModel[i] as? SurveyQuestModel {
                            dictForQuestion.setValue("\(dictQues.question!)", forKey: "question")
                            dictForQuestion.setValue("\(dictQues.day!)", forKey: "day")
                            dictForQuestion.setValue("\(dictQues.pictureSubmission!)", forKey:  "picture_submission")
                            dictForQuestion.setValue("\(dictQues.typeId!)", forKey:  "type_id")
                            if dictQues.arrOptionModel.count > 0 {
                                let arrOptions = NSMutableArray()
                                for j in 0..<dictQues.arrOptionModel.count {
                                    if let dictOtp = dictQues.arrOptionModel[j] as? OptionModel {
                                        let dictOptions = NSMutableDictionary()
                                        dictOptions.setValue("\(dictOtp.option!)", forKey:  "title")
                                        dictOptions.setValue("\(dictOtp.isAnswer!)", forKey:  "ans")
                                        arrOptions.add(dictOptions)
                                    }
                                }
                                dictForQuestion.setValue(arrOptions, forKey: "option")
                            }else{
                                dictForQuestion.setValue([], forKey: "option") //append Empty Array
                            }
                        }
                        arrForQuestions.add(dictForQuestion)
                    }
                    
                    let arrJsonVal = Proxy.shared.jsonString(from:arrForQuestions as Any)
                     mainDict.setValue(arrJsonVal, forKey: "Surveyquestion")
                } else {
                    mainDict.setValue("[]", forKey: "Surveyquestion")
                }
                let newMain = NSMutableDictionary()
                newMain.setValue(mainDict, forKey: "main")
                self.surveyVMObj.addSurvayQuestion(param: newMain as! [String : AnyObject]) { (response) in
                    self.surveyVMObj.handelAddResponse(response, view: self)
                }
            } else{
                Proxy.shared.displayStatusCodeAlert("Please set Daily Picture Submission to create Program")
            }
        }
    }
    //MARK:- CustomMethods
    func checkTextFeildValues() -> Bool {
        var boolValue = Bool()
        for i in 0..<createResProgVMObj.createResearchArr.count {
            let indexpathForEmail = IndexPath(row: i, section: 0)
            let cell = tblVwCretareResearch.cellForRow(at: indexpathForEmail) as! CreateResearchTVC
            if cell.txtFldName.text! == "" {
                Proxy.shared.displayStatusCodeAlert("Please Enter \(createResProgVMObj.createResearchArr[i])")
                boolValue = false
                break
            } else if cell.txtFldName.tag == 3 && cell.txtFldName.text! != ""{
                let startDate =  Proxy.shared.getDateFrmStringNew(getDate: cell.txtFldName.text!, format: "dd MMM,yyyy")
                if Date() > startDate {
                    Proxy.shared.displayStatusCodeAlert("Start date should be greater then current date")
                    boolValue = false
                    break
                } else {
                    createResProgVMObj.dictForTextValues.setValue(cell.txtFldName.text, forKey: "\(createResProgVMObj.createResearchArr[i])")
                }
            } else {
                createResProgVMObj.dictForTextValues.setValue(cell.txtFldName.text, forKey: "\(createResProgVMObj.createResearchArr[i])")
                boolValue = true
            }
        }
        return boolValue
    }
}
