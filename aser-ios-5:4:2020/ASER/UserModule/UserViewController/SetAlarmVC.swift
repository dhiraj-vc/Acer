
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

class SetAlarmVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var txtFldTime: UITextField!
    var datePicker = UIDatePicker()
    var researchId  = Int()
    var Hour = String()
    var minutes = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .time
      }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- Actions
    @IBAction func btnSubmit(_ sender: UIButton) {
        if txtFldTime.isBlank {
           Proxy.shared.displayStatusCodeAlert(AlertMsgs.SelectTime)
        } else {
         let param = [ "Reminder[research_id]":  researchId,
                              "Reminder[hours]":  Hour,
                              "Reminder[minutes]":  minutes ] as [String:AnyObject]
                WebServiceProxy.shared.postData(Apis.KSetAlarm, params: param, showIndicator: true) { (ApiResponse) in
                    if ApiResponse.success {
                        Proxy.shared.displayStatusCodeAlert(AlertMsgs.AlarmSetSuccess)
                        self.dismiss(animated: true, completion: {
                           NotificationCenter.default.post(name: NSNotification.Name("AlarmSet"), object: true)
                        })
                     }
                    else{
                        Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
                    }
                }
            }
     }
    @objc func setTime(sender: UIDatePicker){
        let time = sender.date
        txtFldTime.text = Proxy.shared.changeDateFormat("\(time)", oldFormat: "yyyy-MM-dd HH:mm:ss z", dateFormat: "hh:mm a")
        Hour = Proxy.shared.changeDateFormat("\(time)", oldFormat: "yyyy-MM-dd HH:mm:ss z", dateFormat: "HH")
        minutes = Proxy.shared.changeDateFormat("\(time)", oldFormat: "yyyy-MM-dd HH:mm:ss z", dateFormat: "mm")
    }
}
extension SetAlarmVC : UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        txtFldTime.reloadInputViews()
        
        txtFldTime.inputView = datePicker
        datePicker.addTarget(self, action: #selector(setTime(sender:)), for: .valueChanged)
        return true
    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//    }
    
}
