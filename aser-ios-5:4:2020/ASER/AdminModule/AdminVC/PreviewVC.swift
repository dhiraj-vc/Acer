//
//  PreviewVC.swift
//  ASER
//
//  Created by Ankit Kumar on 23/11/19.
//  Copyright © 2019 Priti Sharma. All rights reserved.
//

import UIKit

class PreviewVC: UIViewController {
    //MARK:- OUTLETS
   // @IBOutlet weak var tblQuestions: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var lblAssignCode: UILabel!
//    @IBOutlet weak var lblCompanyName: UILabel!
//    @IBOutlet weak var lblProductName: UILabel!
//    @IBOutlet weak var lblResearchStartDate: UILabel!
//    @IBOutlet weak var lblResearchEndDate: UILabel!
//    @IBOutlet weak var PictureSubmission: UILabel!
//    @IBOutlet weak var cnstHeight: NSLayoutConstraint!
    @IBOutlet weak var tblViewAddQuestion: UITableView!
    @IBOutlet weak var cnstHeightAddQues: NSLayoutConstraint!
    @IBOutlet weak var cnstHeightBtnParticipant: NSLayoutConstraint!
    @IBOutlet weak var btnParticipant: UIButton!
    @IBOutlet weak var topBarVw: UIView!
    @IBOutlet weak var bottomBarVw: UIView!
    
    
    
    
    
    var previewVMObj = SearchProgramVwModel()
    var surveyVMObj = SurveyQuestionVM()
    var arrOptions = [["edit", "ic_edit_search"],["delete", "ic_delete_search"],["copy", "ic_copy_search"],["share", "ic_history"]]
    var newMainDict = NSMutableDictionary()
    var newMain = NSMutableArray()
    var dictQ : NSArray?
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = UserDefaults.standard.string(forKey: "ColorKey")
        if color == "Green"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            btnParticipant.setBackgroundImage(UIImage(named: "bar_green@2x.png"), for: UIControl.State.normal)
           
            
        }else if color == "Default"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            btnParticipant.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
           
            
        }else if color == "Black"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            btnParticipant.setBackgroundImage(UIImage(named: "bar_black@2x.png"), for: UIControl.State.normal)
           
            
            
        }else if color == "Gold"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            btnParticipant.setBackgroundImage(UIImage(named: "bar_yellow@2x.png"), for: UIControl.State.normal)
           
        }else if color == "Blue"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            btnParticipant.setBackgroundImage(UIImage(named: "bar_blue@2x.png"), for: UIControl.State.normal)
         
        }else if color == "Pink"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            btnParticipant.setBackgroundImage(UIImage(named: "bar_pink@2x.png"), for: UIControl.State.normal)
         
        }else if color == "Red"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            btnParticipant.setBackgroundImage(UIImage(named: "bar_red@2x.png"), for: UIControl.State.normal)
           
        }else {
            topBarVw.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            btnParticipant.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
           
        }
        
//        tblViewAddQuestion.delegate = self
//        tblViewAddQuestion.dataSource = self
//        tblViewAddQuestion.reloadData()

//        tblQuestions.reloadData()
//        cnstHeight.constant = tblQuestions.contentSize.height
        if previewVMObj.cameFrom == "Shared Survey"{
            cnstHeightBtnParticipant.constant = 0
            btnParticipant.isHidden = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        print(newMain)
        tblViewAddQuestion.reloadData()
        self.cnstHeightAddQues.constant = self.tblViewAddQuestion.contentSize.height
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: newMain, options: .prettyPrinted)
//            // here "jsonData" is the dictionary encoded in JSON data
//            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
//            // here "decoded" is of type `Any`, decoded from JSON data
//
//            // you can now cast it with the right type
//            if let dictFromJSON = decoded as?  NSDictionary {
//                // use dictFromJSON
//                print(dictFromJSON)
//                dictQ = dictFromJSON.value(forKeyPath: "main.Surveyquestion") as? NSArray
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
        
