
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

class BookAppointmentsVC: UIViewController{
    //MARK : OUTLETS
    @IBOutlet weak var txtFldDate: UITextField!
    @IBOutlet weak var txtFldTime: UITextField!
    @IBOutlet weak var txtVwDescp: UITextView!
    @IBOutlet weak var clcViewReports: UICollectionView!
    @IBOutlet weak var viewForReports: UIView!
    @IBOutlet weak var cnstHeightForView: NSLayoutConstraint!
    
    var cameraClass = GalleryCameraImage()
    var objBookAppointmentsVM = BookAppointmentsVM()
    
    //Mark: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFldDate.inputView = objBookAppointmentsVM.timeDatePicker
        txtFldTime.inputView = objBookAppointmentsVM.timeDatePicker
        galleryCameraImageObj = self
        if KAppDelegate.loginTypeVal == UserRole.Medical.rawValue {
            viewForReports.isHidden =  true
            cnstHeightForView.constant = 0.0
        } else {
            viewForReports.isHidden =  false
            cnstHeightForView.constant = 122.0
        }
    }
    
    @IBAction func actionBookAppointment(_ sender: UIButton) {
        objBookAppointmentsVM.bookAppointment(setRequest()) {
            self.txtFldDate.text = ""
            self.txtFldTime.text = ""
            self.txtVwDescp.text = ""
            self.setRequest()
            Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
        }
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    func setRequest()-> CreateAppointment.Request {
        let request = CreateAppointment.Request(date: txtFldDate.text, time: txtFldTime.text, description: txtVwDescp.text )
        return request
    }
}

enum CreateAppointment{
    struct Request {
        let date: String?
        let time : String?
        let description: String?
    }
}
