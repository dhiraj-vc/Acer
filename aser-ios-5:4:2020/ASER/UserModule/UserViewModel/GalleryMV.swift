//
//  GalleryVm.swift
// Event Smart Ticketing
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
import Foundation
import UIKit

//import IQKeyboardManagerSwift
class GalleryVm: NSObject {
    var pageCount = 0
    var totalPageCount = 0
    var arrGalleryModel = [GalleryModel]()
     var deleteImgArray = NSMutableArray()
    func getUserGallery(_ completion:@escaping() -> Void){
        WebServiceProxy.shared.getData("\(Apis.KUserGallery)?page=\(pageCount)", showIndicator: true) { (response) in
            if response.success{
                if let responsedict =  response.data {
                    if let dictMeta = responsedict["_meta"] as? NSDictionary{
                        if let totalPages = dictMeta["pageCount"] as? Int {
                            self.totalPageCount = totalPages
                        }
                    }
                    if self.pageCount == 0 {
                        self.arrGalleryModel = []
                    }
                    if let resArrr = responsedict["list"] as? NSArray {
                        for i in 0..<resArrr.count{
                            if let dictData = resArrr[i] as? NSDictionary{
                                let objVM = GalleryModel()
                                objVM.getGallery(dictData)
                                self.arrGalleryModel.append(objVM)
                            }
                        }
                    }
                }
                completion()
            }
            else{
                if self.pageCount == 0{
                    Proxy.shared.displayStatusCodeAlert(response.message!)
                }
            }
        }
        
    }
}
extension GalleryVC: UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryVMObj.arrGalleryModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dictData = galleryVMObj.arrGalleryModel[indexPath.row]
        let cell = colVwGallery.dequeueReusableCell(withReuseIdentifier: "GalleryCVC", for: indexPath) as! GalleryCVC
        cell.imgVwGallery.sd_setImage(with: URL.init(string:dictData.imageFile!), placeholderImage:UIImage(named: "ic_profile-1"), completed: nil)
        cell.btnPreviewImage.tag = indexPath.row
        if galleryVMObj.deleteImgArray.contains(dictData.id!) {
        cell.btnPreviewImage.setImage(UIImage(named: "ic_tick"), for: .normal)
        } else {
         cell.btnPreviewImage.setImage(UIImage(named: ""), for: .normal)
        }
        cell.btnPreviewImage.addTarget(self, action: #selector(btnPreviewImage(_:)), for: .touchUpInside)
        cell.btnShareImg.tag = indexPath.row
        cell.btnShareImg.addTarget(self, action: #selector(shareImageMethod(_:)), for: .touchUpInside)
        return cell
    }
    @objc func shareImageMethod(_ sender: UIButton){
        let index = sender.tag
        shareImageOptions(indexVal: index)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = ((colVwGallery.frame.size.width)/2)
        let height =  width
        let size = CGSize(width: width, height: height)
        return size
    }
    //MARK:- Preview Full Image
    @objc func btnPreviewImage(_ sender: UIButton) {
        let index = IndexPath(item: sender.tag, section: 0)
        let dictData = galleryVMObj.arrGalleryModel[sender.tag]
        let cell = colVwGallery.cellForItem(at: index) as! GalleryCVC
        if btnDelete.isSelected != true {
        if cell.imgVwGallery.image != nil {
            let imageInfo      = GSImageInfo(image: cell.imgVwGallery.image!, imageMode: .aspectFit, imageHD: nil, imageID: "\(sender.tag)")
            let transitionInfo = GSTransitionInfo(fromView: cell.imgVwGallery)
            let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            present(imageViewer, animated: true, completion: nil)
        }
        } else {
            if galleryVMObj.deleteImgArray.contains(dictData.id!) {
               galleryVMObj.deleteImgArray.remove(dictData.id!)
            } else {
               galleryVMObj.deleteImgArray.add(dictData.id!)
            }
            if galleryVMObj.deleteImgArray.count == galleryVMObj.arrGalleryModel.count {
               btnSelectAll.isSelected = true
            } else {
                btnSelectAll.isSelected = false
            }
            colVwGallery.reloadData()
        }
    }
    @objc func ShareImage(_ notification:Notification){
       let indexVal = Int(notification.object as! String)!
        if (notification.userInfo as NSDictionary?) != nil {
        let dictData = galleryVMObj.arrGalleryModel[indexVal]
        let param = ["id" : dictData.id!] as [String:AnyObject]
        deleteImage(param: param)
        } else {
        shareImageOptions(indexVal: indexVal)
        }
    }
    func shareImageOptions(indexVal:Int){
    let indexPath = IndexPath(item: indexVal, section: 0)
    let cell = colVwGallery.cellForItem(at: indexPath) as! GalleryCVC
    let image = cell.imgVwGallery.image!
    let imageToShare = [image]
    let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
   }
   func deleteImage(param:[String:AnyObject]){
   WebServiceProxy.shared.postData("\(Apis.KDeleteGalleryImages)", params: param, showIndicator: true) {
        (response) in
       if response.success{
        Proxy.shared.displayStatusCodeAlert("Image Deleted Successfully")
        self.galleryVMObj.getUserGallery {
            if self.galleryVMObj.arrGalleryModel.count>0 {
                self.btnDelete.isHidden = false
            } else {
                self.btnDelete.isHidden = true
            }
           self.colVwGallery.reloadData()
        }
        }else{
        Proxy.shared.displayStatusCodeAlert(response.message!)
        }
    
     }
   
    }
}
