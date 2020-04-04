
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

class UserSurveyQuestionVM: NSObject {
    var numberOfQues = 1
    var pickerView = UIPickerView()
    enum PickerType{
        case picture
        case choice
    }
    var isEditProgram = String()
    var selectedIndex = Int()
    var selectedPicker = PickerType.picture
    var researchId = Int()
    var arrSurveyQuestModel = [SurveyQuestModel]()
    var arrForQyestionType = ["No Option","Multiple Options","Choose One","Write Answer"]
    
    func getUpdateReserachData(_ completion:@escaping() -> Void ){
        WebServiceProxy.shared.getData("\(Apis.KUpdateResearch)\(researchId)", showIndicator: true) { (ApiResponse) in
            if ApiResponse.success{
                self.arrSurveyQuestModel = []
                if let jsonDict = ApiResponse.data {
                    if let researchArray = jsonDict["questions"] as? NSArray {
                        if researchArray.count>0 {
                            for i in 0..<researchArray.count {
                                if let dictQuest = researchArray[i] as? NSDictionary {
                                    let objSurvayModel = SurveyQuestModel()
                                    objSurvayModel.getQuestionList(dictData: dictQuest)
                                    self.arrSurveyQuestModel.append(objSurvayModel)
                                }
                            }
                        }
                    }
                }
                completion()
            }else{
                KAppDelegate.arrForQuestion.removeAllObjects()
                Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
            }
        }
    }
    
