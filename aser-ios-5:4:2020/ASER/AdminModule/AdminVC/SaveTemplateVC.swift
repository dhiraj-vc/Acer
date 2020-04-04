
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

class SaveTemplateVC: UIViewController {
    //MARK:- Outlets and Variables
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var txtFldTitle: UITextField!
    
    var objSaveTempVM = SaveTemplateVM()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UserDefaults.standard.string(forKey: "ColorKey")
        if color == "Green"{
            
            saveBtn.setBackgroundImage(UIImage(named: "bar_green@2x.png"), for: UIControl.State.normal)
            cancelBtn.setBackgroundImage(UIImage(named: "bar_green@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Default"{
            
           saveBtn.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
            cancelBtn.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
            
        }else if color == "Black"{
            
            saveBtn.setBackgroundImage(UIImage(named: "bar_black@2x.png"), for: UIControl.State.normal)
            cancelBtn.setBackgroundImage(UIImage(named: "bar_black@2x.png"), for: UIControl.State.normal)
            
            
        }else if color == "Gold"{
            
           saveBtn.setBackgroundImage(UIImage(named: "bar_yellow@2x.png"), for: UIControl.State.normal)
            
            cancelBtn.setBackgroundImage(UIImage(named: "bar_yellow@2x.png"), for: UIControl.State.normal)
            
            
        }else if color == "Blue"{
            
          saveBtn.setBackgroundImage(UIImage(named: "bar_blue@2x.png"), for: UIControl.State.normal)
            
            cancelBtn.setBackgroundImage(UIImage(named: "bar_blue@2x.png"), for: UIControl.State.normal)
            
            
        }else if color == "Pink"{
            
           saveBtn.setBackgroundImage(UIImage(named: "bar_pink@2x.png"), for: UIControl.State.normal)
            cancelBtn.setBackgroundImage(UIImage(named: "bar_pink@2x.png"), for: UIControl.State.normal)
            
        }else if color == "Red"{
            
         saveBtn.setBackgroundImage(UIImage(named: "bar_red@2x.png"), for: UIControl.State.normal)
            cancelBtn.setBackgroundImage(UIImage(named: "bar_red@2x.png"), for: UIControl.State.normal)
            
        }else {
            saveBtn.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
            cancelBtn.setBackgroundImage(UIImage(named: "ic_btn"), for: UIControl.State.normal)
        }
    }
    //MARK:- Actions
    @IBAction func btnSaveTemplate(_ sender: UIButton) {
        if txtFldTitle.isBlank{
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.EnterTitle)
        } else if txtViewDescription.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.EnterDescription)
        } else {
            let param = [
                "Template[title]": txtFldTitle.text!,
                "Template[description]":"\(txtViewDescription.text!)"
                ] as [String:AnyObject]
            objSaveTempVM.saveTemplate(param: param) {
                Proxy.shared.displayStatusCodeAlert(AlertMsgs.TemplateSaved)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func btnCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
