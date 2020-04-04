//
//  CreateResProgVM.swift
//  ASER
//
//  Created by Desh Raj on 26/09/18.
//  Copyright © 2018 Priti Sharma. All rights reserved.
//

import UIKit

class CreateResProgVM {
    var cameFrom = ""
    var createResearchArr = ["Assign Code", "Company Name" , "Product Name" , "Duration of Research", "Picture Submission"]
    var arrForTextValues = NSMutableArray()
    var dictForTextValues = NSMutableDictionary()
}
extension CreateResProgVC:UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    //MARK:-->TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return createResProgVMObj.createResearchArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVwCretareResearch.dequeueReusableCell(withIdentifier: "CreateResearchTVC", for: indexPath) as! CreateResearchTVC
        cell.lblAssignCode.text     = createResProgVMObj.createResearchArr[indexPath.row]
        cell.txtFldName.delegate    = self
        cell.txtFldName.placeholder = (indexPath.row == 4) ? "Yes or No" : "Enter \(createResProgVMObj.createResearchArr[indexPath.row])"
        cell.txtFldName.tag         =  indexPath.row
        createResProgVMObj.dictForTextValues.setValue("", forKey: createResProgVMObj.createResearchArr[indexPath.row])
        return cell
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 4 {
            textField.inputView = pickerForBool
        }
        if textField.tag == 3 {
            textField.keyboardType = .numberPad
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        for i in 0..<createResProgVMObj.createResearchArr.count {
            if textField.tag == i && textField.isBlank != true {
                createResProgVMObj.dictForTextValues.setValue(textField.text, forKey: "\(createResProgVMObj.createResearchArr[i])")
            }
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
        let indexpathForEmail = IndexPath(row: 4, section: 0)
        let cell = tblVwCretareResearch.cellForRow(at: indexpathForEmail) as! CreateResearchTVC
        cell.txtFldName.text = boolVal
    }
}
