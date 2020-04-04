
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

class BookAppointmentsVM: NSObject {
    //var picker = UIPickerView()
    var timeDatePicker = UIDatePicker()
    var patientId = String()
    var imageArray = [UIImage]()
    let appObj = AppointmentModel()
    func bookAppointment(_ request: CreateAppointment.Request, completion:@escaping()-> Void ) {
        if isValidRequest(request) {
            let paramVal = NSMutableDictionary()
            let dateApp = Proxy.shared.changeDateFormat("\(request.date!) \(request.time!)", oldFormat: "d MMM, yyyy hh:mm a", dateFormat: "yyyy-MM-dd HH:mm:ss")
            var userId = String()
            if KAppDelegate.loginTypeVal == UserRole.Patient.rawValue {
                userId = "\(KAppDelegate.objUserDetailModel.doctorDet.doctorId)"
            } else {
                userId = "\(patientId)"
            }
            let param = [
                "Appointment[date]": dateApp as AnyObject,
                "Appointment[problems]": request.description as AnyObject,
                "Appointment[user_id]" : userId ] as [String:AnyObject]
            
            var paramImage = [String:UIImage]()
            if imageArray.count>0{
                for i in 0..<imageArray.count {
                    paramImage["Reports[file][\(i+1)]"] = imageArray[i]
                }
            }
            WebServiceProxy.shared.uploadImage(param, parametersImage: paramImage, addImageUrl: Apis.KCreateAppointment, showIndicator: true) { (response) in
                if response.success {
                    if let dictAppointment = response.data!["appointment"] as? NSDictionary {
                        self.appObj.getAppointmentDet(dictApp: dictAppointment)
                    }
                    Proxy.shared.displayStatusCodeAlert("Appointment Booked Successfully!")
                    completion()
                } else {
                    Proxy.shared.displayStatusCodeAlert(response.message!)
                }
            }
        }
    }
    func uploadReport(param : [String:AnyObject],imageData:[String:UIImage], completion: @escaping ResponseHandler) {
        WebServiceProxy.shared.uploadImage(param, parametersImage: imageData, addImageUrl: "\(Apis.KAddReport)", showIndicator: true) { (ApiResponse) in
            if ApiResponse.success{
                completion(ApiResponse)
            }else{
                Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
            }
        }
    }
    func isValidRequest(_ request: CreateAppointment.Request) -> Bool {
        if (request.date?.isBlank)!{
            Proxy.shared.displayStatusCodeAlert("Please select date")
            return false
        } else if (request.time?.isBlank)!{
            Proxy.shared.displayStatusCodeAlert("Please select time")
            return false
        } else if (request.description?.isBlank)!{
            Proxy.shared.displayStatusCodeAlert("Please enter illness symptoms")
            return false
        }
        return true
    }
}

extension BookAppointmentsVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            objBookAppointmentsVM.timeDatePicker.datePickerMode = .date
            objBookAppointmentsVM.timeDatePicker.minimumDate =  Date()
            objBookAppointmentsVM.timeDatePicker.tag = 1
            txtFldDate.text = Proxy.shared.getStringFrmDate(getDate: objBookAppointmentsVM.timeDatePicker.date, format: "d MMM, yyyy")
            objBookAppointmentsVM.timeDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        case 2:
            objBookAppointmentsVM.timeDatePicker.datePickerMode = .time
            objBookAppointmentsVM.timeDatePicker.tag = 2
            txtFldTime.text =  Proxy.shared.getStringFrmDate(getDate: objBookAppointmentsVM.timeDatePicker.date, format: "hh:mm a")
            objBookAppointmentsVM.timeDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        default:
            break
        }
        return true
    }
    
    //MARK:- Handle selected Date Methods
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        if sender.tag == 1 {
            txtFldDate.text = Proxy.shared.getStringFrmDate(getDate: sender.date, format: "d MMM, yyyy")
        } else if sender.tag == 2 {
            txtFldTime.text = Proxy.shared.getStringFrmDate(getDate: sender.date, format: "hh mm a")
        }
    }
}
extension BookAppointmentsVC: UICollectionViewDataSource, UICollectionViewDelegate, PassImageDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objBookAppointmentsVM.imageArray.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCVC", for: indexPath) as! GalleryCVC
        if indexPath.row == 0 {
            cell.btnDeleteImg.isHidden = true
            cell.imgVwGallery.image = UIImage(named:"ic_camera_upload")
        } else {
            cell.btnDeleteImg.isHidden = false
            let image = objBookAppointmentsVM.imageArray[indexPath.row-1]
            cell.imgVwGallery.image =  image
        }
        cell.btnPreviewImage.tag = indexPath.row
        cell.btnDeleteImg.tag = indexPath.row
        cell.btnDeleteImg.addTarget(self, action: #selector(removeImg(sender:)), for: .touchUpInside)
        cell.btnPreviewImage.addTarget(self, action: #selector(previewImage(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func previewImage(sender:UIButton){
        if sender.tag != 0 {
            let index = IndexPath(item: sender.tag, section: 0)
            //      let dictData = galleryVMObj.arrGalleryModel[sender.tag]
            let cell = clcViewReports.cellForItem(at: index) as! GalleryCVC
            if cell.imgVwGallery.image != nil {
                let imageInfo      = GSImageInfo(image: cell.imgVwGallery.image!, imageMode: .aspectFit, imageHD: nil, imageID: "\(sender.tag)")
                let transitionInfo = GSTransitionInfo(fromView: cell.imgVwGallery)
                let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                present(imageViewer, animated: true, completion: nil)
            }
        } else {
            
            let storyBoard =  UIStoryboard(name: "User", bundle: Bundle.main)
            
            let chatVC = storyBoard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
            self.navigationController?.pushViewController(chatVC, animated: false)
        }
    }
    @objc func removeImg(sender:UIButton){
        let index = sender.tag-1
        objBookAppointmentsVM.imageArray.remove(at: index)
        clcViewReports.reloadData()
    }
    func passSelectedimage(selectImage: UIImage) {
        objBookAppointmentsVM.imageArray.append(selectImage)
        clcViewReports.reloadData()
    }
    
}
