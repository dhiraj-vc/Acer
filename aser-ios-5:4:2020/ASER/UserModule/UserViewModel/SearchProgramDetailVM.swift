
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
import UIKit
class SearchProgramDetailVM: NSObject {
    var countryID : Int?
    var researchID = Int()
    var pickerView = UIPickerView()
    enum PickerType : Int {
        case Age = 0, Gender
    }
    var selectedPicker = PickerType.Age
    var arrCreateRPModel = [CreateResearchProgramModel]()
//    var createQuesArr = ["Are you above 18?", "Your gender", "Your country", "Your Ethnicity(optional)"]
    var createQuesArr = NSArray()
    var finalString = String()
    var arrBasicQuest = NSMutableArray()
    var dictBasicQuest = [String:String]()
    
    func submitBasicQuestForFirstTime(_ param: Dictionary<String, AnyObject>?, completion:@escaping(_ remainingDays:String)->Void){
        WebServiceProxy.shared.postData("\(Apis.KSubmitBasicQuest)", params: param, showIndicator: true) { (response) in
            if response.success{
                var remainingDays = "0"
                if let dictData = response.data{
                    if let remaining_days = dictData["remaining_days"] as? String{
                            remainingDays = remaining_days
                    }else if let remaining_daysInt = dictData["remaining_days"] as? Int{
                        remainingDays = "\(remaining_daysInt)"
                    }
                }
                completion(remainingDays)
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }else{                
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
        }
    }
    func setViewForResearch(_ completion:@escaping(_ remainingDays:String)->Void){
        WebServiceProxy.shared.getData("\(Apis.KSetView)\(researchID)", showIndicator: true) { (response) in
            if response.success{
                var remainingDays = "0"
                if let dictData = response.data{
                    if let remaining_days = dictData["remaining_days"] as? String{
                        remainingDays = remaining_days
                    }else if let remaining_daysInt = dictData["remaining_days"] as? Int{
                        remainingDays = "\(remaining_daysInt)"
                    }
                }
                completion(remainingDays)
            }else{
                Proxy.shared.displayStatusCodeAlert("No result found")
            }
        }
    }
}

extension SearchProgramDetailVC:UITableViewDelegate,UITableViewDataSource{
    //MARK:-->TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objSearchPDVW.createQuesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVwSearch.dequeueReusableCell(withIdentifier: "SearchProgramDetailTVC") as! SearchProgramDetailTVC
         cell.lblQuesTitle.text = "\(indexPath.row+1) \(objSearchPDVW.createQuesArr[indexPath.row])"
        switch indexPath.row {
        case 0:
            cell.txtFldAns.placeholder = "Yes"
            cell.txtFldAns.rightImage(image: #imageLiteral(resourceName: "ic_dropdown"), imgW: 20, imgH: 10)
        case 1:
            cell.txtFldAns.placeholder = "Male"
            cell.txtFldAns.rightImage(image: #imageLiteral(resourceName: "ic_dropdown"), imgW: 20, imgH: 10)
        case 2:
            cell.txtFldAns.rightImage(image: #imageLiteral(resourceName: "ic_dropdown"), imgW: 20, imgH: 10)
        default:
            cell.txtFldAns.rightImage(image: UIImage.init(), imgW: 15, imgH: 15)
        }        
        cell.txtFldAns.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

extension SearchProgramDetailVC: UITextFieldDelegate {
    func presentView(selectedType:String, Id:Int = 0){
        let presentControllerObj = mainStoryboard.instantiateViewController(withIdentifier: "SelectCounrtyVC") as! SelectCounrtyVC
        presentControllerObj.selectCountryVMobj.Id = Id
        presentControllerObj.selectCountryVMobj.selectionType = selectedType
        self.present(presentControllerObj, animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        objSearchPDVW.pickerView.delegate = self
        objSearchPDVW.pickerView.dataSource = self
        objSearchPDVW.pickerView.reloadAllComponents()
        switch textField.tag {
        case 0 :
            objSearchPDVW.selectedPicker = .Age
            objSearchPDVW.pickerView.tag = textField.tag
            textField.inputView = objSearchPDVW.pickerView
        case 1:
            objSearchPDVW.selectedPicker = .Gender
            objSearchPDVW.pickerView.tag = textField.tag
            textField.inputView = objSearchPDVW.pickerView
        case 2:
            textField.resignFirstResponder()
            presentView(selectedType: "Country")
             return false
        default:
            break
        }
        return true
    }
}

extension SearchProgramDetailVC:  UIPickerViewDelegate, UIPickerViewDataSource {
    //MAKR:- PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch objSearchPDVW.selectedPicker  {
        case .Age :
            return StaticData.ArrBool.count
        case .Gender:
             return StaticData.GenderArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let indexpath = IndexPath(row: objSearchPDVW.pickerView.tag, section: 0)
        let cell = tblVwSearch.cellForRow(at: indexpath) as! SearchProgramDetailTVC
        switch objSearchPDVW.selectedPicker {
         case .Age :
            cell.txtFldAns.text! = (StaticData.ArrBool[row][0] as? String)!
            return StaticData.ArrBool[row][0] as? String
        case .Gender:
            cell.txtFldAns.text! = StaticData.GenderArray[row]
            return  StaticData.GenderArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let indexpath = IndexPath(row: objSearchPDVW.pickerView.tag, section: 0)
        let cell = tblVwSearch.cellForRow(at: indexpath) as! SearchProgramDetailTVC
        switch objSearchPDVW.selectedPicker {
        case .Age:
             cell.txtFldAns.text = StaticData.ArrBool[row][0] as? String
        case .Gender :
             cell.txtFldAns.text = StaticData.GenderArray[row]
        }
    }
    
    //MARK:- CustomMethods
    func checkTextFeildValues() -> Bool {
        var boolValue = Bool()
        //MARK IF BASIC QUESTION IS SUBMMITED OR NOT IF YES GO THROUGH VALIDATION ELSE RETURN TRUE
        if objSearchPDVW.createQuesArr.count>0{
            for i in 0..<objSearchPDVW.createQuesArr.count {
                 let indexpath = NSIndexPath.init(row: i, section: 0)
                //let indexpath = IndexPath(row: i, section: 0)
                
                let cell = tblVwSearch.cellForRow(at: indexpath as IndexPath) as! SearchProgramDetailTVC
                if (indexpath.row != 3) {
                    if (cell.txtFldAns.text!) == "" {
                        Proxy.shared.displayStatusCodeAlert("Please Enter \(objSearchPDVW.createQuesArr[i])")
                        boolValue = false
                        break
                    }
                }
                else {
                    boolValue = true
                }
                if (cell.txtFldAns.text!) != "" { //question":"Test string","answer"
                    objSearchPDVW.dictBasicQuest["question"] = "\(objSearchPDVW.createQuesArr[i])"
                    objSearchPDVW.dictBasicQuest[ "answer"] = cell.txtFldAns.text!
                    objSearchPDVW.arrBasicQuest.add(objSearchPDVW.dictBasicQuest)
                    objSearchPDVW.dictBasicQuest = [String:String]()
                }
            }
        }
        else{
             boolValue = true
            return boolValue
        }
        return boolValue
    }
}
