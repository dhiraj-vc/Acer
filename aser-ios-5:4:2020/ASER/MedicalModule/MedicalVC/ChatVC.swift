
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
class ChatVC: UIViewController {
    
    // Mark: - Outlets
    @IBOutlet weak var tblVwChatVC: UITableView!
    @IBOutlet weak var txtViewMsgs: UITextView!
    @IBOutlet weak var cnstBottom: NSLayoutConstraint!
    @IBOutlet weak var btnBookAppointment: UIButton!
    @IBOutlet weak var btnEmCall: UIButton!
    @IBOutlet weak var cnstWidthForBtn: NSLayoutConstraint!
    
    var objChatVM = ChatVM()

    //Mark: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue {
           btnBookAppointment.isHidden = false
             btnEmCall.isHidden = true
            cnstWidthForBtn.constant = 0.0
        } else {
           btnBookAppointment.isHidden = true
             btnEmCall.isHidden = false
            cnstWidthForBtn.constant = 44.0
        }
        
        self.objChatVM.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getNewMsgs), userInfo: nil, repeats: true)
        objChatVM.getChat {
            self.tblVwChatVC.reloadData()
            if self.objChatVM.arrChatList.count>0{
                self.scrollToBottom()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshChatList), name: NSNotification.Name("RefreshChatList"), object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtViewMsgs.resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.objChatVM.timer.invalidate()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
    }
    
    //MARK:- Actions
    @IBAction func btnBookAppointment(_ sender: Any) {
        let bookVC = mainStoryboard.instantiateViewController(withIdentifier: "BookAppointmentsVC") as! BookAppointmentsVC
        bookVC.objBookAppointmentsVM.patientId = "\(objChatVM.messageToId)"
        self.navigationController?.pushViewController(bookVC, animated: true)
    }
    @IBAction func btnEmergencyCall(_ sender: Any) {
        let phoneNo = AppInfo.EmergencyNo
        if let url = URL(string: "tel://\(phoneNo)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    @IBAction func btnActionBack(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    @IBAction func btnSendMsgs(_ sender: UIButton) {
        if txtViewMsgs.text != "" {
            sender.isUserInteractionEnabled = false
            let param = ["ChatMessage[message]":txtViewMsgs.text,
                         "ChatMessage[to_user_id]": objChatVM.messageToId] as [String:AnyObject]
            objChatVM.sendMessages(param) {
                self.tblVwChatVC.reloadData()
                self.txtViewMsgs.text = ""
//                self.txtViewMsgs.resignFirstResponder()
                self.scrollToBottom()
                sender.isUserInteractionEnabled = true
            }
        } else {
            Proxy.shared.displayStatusCodeAlert("Please write your message")
        }
    }
    @IBAction func btnCallAction(_ sender: UIButton) {
        if let url = URL(string: "tel://\(AppInfo.EmergencyNo)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    //MARK:- Custome methods.
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.objChatVM.arrChatList.count-1, section: 0)
            self.tblVwChatVC.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    @objc func getNewMsgs(){
        objChatVM.getNewChat {
            self.tblVwChatVC.reloadData()
            self.scrollToBottom()
        }
    }
    //MARK:- Handle Keyboard Method
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            cnstBottom.constant = keyboardHeight
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        cnstBottom.constant = 0
    }
    //MARK:- Handle Notification Method
    @objc func refreshChatList(){
        objChatVM.getChat {
            self.tblVwChatVC.reloadData()
            if self.objChatVM.arrChatList.count>0{
                self.scrollToBottom()
            }
        }
    }
}
