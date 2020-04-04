
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

class UserAddResearchVM: NSObject {
    var pickerForBool       = UIPickerView()
    var selectDate = UIDatePicker()
    var startDate = Date()
    var endDate = Date()
    var objResearchDetailModel = ResearchDetailModel()
    var cameFrom = ""
    var isEditProgram = ""
    var selectedCat = String()
    var createResearchArr = ["Company Name", "Product Name", "Product Category", "Research Start Date", "Research End Date", "Daily Picture Submission"]
    var arrForTextValues = NSMutableArray()
    var dictForTextValues = NSMutableDictionary()
    var dictResearchProgram = NSMutableDictionary()
}
extension UserAddResearchVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    //MARK:-->TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return createResProgVMObj.createResearchArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVwCretareResearch.dequeueReusableCell(withIdentifier: "CreateResearchTVC", for: indexPath) as! CreateResearchTVC
        cell.lblAssignCode.text = createResProgVMObj.createResearchArr[indexPath.row]
        cell.txtFldName.delegate    = self
        cell.txtFldName.placeholder = (indexPath.row == 5) ? "Yes or No" : "Enter \(createResProgVMObj.createResearchArr[indexPath.row])"
        if indexPath.row == 2 && createResProgVMObj.selectedCat != ""
        { cell.txtFldName.text = createResProgVMObj.selectedCat}
        cell.txtFldName.tag         =  indexPath.row
        createResProgVMObj.dictForTextValues.setValue("", forKey: createResProgVMObj.createResearchArr[indexPath.row])

        return cell
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag
        {
        case 2 :
            let prodCatVC = mainStoryboard.instantiateViewController(withIdentifier: "SelectCounrtyVC") as! SelectCounrtyVC
            prodCatVC.selectCountryVMobj.selectionType = "ProductCat"
            self.navigationController?.present(prodCatVC, animated: true, completion: nil)
            
            return false
            
        case 3:
            textField.inputView = createResProgVMObj.selectDate
            createResProgVMObj.selectDate.minimumDate =  Date()
            textField.text = Proxy.shared.getStringFrmDate(getDate: createResProgVMObj.selectDate.date, format: "d MMM, yyyy")
            createResProgVMObj.selectDate.tag = textField.tag
            createResProgVMObj.selectDate.addTarget(self, action:  #selector(datePickerValueChanged(_:)), for:  UIControl.Event.valueChanged)
        case 4:
            textField.inputView = createResProgVMObj.selectDate
            createResProgVMObj.selectDate.minimumDate = createResProgVMObj.startDate
            textField.text = Proxy.shared.getStringFrmDate(getDate: createResProgVMObj.selectDate.date, format: "d MMM, yyyy")
            createResProgVMObj.selectDate.tag = textField.tag
            createResProgVMObj.selectDate.addTarget(self, action:  #selector(datePickerValueChanged(_:)), for:  UIControl.Event.valueChanged)
        case 5:
            textField.inputView = createResProgVMObj.pickerForBool
            textField.text = "Yes"
        default:
            break
        }
        return true
    }
    //MARK:- Handle selected Date Methods
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let indexpathForText = IndexPath(row: sender.tag, section: 0)
        let cell = tblVwCretareResearch.cellForRow(at: indexpathForText) as! CreateResearchTVC
        cell.txtFldName.text =  Proxy.shared.dateFormatinYDMHM(dateFormat: "d MMM, yyyy", date: sender.date)
        if sender.tag == 3 {
            createResProgVMObj.startDate = createResProgVMObj.selectDate.date
        } else {
            createResProgVMObj.endDate = createResProgVMObj.selectDate.date
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 3:
            let indexpath = NSIndexPath.init(row: 4, section: 0)
            let cell = tblVwCretareResearch.cellForRow(at: indexpath as IndexPath) as! CreateResearchTVC
            cell.txtFldName.text = ""
        default:
            break
        }
    }
    
    //MARK:- Picker view delegtaes for true false
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == 0 ? "Yes" : "No"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let boolVal = (row == 0) ? "Yes" : "No"
        createResProgVMObj.arrForTextValues.setValue(boolVal, forKey: "PictureSub")
        let indexpathForEmail = IndexPath(row: 5, section: 0)
        let cell = tblVwCretareResearch.cellForRow(at: indexpathForEmail) as! CreateResearchTVC
        cell.txtFldName.text = boolVal
    }
}
