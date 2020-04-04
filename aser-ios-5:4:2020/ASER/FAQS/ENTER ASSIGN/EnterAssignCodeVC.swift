
//
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
class EnterAssignCodeVC: UIViewController {
    //MARK : OUTLETS
    @IBOutlet weak var txtFldEnteredCode: UITextField!
    var objEnterAssignCodeVM = EnterAssignCodeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFldEnteredCode.setLeftPaddingPoints(10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.title == "View Survey"{
            objEnterAssignCodeVM.urlString = "\(Apis.KEnterAssignCode)?readonly=true"
        }else{
            objEnterAssignCodeVM.urlString = "\(Apis.KEnterAssignCode)"
        }
        
    }
    //MARK : ACTIONS
    @IBAction func actionSubmit(_ sender: UIButton) {
        if txtFldEnteredCode.isBlank{
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.ENTERASSIGNCODE)
        }else{
            objEnterAssignCodeVM.submitAssignCode(txtFldEnteredCode.text!) { (response) in
                self.dismiss(animated: true, completion: {
                    if response.success{
                        Proxy.shared.displayStatusCodeAlert("Assign Code Submitted Successfully")
                        NotificationCenter.default.post(name: NSNotification.Name("assignCode"), object: response.data, userInfo: nil)                   
                    }else{
                        Proxy.shared.displayStatusCodeAlert(response.message!)
                    }
                })
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true) {
            //MARK: ACTION
        }
    }
}
