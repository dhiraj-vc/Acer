
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
class ResearchOptionVC: UIViewController {
    //MARK : OUTLETS
    @IBOutlet weak var tblVwOptions: UITableView!
    @IBOutlet weak var cnstHeightTblVw: NSLayoutConstraint!
    var objResearchOptionVM = ResearchOptionVM()
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if objResearchOptionVM.cameFrom == "Shared Survey"{
            objResearchOptionVM.arrOptions.remove(at: 0)
         }
        tblVwOptions.reloadData()
        cnstHeightTblVw.constant = tblVwOptions.contentSize.height
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true) {
           
        }
    }
}

 
