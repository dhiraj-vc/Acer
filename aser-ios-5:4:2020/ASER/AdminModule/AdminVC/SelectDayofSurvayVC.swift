
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
class SelectDayofSurvayVC: UIViewController , UITableViewDataSource, UITableViewDelegate {
    //MARK:- Outlets
    @IBOutlet weak var tblDaysList: UITableView!
    var duration = 11
    var isDaily = Bool()
    var selectedCureentArr = NSMutableArray()
    var selectedArr = NSArray()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedArr.count>0 {
            if selectedArr.count == duration {
                selectedCureentArr.add(0)
            }
            for i in 0..<selectedArr.count{
                let index = Int(selectedArr[i] as! String)
                selectedCureentArr.add(index)
            }
            tblDaysList.reloadData()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Actions
    @IBAction func btnCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnOk(_ sender: UIButton) {
        self.dismiss(animated: true) {
            let selectionType = ["Type": self.isDaily] as [String : Any]
            NotificationCenter.default.post(name: NSNotification.Name("SelectedDays"), object: self.selectedCureentArr, userInfo: selectionType)
        }
    }
    
    //MARK:- TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return duration+1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyDaysTVC") as! SurveyDaysTVC
        cell.lblDay.text = (indexPath.row == 0) ? "Daily" : "Day \(indexPath.row)"
        cell.imgViewStatus.image = (selectedCureentArr.contains(indexPath.row)) ? UIImage(named: "ic_chk") : UIImage(named: "ic_unchk")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            if isDaily{
                isDaily = false
                selectedCureentArr.removeAllObjects()
            } else {
                isDaily = true
                for i in 0..<duration+1
                {
                    if selectedCureentArr.contains(i) == false {
                        selectedCureentArr.add(i)
                    }
                }
            }
        }else{
            if selectedCureentArr.contains(indexPath.row)
            {
                selectedCureentArr.remove(indexPath.row)
            }else {
                selectedCureentArr.add(indexPath.row)
            }
        }
        tblDaysList.reloadData()
    }
}