//        previewVMObj.getReserachData {
//            self.lblTitle.text = self.previewVMObj.objResearchDetailModel.productName!
////            self.lblAssignCode.text = self.previewVMObj.objResearchDetailModel.assignCode!
////            self.lblCompanyName.text = self.previewVMObj.objResearchDetailModel.companyName!
////            self.lblProductName.text = self.previewVMObj.objResearchDetailModel.productName!
////            self.PictureSubmission.text = self.previewVMObj.objResearchDetailModel.pictureSubVal!
////            let startDate = Proxy.shared.getDateFrmString(getDate:self.previewVMObj.objResearchDetailModel.reserachStartDate!, format: "yyyy-MM-dd")
////            self.lblResearchStartDate.text = Proxy.shared.getStringFrmDate(getDate: startDate, format: "dd,MMM yyyy")
////            let endDate = Proxy.shared.getDateFrmString(getDate:self.previewVMObj.objResearchDetailModel.reserachEndDate!, format: "yyyy-MM-dd")
////            self.lblResearchEndDate.text = Proxy.shared.getStringFrmDate(getDate: endDate, format: "dd,MMM yyyy")
//            self.tblViewAddQuestion.reloadData()
//            self.cnstHeightAddQues.constant = self.tblViewAddQuestion.contentSize.height
//            KAppDelegate.addSurveyQuestionModel.pictureSubmission = "\(self.previewVMObj.objResearchDetailModel.pictureSubmission!)"
//        }
        NotificationCenter.default.addObserver(self, selector: #selector(ShareProgram(_:)), name: NSNotification.Name("ShareProgram"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ShareProgram"), object: nil)
    }
    
    @objc func ShareProgram(_ notification:Notification){
        let optionVal = notification.object as? String
        switch optionVal  {
        case "edit":
            let createResObj = mainStoryboard.instantiateViewController(withIdentifier: "SurveyQuestionVC") as! SurveyQuestionVC
            createResObj.surveyVMObj.isEditProgram = "Edit" // Edit action
            createResObj.surveyVMObj.researchId = self.previewVMObj.objResearchDetailModel.id!
            KAppDelegate.addSurveyQuestionModel.duration =    self.previewVMObj.objResearchDetailModel.submissionTimeLine!
            
            self.navigationController?.pushViewController(createResObj, animated: true)
        case "delete":
            Proxy.shared.alertControl(title: "", message: AlertMsgs.AREYOUSUREWANTTODELETETHISSURVEY) { (alert, boolVal) in
                if boolVal == "true"{
                    self.previewVMObj.deleteSurvey( self.previewVMObj.researchId, completion: {
                        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
                        Proxy.shared.displayStatusCodeAlert(AlertMsgs.SURVEYREMOVED)
                    })
                } else if boolVal == "false"{
                    //HANDLE NO ACTIONS
                } else{
                    self.present(alert, animated: true, completion: nil)
                }
            }
        case "copy":
            let createResObj = mainStoryboard.instantiateViewController(withIdentifier: "CreateResProgVC") as! CreateResProgVC
            createResObj.createResProgVMObj.isEditProgram = "Copy" // Edit action
            createResObj.createResProgVMObj.cameFrom = "CopySurvey"
            createResObj.createResProgVMObj.objResearchDetailModel = self.previewVMObj.objResearchDetailModel
            self.navigationController?.pushViewController(createResObj, animated: true)
        case "share":
            let objVC = mainStoryboard.instantiateViewController(withIdentifier: "ParticipentAddListVC") as! ParticipentAddListVC
            objVC.title = "ShareProgram"
            objVC.objPartcipantAddVM.researchId = previewVMObj.researchId
            self.navigationController?.pushViewController(objVC, animated: true)
        case "showAnswer":
            let objVC = mainStoryboard.instantiateViewController(withIdentifier: "SubmittedSurveyAnsVC") as! SubmittedSurveyAnsVC
            objVC.title = "ShareProgram"
            objVC.objSubSurveyAnsVM.researchId = previewVMObj.researchId
            self.navigationController?.pushViewController(objVC, animated: true)
        case "saveTemplate":
            let objVC = mainStoryboard.instantiateViewController(withIdentifier: "SaveTemplateVC") as! SaveTemplateVC
            objVC.objSaveTempVM.researchId = previewVMObj.researchId
            self.navigationController?.present(objVC, animated: true, completion: nil)
        default:
            break
        }
    }
    
    //MARK:- ACTION'S
    @IBAction func btnNext(_ sender: UIButton) {
//        let objVC = mainStoryboard.instantiateViewController(withIdentifier: "ParticipantsListVC") as! ParticipantsListVC
//        objVC.participantsListVMObj.researchId =  previewVMObj.researchId
//        self.navigationController?.pushViewController(objVC, animated: true)
//        surveyVMObj.addSurvayQuestion(param: newMain as! [String : AnyObject]) { (response) in
//                          self.surveyVMObj.handelAddResponse(response, view: self)
//                      }
        surveyVMObj.addSurvayQuestion(param: newMainDict as! [String : AnyObject]) { (response) in
            self.surveyVMObj.handelAddResponse(response, view: self)
             }
    }
    @IBAction func btnBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    
     @IBAction func actionOption(_ sender: UIButton) {
        let objVC = mainStoryboard.instantiateViewController(withIdentifier: "ResearchOptionVC") as! ResearchOptionVC
        if previewVMObj.cameFrom == "Shared Survey"{
            objVC.objResearchOptionVM.cameFrom = "Shared Survey"
        }
        self.navigationController?.present(objVC, animated: false, completion: nil)
    }
}

