
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
import CropViewController
class SearchProgramQuesAnsVC: UIViewController,PassImageDelegate,TOCropViewControllerDelegate {
    //MARK:- Outlets
    @IBOutlet weak var tblVwSearchQues: UITableView!
    @IBOutlet weak var btnSkipQuestion: UIButton!
    @IBOutlet weak var vwSkip: UIView!
    @IBOutlet weak var imgSkip: UIImageView!
    @IBOutlet weak var cnstHeightVw: NSLayoutConstraint!    
    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var lblUploadTitle: UILabel!
    @IBOutlet weak var viewHeaderPicUpload: UIView!
    @IBOutlet weak var cnstHeightCameraVw: NSLayoutConstraint!

    @IBOutlet weak var imgVwAnsSubmitted: UIImageView!
    var searchPrrogQuesAnsVMObj = SearchPrrogQuesAnsVM()
    var endSurveyObj = EndSurveyQuesVM()
    var optForQuestion = NSMutableArray()
    var selectedIndex: [Bool] = [false]
    var bC: [Bool] = [false]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //himanshu
        

        tblVwSearchQues.estimatedRowHeight = 55.0
        tblVwSearchQues.rowHeight = UITableView.automaticDimension
        tblVwSearchQues.estimatedSectionHeaderHeight = 62.0
        tblVwSearchQues.sectionHeaderHeight = UITableView.automaticDimension
        galleryCameraImageObj = self
         imgVwAnsSubmitted.isHidden = true
        searchPrrogQuesAnsVMObj.galleryFunctions.cropDisable = true
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //SHOW HIDE SKIP BUTTON FOR PASSED SURVEY
    }
    //MARK:- Actions
    @IBAction func actionCamera(_ sender: UIButton)
    {
//        searchPrrogQuesAnsVMObj.galleryFunctions.currentController = self
//        searchPrrogQuesAnsVMObj.galleryFunctions.openCamera()
        searchPrrogQuesAnsVMObj.valueUpdated = true
        searchPrrogQuesAnsVMObj.mainImage = true
//
        
        Proxy.shared.pushToNextVC(identifier: "CameraViewController", isAnimate: false, currentViewController: self)        
        
    }
    @IBAction func actionBack(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    @IBAction func actionSkipQuest(_ sender: UIButton) {
        searchPrrogQuesAnsVMObj.getSureveyAnswer {
            if self.searchPrrogQuesAnsVMObj.remainingDay != "0"{
                self.btnSkipQuestion.setTitle("Skip Day \(self.searchPrrogQuesAnsVMObj.surveyDayQuest-1)", for: .normal)
            }
            else{
                self.btnSkipQuestion.isHidden = true
                self.vwSkip.isHidden = true
                self.imgSkip.isHidden = true
                self.cnstHeightVw.constant = 0
            }
            self.setDictForAnswer()
            self.tblVwSearchQues.reloadData()
        }
    }
    
    @IBAction func actionNext(_ sender: Any) { //Submmit Question
        let jsonArrForQues = Proxy.shared.jsonString(from: searchPrrogQuesAnsVMObj.arrForAnswers)
        let param = ["main[SurveyAnswer]": jsonArrForQues,
                     "main[research_id]" : "\(searchPrrogQuesAnsVMObj.researchId)" ] as [String:AnyObject]
        var paramImage = [String:UIImage]()
        if imgPreview.image != nil {
            paramImage = ["File[file]": imgPreview.image] as! [String : UIImage]
        }
        if self.searchPrrogQuesAnsVMObj.arrForImages.count>0 {
            for i in 0..<self.searchPrrogQuesAnsVMObj.arrForImages.count {
                let dictImg = self.searchPrrogQuesAnsVMObj.arrForImages[i] as! NSDictionary
                paramImage["SurveyAnswer[image][\(dictImg["QuesId"] as! String)]"] = dictImg["AnsImg"] as? UIImage
            }
        }
        
         self.searchPrrogQuesAnsVMObj.submitUserAnswer(param, paramImage: paramImage) {
            if self.searchPrrogQuesAnsVMObj.isLastDay == 1 {
                Proxy.shared.alertControl(title: "Thank you", message: "Thank you very much for using ASER to test your product. Would you like to participate in a product testing survey by ASER?", { (alert, boolVal) in
                    if boolVal == "true" {
                        Proxy.shared.pushToNextVC(identifier: "EndSurveyQuestionVC", isAnimate: true, currentViewController: self)
                    } else if boolVal == "false" {
                        let param = ["is_answered": 0 ,
                                     "endSurveyQuestions": ""] as [String:AnyObject]
                        self.endSurveyObj.submitAnswer(param, completion: {
                            KAppDelegate.navigateToOtherVC(identifier: "UserDashboardVC")
                            
                        })
                    } else {
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            } else {
            if self.searchPrrogQuesAnsVMObj.remainingDay == "0"{
                KAppDelegate.navigateToOtherVC(identifier: "UserDashboardVC")
            }else{
                self.loadData()
            }
            }
        }
    }
    func setDictForAnswer()
    {
        if searchPrrogQuesAnsVMObj.arrSurveyQuestModel.count > 0 {
//            self.selectedIndex.append(false)
            for i in 0..<searchPrrogQuesAnsVMObj.arrSurveyQuestModel.count {
                let dictForAnswer = NSMutableDictionary()
                let dictAns = searchPrrogQuesAnsVMObj.arrSurveyQuestModel[i]
                dictForAnswer.setValue(dictAns.id, forKey: "question_id")
                dictForAnswer.setValue(dictAns.typeId, forKey: "type_id")
                dictForAnswer.setValue("", forKey: "answer")
                let arrOptions = NSMutableArray()
                dictForAnswer.setValue(arrOptions, forKey: "SurveyAnswerOption")
                searchPrrogQuesAnsVMObj.arrForAnswers.add(dictForAnswer)
            }
        }
    }
    func loadData(){
        searchPrrogQuesAnsVMObj.arrForAnswers.removeAllObjects()
        searchPrrogQuesAnsVMObj.arrForImages.removeAllObjects()
        searchPrrogQuesAnsVMObj.getSureveyAnswer {
            if self.searchPrrogQuesAnsVMObj.remainingDay != "0"{
                 self.imgPreview.image = nil
                self.btnSkipQuestion.isHidden = false
                self.vwSkip.isHidden = false
                self.imgSkip.isHidden = false
                self.cnstHeightVw.constant = 44
                self.btnSkipQuestion.setTitle("Skip Day \(self.searchPrrogQuesAnsVMObj.surveyDayQuest-1)", for: .normal)
            }else{
                self.btnSkipQuestion.isHidden = true
                self.vwSkip.isHidden = true
                self.imgSkip.isHidden = true
                self.cnstHeightVw.constant = 0
            }
            if self.searchPrrogQuesAnsVMObj.dailyPicSub == "0"{
                self.viewHeaderPicUpload.isHidden = true
                self.cnstHeightCameraVw.constant = 0
            }
            self.setDictForAnswer()
            self.tblVwSearchQues.reloadData()
            if self.searchPrrogQuesAnsVMObj.isSubmitted == 1{
                self.imgVwAnsSubmitted.isHidden = false
            }
        }
    }
}
