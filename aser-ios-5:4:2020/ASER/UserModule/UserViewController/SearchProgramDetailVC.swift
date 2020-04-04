
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
import IQKeyboardManagerSwift
class SearchProgramDetailVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var tblVwSearch: UITableView!
    @IBOutlet weak var lblAssignCode: UITextField!
    @IBOutlet weak var lblCompany: UITextField!
    @IBOutlet weak var lblProduct: UITextField!
    @IBOutlet weak var lblResearchStartDate: UITextField!
    @IBOutlet weak var lblResearchEndDate: UITextField!
    @IBOutlet weak var lblBasicQuestionTitle: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblTitlBasicQuest: UILabel!
    var objSearchPDVW = SearchProgramDetailVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.title == "View Survey"{
            objSearchPDVW.createQuesArr = []
            btnNext.isHidden = true
            lblTitlBasicQuest.isHidden = true
        }        
    }
    override func viewWillAppear(_ animated: Bool) {
        if objSearchPDVW.arrCreateRPModel.count>0{
            lblMainTitle.text = objSearchPDVW.arrCreateRPModel[0].productName!
            lblAssignCode.text = objSearchPDVW.arrCreateRPModel[0].assignCode!
            lblCompany.text = objSearchPDVW.arrCreateRPModel[0].companyName!
            lblProduct.text = objSearchPDVW.arrCreateRPModel[0].productName!
            let startDate = Proxy.shared.getDateFrmString(getDate:objSearchPDVW.arrCreateRPModel[0].reserachStartDate! , format: "yyyy-MM-dd")
            lblResearchStartDate.text = Proxy.shared.getStringFrmDate(getDate: startDate, format: "dd,MMM yyyy")
             let endDate = Proxy.shared.getDateFrmString(getDate:objSearchPDVW.arrCreateRPModel[0].reserachEndDate! , format: "yyyy-MM-dd")
            lblResearchEndDate.text = Proxy.shared.getStringFrmDate(getDate: endDate, format: "dd,MMM yyyy")
            //MARK : CHECK FOR BASIC QUESTION IS SUBMIT OR NOT
//            if objSearchPDVW.arrCreateRPModel[0].basicQuestSubmitted {
//                lblBasicQuestionTitle.isHidden = true
//                objSearchPDVW.createQuesArr = []
//            }
        }
         NotificationCenter.default.addObserver(self, selector: #selector(selectedCountry(_:)), name: NSNotification.Name("SelectedCountry"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("SelectedCountry"), object: nil)
    }
    //Mark: Notifications Methods.
    @objc func selectedCountry(_ notification: Notification) {
        if let dictCountry = notification.object as? CountryModel {
            if let dictUser = notification.userInfo as? NSDictionary {
                if let type = dictUser["Name"] as? String {
                    objSearchPDVW.countryID = dictCountry.id ?? 0
                    let indexpath = IndexPath(row:2, section: 0)
                    let cell = tblVwSearch.cellForRow(at: indexpath) as! SearchProgramDetailTVC
                    cell.txtFldAns.text = dictCountry.name!
                }
            }
        }
    }
    //MARK:- Actions
    
    @IBAction func actionBack(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func actionNext(_ sender: Any) {
        objSearchPDVW.arrBasicQuest.removeAllObjects()
        if checkTextFeildValues() {
            if objSearchPDVW.arrCreateRPModel[0].createdBy == KAppDelegate.objUserDetailModel.idUser{
                let objVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchProgramQuesAnsVC") as! SearchProgramQuesAnsVC
                objVC.searchPrrogQuesAnsVMObj.dailyPicSub = "\(self.objSearchPDVW.arrCreateRPModel[0].pictureSubmission!)"
                objVC.searchPrrogQuesAnsVMObj.researchId = self.objSearchPDVW.arrCreateRPModel[0].id!
                self.navigationController?.pushViewController(objVC, animated: true)
            } else {
            if objSearchPDVW.arrCreateRPModel[0].basicQuestSubmitted{
                let objVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchProgramQuesAnsVC") as! SearchProgramQuesAnsVC
                objVC.searchPrrogQuesAnsVMObj.dailyPicSub = "\(self.objSearchPDVW.arrCreateRPModel[0].pictureSubmission!)"
                objVC.searchPrrogQuesAnsVMObj.researchId = objSearchPDVW.arrCreateRPModel[0].id!
                self.navigationController?.pushViewController(objVC, animated: true)
            }else{
            //MARK : JSONSerialization
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: objSearchPDVW.arrBasicQuest, options: JSONSerialization.WritingOptions.prettyPrinted)
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    objSearchPDVW.finalString = JSONString
                }
            } catch {
                Proxy.shared.displayStatusCodeAlert(error as! String)
            }
                
            let param = [   "question" : objSearchPDVW.finalString,
                            "research_id" : objSearchPDVW.arrCreateRPModel[0].id!   ] as [String:AnyObject]
            let dict = NSMutableDictionary()
            dict.setValue(param, forKey: "BasicQuestion")
                
                objSearchPDVW.setViewForResearch( {(remainingDays) in
                    // INCASE IF USER CLICK ON BACK BUTTON THEN WE HAVE REMOVED TO REMOVE THE BASIC QUESTION
                    self.objSearchPDVW.arrCreateRPModel[0].basicQuestSubmitted = true
                    self.objSearchPDVW.createQuesArr = []
                    self.tblVwSearch.reloadData()
                    
                    if remainingDays != "0"{
                        let message = "You have missed \(remainingDays) day's survey's till now, Do you want to attend the survey or skip to the current day survey ?"
                        Proxy.shared.alertControl(title: TitleValue.UNATTENDEDSURVEY, message: message){ (alertController, boolVal) in
                            if boolVal == "true"{
                                let objVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchProgramQuesAnsVC") as! SearchProgramQuesAnsVC
                                objVC.searchPrrogQuesAnsVMObj.remainingDay = "\(remainingDays)"
                                 objVC.searchPrrogQuesAnsVMObj.dailyPicSub = "\(self.objSearchPDVW.arrCreateRPModel[0].pictureSubmission!)"
                                
                                objVC.searchPrrogQuesAnsVMObj.researchId = self.objSearchPDVW.arrCreateRPModel[0].id!
                                self.navigationController?.pushViewController(objVC, animated: true)
                            } else if boolVal == "false"{
                                let objVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchProgramQuesAnsVC") as! SearchProgramQuesAnsVC
                                objVC.searchPrrogQuesAnsVMObj.dailyPicSub = "\(self.objSearchPDVW.arrCreateRPModel[0].pictureSubmission!)"
                                objVC.searchPrrogQuesAnsVMObj.researchId = self.objSearchPDVW.arrCreateRPModel[0].id!
                                self.navigationController?.pushViewController(objVC, animated: true)
                            } else {
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                } else {
                    let objVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchProgramQuesAnsVC") as! SearchProgramQuesAnsVC
                         objVC.searchPrrogQuesAnsVMObj.dailyPicSub = "\(self.objSearchPDVW.arrCreateRPModel[0].pictureSubmission!)"
                    objVC.searchPrrogQuesAnsVMObj.researchId = self.objSearchPDVW.arrCreateRPModel[0].id!
                    self.navigationController?.pushViewController(objVC, animated: true)
                }
            })
        }
    }
    }
}
}