extension PreviewVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return newMain.count//previewVMObj.objResearchDetailModel.arrSurveyQuestModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let dict = newMain[section] as! NSDictionary
        let arrOptionModel = dict.value(forKey: "option")  as! NSArray
        
        if arrOptionModel.count == 0 || arrOptionModel.count == 1{
            return 0
        }else if arrOptionModel.count > 1 {
            return arrOptionModel.count
        }
        else
        {
        return newMain.count
        }
//            newMain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let dictData = newMain[indexPath.section] as! NSDictionary
            let cellOptions = tblViewAddQuestion.dequeueReusableCell(withIdentifier: "OptionsTVC") as! OptionsTVC
            let arrOptionModel = dictData.value(forKey: "option")  as! NSArray
        
            if arrOptionModel.count>0{
                let ansDict = arrOptionModel[indexPath.row] as! NSDictionary
                let bc:Int? = Int(ansDict.value(forKey: "ans") as! String)
                if bc ==  BoolVal.TRUE.rawValue {
                    
                    let type_id:Int? = Int(dictData.value(forKey: "type_id") as! String)
                    // dictData.value(forKey: "type_id") as! Int
                    if type_id == Options.MULTIPLE.rawValue{
                        cellOptions.btnCheckBox.setImage(UIImage(named: "ic_chk"), for: .normal)
                    }else{
                        cellOptions.btnCheckBox.setImage(UIImage(named: "ic_radio_selected"), for: .normal)
                    }
                }
                else{
                    let mc:Int? = Int(dictData.value(forKey: "type_id") as! String)
                    if mc == Options.MULTIPLE.rawValue{
                        cellOptions.btnCheckBox.setImage(UIImage(named: "ic_unchk"), for: .normal)
                    }else{
                        cellOptions.btnCheckBox.setImage(UIImage(named: "ic_radio_unselected"), for: .normal)
                    }
                }
//                let modelDict = arrOptionModel[indexPath.row]
                cellOptions.lblOption.text = ansDict.value(forKey: "title") as? String
            }
            return cellOptions
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tblViewAddQuestion.dequeueReusableCell(withIdentifier: "ResearchQuestAnsTVC") as! ResearchQuestAnsTVC
        
        if  newMain.count>0{
//            let dictData = newMain[section] as! NSDictionary
            let modelDict = newMain[section] as! NSDictionary
            headerView.lblQuestionTitle.text = modelDict.value(forKey: "question")  as? String
            headerView.lblSubmissionTimeline.text = modelDict.value(forKey: "day")  as? String
            headerView.lblPictureSubmission.text =  modelDict.value(forKey: "picture_submission")  as? String
            var answerType = ""
            switch modelDict.value(forKey: "type_id")  as? Int{
                case Options.NO_OPTION.rawValue: answerType = "No question"
                case Options.MULTIPLE.rawValue: answerType = "Multiple Choice"
                case Options.CHOOSE_ONE.rawValue: answerType = "Choose One"
                case Options.TYPE_ANS.rawValue: answerType = "Write Answer"
            default:break
            }
            headerView.lblAnswerType .text = answerType
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tblViewAddQuestion.dequeueReusableCell(withIdentifier: "FooterViewTVC") as! FooterViewTVC
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return  68.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return  300.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return   UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return   41
    }
}
