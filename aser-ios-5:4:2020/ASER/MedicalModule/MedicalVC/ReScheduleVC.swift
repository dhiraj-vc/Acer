
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
protocol ResheduleDet {
    func rescheduleDetails(_ dateVal: String, indexVal:Int)
}
var reSheduleDetail:ResheduleDet?

class ReScheduleVC: UIViewController, UITextFieldDelegate {
    //MARK:- Outlets
    @IBOutlet weak var txtFldDate: UITextField!
    @IBOutlet weak var txtFldTime: UITextField!
    var timeDatePicker = UIDatePicker()
    var indexVal = Int()
    //Mark: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFldDate.inputView = timeDatePicker
        txtFldTime.inputView = timeDatePicker
    }
    
    //MARK:- Actions
    @IBAction func btnReShedule(_ sender: UIButton) {
        self.dismiss(animated: true) {
            let dateTime = "\(self.txtFldDate.text!) \(self.txtFldTime.text!)"
            reSheduleDetail!.rescheduleDetails(dateTime, indexVal: self.indexVal)
        }
    }
    @IBAction func btnActionCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- TestFieldDelegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFldDate {
            txtFldDate.goToNextTextFeild(nextTextFeild: txtFldTime)
        } else {
            txtFldTime.resignFirstResponder()
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            timeDatePicker.datePickerMode = .date
            timeDatePicker.minimumDate =  Date()
            timeDatePicker.tag = 1
            txtFldDate.text = Proxy.shared.getStringFrmDate(getDate:timeDatePicker.date, format: "d MMM, yyyy")
            timeDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        case 2:
            timeDatePicker.datePickerMode = .time
            timeDatePicker.tag = 2
            txtFldTime.text =  Proxy.shared.getStringFrmDate(getDate: timeDatePicker.date, format: "hh mm a")
            timeDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        default:
            break
        }
        return true
    }
    
    //MARK:- Handle selected Date Methods
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        if sender.tag == 1 {
            txtFldDate.text = Proxy.shared.getStringFrmDate(getDate: sender.date, format: "d MMM, yyyy")
        } else if sender.tag == 2 {
            txtFldTime.text = Proxy.shared.getStringFrmDate(getDate: sender.date, format: "hh mm a")
        }
    }
}