    func addSurvayQuestion(param : [String:AnyObject],completion: @escaping ResponseHandler){
        WebServiceProxy.shared.postData("\(Apis.KAddUserResearch)", params: param, showIndicator: true)  { (ApiResponse) in
            completion(ApiResponse)
            //            \(Proxy.shared.authNil())
        }
    }
    func editSurvayQuestion(param : [String:AnyObject],completion: @escaping ResponseHandler){
        WebServiceProxy.shared.postData("\(Apis.KEditSurveyQuestion)\(researchId)&access-token=\(Proxy.shared.authNil())", params: param, showIndicator: true)  { (ApiResponse) in
            completion(ApiResponse)
        }
    }
    func handelAddResponse(_ response:ApiResponse,view:UIViewController){
        if response.success {
            Proxy.shared.pushToNextVC(identifier:"UserHomeVC", isAnimate: false, currentViewController: view)
            KAppDelegate.arrForQuestion.removeAllObjects()
            Proxy.shared.displayStatusCodeAlert("Research Program created successfully")
        } else{
            Proxy.shared.displayStatusCodeAlert(response.message!)
        }
    }
}
extension UserSurveyQuestionVC :UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    //MARK:-->TABLE VIEW DELEGATE
    func numberOfSections(in tableView: UITableView) -> Int {
        return KAppDelegate.arrForQuestion.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dict = KAppDelegate.arrForQuestion[section] as? NSDictionary {
            let arrOptions = dict["option"] as! NSMutableArray
            return arrOptions.count
        } else {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblvw.dequeueReusableCell(withIdentifier: "AddSureveyOptTVC", for: indexPath) as! AddSureveyOptTVC
        
        cell.txtFldOtpionTitle.tag = 10000*indexPath.section+indexPath.row
        if let dict = KAppDelegate.arrForQuestion[indexPath.section] as? NSDictionary {
            let arrOptions = dict["option"] as! NSMutableArray
            let optionDict = arrOptions[indexPath.row] as! NSDictionary
            let questionType = dict[ "type_id"] as! String
            let optionAns = optionDict[ "ans"] as! String
            if questionType == "\(Options.MULTIPLE.rawValue)" {
                (optionAns == "1") ? cell.btnCorrectAnswer.setImage(UIImage(named:"ic_chk"), for: .normal) : cell.btnCorrectAnswer.setImage(UIImage(named:"ic_unchk"), for: .normal)
            } else {
                (optionAns == "1") ? cell.btnCorrectAnswer.setImage(UIImage(named:"ic_radio_selected"), for: .normal) : cell.btnCorrectAnswer.setImage(UIImage(named:"ic_radio_unselected"), for: .normal)
            }
            cell.txtFldOtpionTitle.text = optionDict[ "title"] as! String
        } else {
            cell.txtFldOtpionTitle.text = ""
        }
        cell.txtFldOtpionTitle.isUserInteractionEnabled = false

        cell.txtFldOtpionTitle.delegate = self
        
        cell.removeOptions.tag = indexPath.section
        cell.removeOptions.indexPath = indexPath.row
        cell.removeOptions.isHidden = true
        
        if indexPath.row == 0
        {
            cell.optionLbl.isHidden = false

        }
        else
        {
            cell.optionLbl.isHidden = true

        }
        
    //    cell.removeOptions.addTarget(self, action: #selector(removeOptions(sender:)), for: .touchUpInside)
        cell.btnCorrectAnswer.tag = indexPath.section
        cell.btnCorrectAnswer.indexPath = indexPath.row
        cell.btnCorrectAnswer.addTarget(self, action: #selector(ansForOptions(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "SurveyQuestionTVC") as! SurveyQuestionTVC
        headerView.txtFldTimeline.tag = section
        headerView.txtFldQuestion.tag = section
        if let dict = KAppDelegate.arrForQuestion[section] as? NSDictionary {
            if let stringDays = dict["day"] as? String {
                if stringDays != "" {
                    let str = stringDays
                    let arrayDays = str.components(separatedBy: ",")
                    if arrayDays.count == Int(KAppDelegate.addSurveyQuestionModel.duration!) {
                        headerView.txtFldTimeline.text = "Daily"
                    } else {
                        headerView.txtFldTimeline.text = dict["day"] as? String
                    }
                }
            }
            
            headerView.txtFldQuestion.text = dict["question"] as? String
//            let quesType = dict[ "type_id"] as? String
//            switch quesType {
//            case "\(Options.NO_OPTION.rawValue)" :
//                headerView.txtFldOptions.text = "No Options"
//            case "\(Options.MULTIPLE.rawValue)" :
//                headerView.txtFldOptions.text = "Multiple Options"
//            case "\(Options.CHOOSE_ONE.rawValue)":
//                headerView.txtFldOptions.text = "Choose One"
//            case "\(Options.TYPE_ANS.rawValue)":
//                headerView.txtFldOptions.text = "Write Answer"
//            default:
//                headerView.txtFldOptions.text = "No Options"
//            }
//            switch dict[ "picture_submission"] as? String {
//            case "0" :
//                headerView.txtFldPictureSubmission.text = "No"
//            case "1":
//                headerView.txtFldPictureSubmission.text = "Yes"
//            default:
//                headerView.txtFldPictureSubmission.text = ""
//            }
        }
        
        
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: self.view.frame.height)
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 80)
        view.addSubview(headerView)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableCell(withIdentifier: "RemoveQuestionTVC") as! RemoveQuestionTVC
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60)
        
        footerView.btnRemoveQues.tag = section
        footerView.btnRemoveQues.addTarget(self, action: #selector(removeQuestionnaire(sender:)), for: .touchUpInside)
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: self.view.frame.height)
        view.addSubview(footerView)
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    //MARK:- Text Field Delegtaes methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        surveyVMObj.pickerView.dataSource = self
        surveyVMObj.pickerView.delegate = self
        switch textField.placeholder {
        case "2,3,4 (Daily)":
            textField.resignFirstResponder()
            let dict = KAppDelegate.arrForQuestion[textField.tag] as! NSMutableDictionary
            surveyVMObj.selectedIndex =  textField.tag
            let presentControllerObj = mainStoryboard.instantiateViewController(withIdentifier: "SelectDayofSurvayVC") as! SelectDayofSurvayVC
            if let stringDays = dict["day"] as? String {
                let str = stringDays
                if str.isEmpty != true{
                    let arrayDays = str.components(separatedBy: ",")
                    presentControllerObj.selectedArr = arrayDays as NSArray
                }
            }
            presentControllerObj.duration = Int(KAppDelegate.addSurveyQuestionModel.duration!)!
            self.present(presentControllerObj, animated: true, completion: nil)
            return false
        case "Yes or No":
            let dict = KAppDelegate.arrForQuestion[textField.tag] as! NSMutableDictionary
            surveyVMObj.pickerView.tag = textField.tag
            surveyVMObj.selectedPicker = .picture
            textField.inputView = surveyVMObj.pickerView
            if (textField.isBlank) {
                dict.setValue("1", forKey:  "picture_submission")
                textField.text = "Yes"
            }
        case "Choose One":
            let dict = KAppDelegate.arrForQuestion[textField.tag] as! NSMutableDictionary
            surveyVMObj.pickerView.tag = textField.tag
            surveyVMObj.selectedPicker = .choice
            textField.inputView = surveyVMObj.pickerView
            if (textField.isBlank) {
                textField.text = "No Option"
                dict.setValue("0", forKey:  "type_id")
            }
        case "Option" :
            self.view.endEditing(true)
        default:
            break
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.placeholder {
        case "ie. What you like?":
            let dict = KAppDelegate.arrForQuestion[textField.tag] as! NSMutableDictionary
            dict.setValue(textField.text, forKey: "question")
            tblvw.reloadSections([textField.tag], with: .automatic)
        case "Option" :
            let secVal = textField.tag/10000
            let rowVal = textField.tag%10000
            let dict = KAppDelegate.arrForQuestion[secVal] as! NSMutableDictionary
            let arrOptions = dict["option"] as! NSMutableArray
            if arrOptions.count>0{
                let dict = arrOptions[rowVal] as! NSMutableDictionary
                dict.setValue(textField.text!, forKey:  "title")
            }
            tblvw.reloadSections([secVal], with: .automatic)
        default:
            break
        }
    }
    //MARK:- PickerView Delegates methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch surveyVMObj.selectedPicker {
        case .picture:
            return 2
        case .choice:
            return surveyVMObj.arrForQyestionType.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch surveyVMObj.selectedPicker {
        case .picture:
            return (row == 0) ? "Yes" : "No"
        case .choice:
            return surveyVMObj.arrForQyestionType[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dict = KAppDelegate.arrForQuestion[pickerView.tag] as! NSMutableDictionary
        switch surveyVMObj.selectedPicker {
        case .picture:
            dict.setValue((row == 0) ? "1" : "0", forKey:  "picture_submission")
        case .choice:
            if row == 1 || row == 2 {
                if let arrOptions = dict["option"] as? NSMutableArray {
                    arrOptions.removeAllObjects()
                }
                setQuestionOption(tagValue: pickerView.tag)
            } else {
                unsetQuestionOption(tagValue: pickerView.tag)
            }
            dict.setValue("\(row)", forKey:  "type_id")
        }
        tblvw.reloadSections([pickerView.tag], with: .automatic)
    }
    //MARK:- Actions for button in footer view
    @objc func removeQuestionnaire(sender:UIButton){
        self.view.endEditing(true)
        KAppDelegate.arrForQuestion.removeObject(at: sender.tag)
        tblvw.reloadData()
        
    }
    @objc func addOptions(sender:UIButton){
        setQuestionOption(tagValue: sender.tag)
    }
    func setQuestionOption(tagValue:Int){
        let dictOptions = NSMutableDictionary()
        dictOptions.setValue("", forKey:  "title")
        dictOptions.setValue("0", forKey:  "ans")
        if let dict = KAppDelegate.arrForQuestion[tagValue] as? NSDictionary {
            let arrOptions = dict["option"] as! NSMutableArray
            arrOptions.add(dictOptions)
        }
        tblvw.reloadSections([tagValue], with: .automatic)
    }
    func unsetQuestionOption(tagValue:Int){
        if let dict = KAppDelegate.arrForQuestion[tagValue] as? NSDictionary {
            let arrOptions = dict["option"] as! NSMutableArray
            arrOptions.removeAllObjects()
        }
        tblvw.reloadSections([tagValue], with: .automatic)
    }
    @objc func removeOptions(sender:ButtonSubClass){
        if let dict = KAppDelegate.arrForQuestion[sender.tag] as? NSDictionary {
            let arrOptions = dict["option"] as! NSMutableArray
            arrOptions.removeObject(at:sender.indexPath!)
        }
        tblvw.reloadSections([sender.tag], with: .automatic)
    }
    @objc func ansForOptions(sender:ButtonSubClass){
        if let dict = KAppDelegate.arrForQuestion[sender.tag] as? NSDictionary {
            let arrOptions = dict["option"] as! NSMutableArray
            if arrOptions.count>0{
                let questionType = dict[ "type_id"] as! String
                if questionType == "\(Options.CHOOSE_ONE.rawValue)" {
                    for i in 0..<arrOptions.count {
                        let dictOpt = arrOptions[i] as! NSMutableDictionary
                        dictOpt.setValue("0", forKey:  "ans")
                    }
                }
                let dictOpt = arrOptions[sender.indexPath!] as! NSMutableDictionary
                (dictOpt[ "ans"] as! String != "1") ? dictOpt.setValue("1", forKey:  "ans") : dictOpt.setValue("0", forKey:  "ans")
            }
        }
        tblvw.reloadSections([sender.tag], with: .automatic)
    }
    //MARK:- CustomMethods
    func checkTextFeildValues() -> Bool {
        var boolValue = Bool()
        for i in 0..<KAppDelegate.arrForQuestion.count{
            let dictQuestion = KAppDelegate.arrForQuestion[i] as! NSMutableDictionary
            if dictQuestion["question"] as! String == "" {
                Proxy.shared.displayStatusCodeAlert("Please enter question text")
                boolValue = false
                break
            }
            else if dictQuestion["day"] as! String == "" {
                Proxy.shared.displayStatusCodeAlert("Please enter submission timeline")
                boolValue = false
                break
            }
            else if dictQuestion[ "picture_submission"] as! String == "" {
                Proxy.shared.displayStatusCodeAlert("Please enter picture submission")
                boolValue = false
                break
            }
            else if dictQuestion[ "type_id"] as! String == "" {
                Proxy.shared.displayStatusCodeAlert("Please enter question options")
                boolValue = false
                break
            }
            else if let arrOption = dictQuestion["option"] as? NSArray {
                if arrOption.count>0 {
                    //                    var ansVal = Bool()
                    for i in 0..<arrOption.count {
                        let dictOptions = arrOption[i] as! NSMutableDictionary
                        if dictOptions["title"] as! String == "" {
                            Proxy.shared.displayStatusCodeAlert("Please enter Option Title")
                            boolValue = false
                            break
                        } else {
                            if dictOptions["ans"] as! String == "1" {
                                boolValue = true
                                //                                ansVal = true
                                break
                            }else{
                                boolValue = true
                            }
                           
                        }
                    }
                    if boolValue == false{
                        break
                    }
                } else{
                    boolValue = true
                }
            } else {
                boolValue = true
            }
        }
        return boolValue
    }
    //MARK:- Add Questionnaire
    func setQuestionDict(){
        let arrOptions = NSMutableArray()
        let dictForQuestion = NSMutableDictionary()
        dictForQuestion.setValue("", forKey: "question")
        dictForQuestion.setValue("", forKey: "day")
        dictForQuestion.setValue("", forKey:  "picture_submission")
        dictForQuestion.setValue("0", forKey:  "type_id")
        dictForQuestion.setValue(arrOptions, forKey: "option")
        KAppDelegate.arrForQuestion.add(dictForQuestion)
        tblvw.reloadData()
    }
    func setDictForEdit(){
        if surveyVMObj.arrSurveyQuestModel.count>0 {
            for i in 0..<surveyVMObj.arrSurveyQuestModel.count {
                let dictForQuestion = NSMutableDictionary()
                if let dictQues = surveyVMObj.arrSurveyQuestModel[i] as? SurveyQuestModel {
                    dictForQuestion.setValue("\(dictQues.question!)", forKey: "question")
                    dictForQuestion.setValue("\(dictQues.day!)", forKey: "day")
                    dictForQuestion.setValue("\(dictQues.pictureSubmission!)", forKey:  "picture_submission")
                    dictForQuestion.setValue("\(dictQues.typeId!)", forKey:  "type_id")
                    let arrOptions = NSMutableArray()
                    if dictQues.arrOptionModel.count > 0 {
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
                        dictForQuestion.setValue(arrOptions, forKey: "option") //append Empty Array
                    }
                    KAppDelegate.arrForQuestion.add(dictForQuestion)
                }
                
            }
        }
        tblvw.reloadData()
    }
    //MARK:- Notification Methods
    @objc func selectedDays(_ notification: Notification) {
        let dict = KAppDelegate.arrForQuestion[surveyVMObj.selectedIndex] as! NSMutableDictionary
        var stringDays = String()
        if let arrDays = notification.object as? NSMutableArray {
            if arrDays.count == Int(KAppDelegate.addSurveyQuestionModel.duration!)!+1 {
                stringDays = Proxy.shared.arrToString(selectArr: arrDays)
                KAppDelegate.addSurveyQuestionModel.timeLine = "Daily"
            } else {
                stringDays = Proxy.shared.arrToString(selectArr: arrDays)
                KAppDelegate.addSurveyQuestionModel.timeLine = stringDays
            }
            dict.setValue(stringDays, forKey: "day")
            self.tblvw.reloadSections([surveyVMObj.selectedIndex], with: .none)
        }
    }
}
