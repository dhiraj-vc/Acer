
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
class SelectCounrtyVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblViewList: UITableView!
    var selectCountryVMobj = SelectCountryVwModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = selectCountryVMobj.selectionType.isBlank ? "Select Country" : "Select \(selectCountryVMobj.selectionType)"
        selectCountryVMobj.getCountryList { (response) in
            self.selectCountryVMobj.handelReponseForCountryList(response, view: self)
            self.tblViewList.reloadData()
        }
    }
    //MARK:- Actions
    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
