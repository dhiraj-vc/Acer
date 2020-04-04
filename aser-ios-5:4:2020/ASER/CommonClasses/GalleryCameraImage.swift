//
//  GalleryCameraImage.swift
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
import Foundation
import AVFoundation
import CropViewController
protocol PassImageDelegate {
    func passSelectedimage(selectImage: UIImage)
}
var galleryCameraImageObj:PassImageDelegate?
class GalleryCameraImage: NSObject,UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate  {
    
    //MARK:- VARIABLE DECLARATION
    var ImagePicker = UIImagePickerController()
    var imageTapped = Int()
    var clickImage = UIImage()
    var currentController = UIViewController()
    var cropDisable = Bool()
    //Mark:- Choose Image Method
    func customActionSheet(_ deleteEnable:Bool, controller: UIViewController) {
        currentController = controller
        //Authorization for Camera permission
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            self.callCamera(deleteEnable: deleteEnable)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.callCamera(deleteEnable: deleteEnable)
                }else{
                    self.presentCameraSettings()
                }
            })
        }
    }
    
    func presentCameraSettings() {
        let alertController = UIAlertController(title: AlertMsgs.cammeraNotAccess, message: AlertMsgs.openSettingCamera, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: TitleValue.cancel, style: .default))
        alertController.addAction(UIAlertAction(title: TitleValue.setting, style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        })
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView =  currentController.view
                popoverController.sourceRect = CGRect(x: currentController.view.bounds.midX, y: currentController.view.bounds.midY, width: 0, height: 0)
            }
            currentController.present(alertController, animated: true, completion: nil)
        } else{
            currentController.present(alertController, animated: true, completion: nil)
        }
    }
    func callCamera(deleteEnable:Bool)  {
        let myActionSheet = UIAlertController()
        let deleteAction = UIAlertAction(title: TitleValue.deletePhoto, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.deleteProfileApi {
                NotificationCenter.default.post(name: NSNotification.Name("DeleteProfile"), object: nil)
            }
        })
        let galleryAction = UIAlertAction(title: TitleValue.choosePhoto, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallary()
        })
        let cameraAction = UIAlertAction(title: TitleValue.takePhoto, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openCamera()
        })
        
        let cancelAction = UIAlertAction(title: TitleValue.cancel, style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        if deleteEnable{
            myActionSheet.addAction(deleteAction)
        }
        myActionSheet.addAction(galleryAction)
        myActionSheet.addAction(cameraAction)
        myActionSheet.addAction(cancelAction)
        // FOR IPAD SUPPORT
        myActionSheet.popoverPresentationController?.sourceView = KAppDelegate.window?.rootViewController?.view
        myActionSheet.popoverPresentationController?.sourceRect = CGRect(x: (KAppDelegate.window?.rootViewController?.view.bounds.midX)!, y: (KAppDelegate.window?.rootViewController?.view.bounds.midY)!, width: 0, height: 0)
        
        self.currentController.present(myActionSheet, animated: true, completion: nil)
    }
    //MARK:- Open Image Camera
 
    
    
    func openCamera() {
        DispatchQueue.main.async {
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                self.ImagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.ImagePicker.delegate = self
                self.ImagePicker.allowsEditing = true
                self.currentController.present(self.ImagePicker, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: TitleValue.alert, message: AlertMsgs.cameraNotSupport, preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: TitleValue.ok, style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                self.currentController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK:- DeleteProfile Api Method
    func deleteProfileApi(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KRemoveProfile)", showIndicator: true) { (ApiResponse) in
            if ApiResponse.success {
                KAppDelegate.objUserDetailModel.profileImage = ""
                //Proxy.shared.displayStatusCodeAlert(json["message"] as? String ?? "message")
                completion()
            } else {
                Proxy.shared.displayStatusCodeAlert(ApiResponse.message!)
            }
        }
    }
    //MARK:- Open Image Gallery
    func openGallary() {
        ImagePicker.delegate = self
        ImagePicker.allowsEditing = true
        ImagePicker.sourceType = .photoLibrary
        self.currentController.present(ImagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            
            guard let objImagePick: UIImage = (info[.originalImage] as? UIImage) else{
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
//            let objImagePick: UIImage = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
            
        //    self.setSelectedimage(objImagePick)
            
            
            if self.cropDisable != true
            {
            let cropViewController = TOCropViewController(image: objImagePick)
            cropViewController.delegate = self
          self.currentController.present(cropViewController, animated: true, completion: nil)
            
            } else{
               self.setSelectedimage(objImagePick)
            }
            
 
}
        picker.dismiss(animated: true, completion: nil)
    }
 
//MARK:-CropViewController Delegate
    internal func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
    self.currentController.dismiss(animated: true, completion: nil)
    setSelectedimage(image)
  }
    //MARK:- Selectedimage
    func setSelectedimage(_ image: UIImage) {
       galleryCameraImageObj?.passSelectedimage(selectImage: image)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.currentController.dismiss(animated: true, completion: nil)
    }
}


