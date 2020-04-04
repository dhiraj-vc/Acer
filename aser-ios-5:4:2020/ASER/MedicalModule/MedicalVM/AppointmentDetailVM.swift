
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

class AppointmentDetailVM: NSObject {
var appointmentDet = AppointmentModel()
}

extension AppointmentDetailVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objAppDetVM.appointmentDet.arrReports.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"PatientDetialCVC" , for: indexPath) as! PatientDetialCVC
        let dictData = objAppDetVM.appointmentDet.arrReports[indexPath.row]
        
       cell.imgReports.sd_setImage(with: URL(string:dictData.imageFile!), placeholderImage:UIImage(named: "ic_profile-1"), completed: nil)
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
        let dictData = objAppDetVM.appointmentDet.arrReports[sender.tag]
        let cell = clcViewReports.cellForItem(at: index) as! PatientDetialCVC
        if cell.imgReports.image != nil {
            let imageInfo      = GSImageInfo(image: cell.imgReports.image!, imageMode: .aspectFit, imageHD: nil, imageID: "\(sender.tag)")
            let transitionInfo = GSTransitionInfo(fromView: cell.imgReports)
            let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            present(imageViewer, animated: true, completion: nil)
        }
        
    }
    
}
