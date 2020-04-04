
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
class SearchProgramVC: UIViewController {
    //MARK:- OUTLETS
    @IBOutlet weak var tblQuestions: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAssignCode: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblResearchStartDate: UILabel!
    @IBOutlet weak var lblResearchEndDate: UILabel!
    @IBOutlet weak var PictureSubmission: UILabel!
    @IBOutlet weak var cnstHeight: NSLayoutConstraint!
    @IBOutlet weak var tblViewAddQuestion: UITableView!
    @IBOutlet weak var cnstHeightAddQues: NSLayoutConstraint!
    @IBOutlet weak var cnstHeightBtnParticipant: NSLayoutConstraint!
    @IBOutlet weak var btnParticipant: UIButton!
    
    //color
    
    @IBOutlet weak var topbarView: UIView!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var participantListBtn: UIButton!
    
    var searchProgVMObj = SearchProgramVwModel()
    var arrOptions = [["edit", "ic_edit_search"],["delete", "ic_delete_search"],["copy", "ic_copy_search"],["share", "ic_history"]]

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = UserDefaults.standard.string(forKey: "ColorKey")
        if color == "Green"{
            
            topbarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
             btnParticipant.setBackgroundImage(UIImage(named: "bar_green@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Default"{
            
            topbarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            btnParticipant.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
            
        }else if color == "Black"{
            
            topbarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            btnParticipant.setBackgroundImage(UIImage(named: "bar_black@2x.png"), for: UIControl.State.normal)
            
            
        }else if color == "Gold"{
            
            topbarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            btnParticipant.setBackgroundImage(UIImage(named: "bar_yellow@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Blue"{
            
            topbarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            btnParticipant.setBackgroundImage(UIImage(named: "bar_blue@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Pink"{
            
            topbarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            btnParticipant.setBackgroundImage(UIImage(named: "bar_pink@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Red"{
            
            topbarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            btnParticipant.setBackgroundImage(UIImage(named: "bar_red@2x.png"), for: UIControl.State.normal)
            
        }else {
            topbarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            btnParticipant.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
        }
        tblQuestions.reloadData()
        cnstHeight.constant = tblQuestions.contentSize.height
        if searchProgVMObj.cameFrom == "Shared Survey"{
            cnstHeightBtnParticipant.constant = 0
            btnParticipant.isHidden = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        searchProgVMObj.getReserachData {
            self.lblTitle.text = self.searchProgVMObj.objResearchDetailModel.productName!
            self.lblAssignCode.text = self.searchProgVMObj.objResearchDetailModel.assignCode!
            self.lblCompanyName.text = self.searchProgVMObj.objResearchDetailModel.companyName!
            self.lblProductName.text = self.searchProgVMObj.objResearchDetailModel.productName!
            self.PictureSubmission.text = self.searchProgVMObj.objResearchDetailModel.pictureSubVal!
            let startDate = Proxy.shared.getDateFrmString(getDate:self.searchProgVMObj.objResearchDetailModel.reserachStartDate!, format: "yyyy-MM-dd")
            self.lblResearchStartDate.text = Proxy.shared.getStringFrmDate(getDate: startDate, format: "dd,MMM yyyy")
            let endDate = Proxy.shared.getDateFrmString(getDate:self.searchProgVMObj.objResearchDetailModel.reserachEndDate!, format: "yyyy-MM-dd")
            self.lblResearchEndDate.text = Proxy.shared.getStringFrmDate(getDate: endDate, format: "dd,MMM yyyy")
            self.tblViewAddQuestion.reloadData()
            self.cnstHeightAddQues.constant = self.tblViewAddQuestion.contentSize.height
            KAppDelegate.addSurveyQuestionModel.pictureSubmission = "\(self.searchProgVMObj.objResearchDetailModel.pictureSubmission!)"
        }        
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
            createResObj.surveyVMObj.researchId = self.searchProgVMObj.objResearchDetailModel.id!
            KAppDelegate.addSurveyQuestionModel.duration =    self.searchProgVMObj.objResearchDetailModel.submissionTimeLine!
            
            self.navigationController?.pushViewController(createResObj, animated: true)
        case "delete":
            Proxy.shared.alertControl(title: "", message: AlertMsgs.AREYOUSUREWANTTODELETETHISSURVEY) { (alert, boolVal) in
                if boolVal == "true"{
                    self.searchProgVMObj.deleteSurvey( self.searchProgVMObj.researchId, completion: {                        
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
            createResObj.createResProgVMObj.objResearchDetailModel = self.searchProgVMObj.objResearchDetailModel
            self.navigationController?.pushViewController(createResObj, animated: true)
        case "share":
            let objVC = mainStoryboard.instantiateViewController(withIdentifier: "ParticipentAddListVC") as! ParticipentAddListVC
            objVC.title = "ShareProgram"
            objVC.objPartcipantAddVM.researchId = searchProgVMObj.researchId
            self.navigationController?.pushViewController(objVC, animated: true)            
        case "showAnswer":
            let objVC = mainStoryboard.instantiateViewController(withIdentifier: "SubmittedSurveyAnsVC") as! SubmittedSurveyAnsVC
            objVC.title = "ShareProgram"
            objVC.objSubSurveyAnsVM.researchId = searchProgVMObj.researchId
            self.navigationController?.pushViewController(objVC, animated: true)
        case "saveTemplate":
            let objVC = mainStoryboard.instantiateViewController(withIdentifier: "SaveTemplateVC") as! SaveTemplateVC
            objVC.objSaveTempVM.researchId = searchProgVMObj.researchId
            self.navigationController?.present(objVC, animated: true, completion: nil)
        default:
            break
        }
    }
    
    //MARK:- ACTION'S
    @IBAction func btnNext(_ sender: UIButton) {
        let objVC = mainStoryboard.instantiateViewController(withIdentifier: "ParticipantsListVC") as! ParticipantsListVC
        objVC.participantsListVMObj.researchId =  searchProgVMObj.researchId
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
     @IBAction func actionOption(_ sender: UIButton) {
        let objVC = mainStoryboard.instantiateViewController(withIdentifier: "ResearchOptionVC") as! ResearchOptionVC
        if searchProgVMObj.cameFrom == "Shared Survey"{
            objVC.objResearchOptionVM.cameFrom = "Shared Survey"
        }
        self.navigationController?.present(objVC, animated: false, completion: nil)
    }
}
