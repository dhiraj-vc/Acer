
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

class ListOfPatientsVC: UIViewController {
    
    //Mark: Outlet
    @IBOutlet weak var tblVwListOfPatients: UITableView!
    //Mark: Varriable
    var objListOfPatientsVM = ListOfPatientsVM()
    
    //Mark: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblVwListOfPatients.register(UINib.init(nibName: "ListOfPatientsTVC", bundle: nil), forCellReuseIdentifier: "ListOfPatientsTVC")
        objListOfPatientsVM.getListOfPatients {
            if self.objListOfPatientsVM.arrPatients.count>0{
                self.tblVwListOfPatients.isHidden = false
                self.tblVwListOfPatients.reloadData()
            } else {
                self.tblVwListOfPatients.isHidden = true
            }
        }
        
    }
    //MARK:- Actions
    @IBAction func btnBackAction(_ sender: Any) {
        sideMenuViewController?._presentLeftMenuViewController()
    }
    
}
