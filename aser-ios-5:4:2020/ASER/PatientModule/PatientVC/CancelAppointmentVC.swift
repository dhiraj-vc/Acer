
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

class CancelAppointmentVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var txtViewReason: UITextView!
    var patientId = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK:- Actions
    @IBAction func btnCancel(_ sender: UIButton) {
        if txtViewReason.isBlank == false {
        let param = ["ChatMessage[message]":txtViewReason.text,
                     "ChatMessage[to_user_id]": patientId] as [String:AnyObject]
        sendMessages(param) {
            self.dismiss(animated: true, completion: nil)
        }
        } else {
         self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func btnCross(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- Send Message API
    func sendMessages(_ params:[String : AnyObject], completion:@escaping() -> Void){
        WebServiceProxy.shared.postData("\(Apis.KSendMsg)", params: params, showIndicator: false) { (response) in
            if response.success{
                completion()
            }else{
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
        }
    }
    
}
