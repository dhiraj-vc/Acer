
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

class PatientDetailVM: NSObject {
    var patientID = Int()
    
    // MARK: Get Patient List Api
    func getPatientDet(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KGetPatientDet)\(patientID)", showIndicator: true) { (response) in
            if response.success{
                if let responsedict =  response.data {
                    if let dictData = responsedict["details"] as? NSDictionary{
                        KAppDelegate.patientDet.getPatientDet(dictData)
                    }
                }
                completion()
            } else {
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
        }
    }
}
extension PatientDetialVC: UITableViewDataSource,UITableViewDelegate {
    
    // MARK: Table Deleagtes and Data sources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KAppDelegate.patientDet.arrAppointments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"PatientDetialTVC" , for: indexPath) as! PatientDetialTVC
        let dictAppointment = KAppDelegate.patientDet.arrAppointments[indexPath.row]
        cell.lblAppointmentDate.text = Proxy.shared.changeDateFormat(dictAppointment.dateForAppointment!, oldFormat: "yyyy-MM-dd HH:mm:ss", dateFormat: "dd MMM, yyyy hh:mm a")
        let stateApp = dictAppointment.stateId
        switch dictAppointment.stateId {
        case AppointmentState.InActive.rawValue:
            cell.btnNew.setTitle("Cancelled", for: .normal)
        case AppointmentState.Active.rawValue:
            cell.btnNew.setTitle("Scheduled", for: .normal)
        case AppointmentState.Pending.rawValue:
            cell.btnNew.setTitle("Pending", for: .normal)
        case AppointmentState.Complete.rawValue:
            cell.btnNew.setTitle("Complete", for: .normal)
        default:
            cell.btnNew.setTitle("New", for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}
extension PatientDetialVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    // MARK: CollectionView Deleagtes and Data sources
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return KAppDelegate.patientDet.arrReport.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collVWReportsUpload.dequeueReusableCell(withReuseIdentifier:"PatientDetialCVC" , for: indexPath) as! PatientDetialCVC
        let dictData = KAppDelegate.patientDet.arrReport[indexPath.row]
        cell.imgReports.sd_setImage(with: URL.init(string:dictData.imageFile!), placeholderImage:UIImage(named: "ic_profile-1"), completed: nil)
        cell.btnImgPreview.tag = indexPath.row
        cell.btnImgPreview.addTarget(self, action: #selector(btnPreviewImage(_:)), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.size.height)
    }
    
    //MARK:- Preview Full Image
    @objc func btnPreviewImage(_ sender: UIButton) {
        let index = IndexPath(item: sender.tag, section: 0)
        let dictData = KAppDelegate.patientDet.arrReport[sender.tag]
        let cell = collVWReportsUpload.cellForItem(at: index) as! PatientDetialCVC
        if cell.imgReports.image != nil {
            let imageInfo      = GSImageInfo(image: cell.imgReports.image!, imageMode: .aspectFit, imageHD: nil, imageID: "\(sender.tag)")
            let transitionInfo = GSTransitionInfo(fromView: cell.imgReports)
            let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            present(imageViewer, animated: true, completion: nil)
        }
        
    }
}

