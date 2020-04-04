
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

class DailyImagesVM: NSObject {
    var pageCount = 0
    var totalPageCount = 0
    var researchId = Int()
    var arrGalleryModel = [DailyImagesModel]()
    
    func getUserGallery(_ completion:@escaping() -> Void){
        WebServiceProxy.shared.getData("\(Apis.KDailyImagesGallery)\(researchId)?page=\(pageCount)", showIndicator: false) { (response) in
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
                    if let resArrr = responsedict["dailyImages"] as? NSArray {
                        for i in 0..<resArrr.count{
                            if let arrData = resArrr[i] as? NSArray{
                               if arrData.count > 0 {
                                    let objVM = DailyImagesModel()
                                    objVM.day = "Day \(i+1)"
                                   for j in 0..<arrData.count {
                                    if let dictImg = arrData[j] as? NSDictionary {
                                       let objGallery = GalleryModel()
                                        objGallery.getGallery(dictImg)
                                        objVM.gallery.append(objGallery)
                                     }
                                }
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
}
extension DailyImagesGalleryVC: UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return galleryVMObj.arrGalleryModel.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryVMObj.arrGalleryModel[section].gallery.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dictData = galleryVMObj.arrGalleryModel[indexPath.section].gallery[indexPath.row]
        let cell = colVwGallery.dequeueReusableCell(withReuseIdentifier: "GalleryCVC", for: indexPath) as! GalleryCVC
        cell.imgVwGallery.sd_setImage(with: URL.init(string:dictData.imageFile!), placeholderImage:UIImage(named: "ic_profile-1"), completed: nil)
        cell.lblDayName.text = dictData.createdBy
        cell.btnPreviewImage.tag = 10000*indexPath.section+indexPath.row
        cell.btnPreviewImage.addTarget(self, action: #selector(btnPreviewImage(_:)), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GalleryTitleCRV", for: indexPath) as! GalleryTitleCRV
        let dictDays = galleryVMObj.arrGalleryModel[indexPath.section]
        headerView.lblDayName.text = dictDays.day
        return headerView
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = ((colVwGallery.frame.size.width)/2)
        let height =  width+30
        let size = CGSize(width: width, height: height)
        return size
    }
    //MARK:- Preview Full Image
    @objc func btnPreviewImage(_ sender: UIButton) {
        let secVal = sender.tag/10000
        let rowVal = sender.tag%10000
        let index = IndexPath(item: rowVal, section: secVal)
        let cell = colVwGallery.cellForItem(at: index) as! GalleryCVC
        if cell.imgVwGallery.image != nil {
            let imageInfo      = GSImageInfo(image: cell.imgVwGallery.image!, imageMode: .aspectFit, imageHD: nil, imageID: "")
            let transitionInfo = GSTransitionInfo(fromView: cell.imgVwGallery)
            let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            present(imageViewer, animated: true, completion: nil)
        }
    }
}
