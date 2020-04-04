
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
class SurveyQuestionVC: UIViewController, SelectedQuestion  {
    
    @IBOutlet weak var optionLbl: UILabel!
    @IBOutlet weak var searchText: UITextField!
    
    //MARK:-->IBOUTLETS
    @IBOutlet weak var tblvw: UITableView!
    @IBOutlet weak var listtblvw: UITableView!
    
    //Color
    
    @IBOutlet weak var topbarView: UIView!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var previewBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var mandForQuestion = NSMutableArray()
    var surveyVMObj = SurveyQuestionVM()
    var objQuestionsVM = QuestionBankVM()
    var arrQuestionsFiltered = [SurveyQuestModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UserDefaults.standard.string(forKey: "ColorKey")
        if color == "Green"{
            
            topbarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            previewBtn.setBackgroundImage(UIImage(named: "bar_green@2x.png"), for: UIControl.State.normal)
            cancelBtn.setBackgroundImage(UIImage(named: "bar_green@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Default"{
            
            topbarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            cancelBtn.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
            previewBtn.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
            
        }else if color == "Black"{
            
            topbarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            previewBtn.setBackgroundImage(UIImage(named: "bar_black@2x.png"), for: UIControl.State.normal)
            cancelBtn.setBackgroundImage(UIImage(named: "bar_black@2x.png"), for: UIControl.State.normal)
            
            
        }else if color == "Gold"{
            
            topbarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            cancelBtn.setBackgroundImage(UIImage(named: "bar_yellow@2x.png"), for: UIControl.State.normal)
            previewBtn.setBackgroundImage(UIImage(named: "bar_yellow@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Blue"{
            
            topbarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            previewBtn.setBackgroundImage(UIImage(named: "bar_blue@2x.png"), for: UIControl.State.normal)
            cancelBtn.setBackgroundImage(UIImage(named: "bar_blue@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Pink"{
            
            topbarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            cancelBtn.setBackgroundImage(UIImage(named: "bar_pink@2x.png"), for: UIControl.State.normal)
            previewBtn.setBackgroundImage(UIImage(named: "bar_pink@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Red"{
            
            topbarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            previewBtn.setBackgroundImage(UIImage(named: "bar_red@2x.png"), for: UIControl.State.normal)
            cancelBtn.setBackgroundImage(UIImage(named: "bar_red@2x.png"), for: UIControl.State.normal)
            
        }else {
            topbarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            cancelBtn.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
            previewBtn.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
        }
        //MARK : get all question
        listtblvw.delegate = self
        listtblvw.dataSource = self
        listtblvw.isHidden = true
        objQuestionsVM.getQuestionModel {
//            self.listtblvw.reloadData()
        }
        
        
        searchText.delegate = self
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
            } else {
                setQuestionDict()
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
    
    
    //MARK : hit api on text enter
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.count + string.count - range.length
        
        if newLength<=0{
            listtblvw.isHidden = true
        }else{
            if textField.tag==11{
                filterQuestions(text: string)
                listtblvw.isHidden = false
                self.view .bringSubviewToFront(listtblvw)
            }else{
                listtblvw.isHidden = true
            }
        }
        return true
    }
    
    //MARK :- Filter question based on text field
    
    func filterQuestions(text : String){
        arrQuestionsFiltered = objQuestionsVM.arrQuestions.filter({($0.question?.contains(text))!})
        listtblvw.reloadData()
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
                //MARK : send this data to preview
//                print(newMain)
                let preview = self.storyboard?.instantiateViewController(withIdentifier: "PreviewVC") as! PreviewVC
                preview.newMain = KAppDelegate.arrForQuestion
                preview.newMainDict = newMain
                self.navigationController?.pushViewController(preview, animated: true)
//                surveyVMObj.addSurvayQuestion(param: newMain as! [String : AnyObject]) { (response) in
//                    self.surveyVMObj.handelAddResponse(response, view: self)
//                }
                
            } else {
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
        Proxy.shared.pushToNextVC(identifier:"CreateResearchProgramVC", isAnimate: false, currentViewController: self)
    }
    
    @IBAction func btnAddQuestion(_ sender: UIButton) {
        setQuestionDict()
    }
    @IBAction func btnAddQuestionFromBank(_ sender: UIButton) {
        Proxy.shared.pushToNextVC(identifier: "QuestionBankVC", isAnimate: true, currentViewController: self)
    }
    
//    func searchQuestion(param : [String:AnyObject],completion: @escaping ResponseHandler)
//    {
//       
//            WebServiceProxy.shared.postData("\(Apis.)", params: param, showIndicator: true)  { (ApiResponse) in
//                completion(ApiResponse)
//            }
//        
//        }
        
    
}

