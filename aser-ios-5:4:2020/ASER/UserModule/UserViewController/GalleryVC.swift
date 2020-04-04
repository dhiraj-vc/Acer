//
//  GalleryVC.swift
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
class GalleryVC: UIViewController {
    @IBOutlet var colVwGallery: UICollectionView!
    @IBOutlet weak var btnTick: UIButton!
    @IBOutlet weak var cnstWidthForTick: NSLayoutConstraint!
    @IBOutlet weak var cnstHeightForView: NSLayoutConstraint!
    @IBOutlet weak var viewForSelect: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnSelectAll: UIButton!
    var galleryVMObj = GalleryVm()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnTick.isHidden = true
        cnstWidthForTick.constant = 0
        viewForSelect.isHidden = true
        cnstHeightForView.constant = 0
        galleryVMObj.getUserGallery {
            if self.galleryVMObj.arrGalleryModel.count>0{
                self.btnDelete.isHidden = false
                self.colVwGallery.isHidden = false
                self.colVwGallery.reloadData()
            }else{
                self.colVwGallery.isHidden = true
                self.btnDelete.isHidden = true
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ShareImage(_:)), name: NSNotification.Name("ShareImage"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name:  NSNotification.Name("ShareImage"), object: nil)
    }
    //MARK:-Actions
    @IBAction func actionBack(_ sender:UIButton){
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    @IBAction func btnDelete(_ sender: UIButton) {
        if sender.isSelected == true {
           sender.isSelected = false
            viewForSelect.isHidden = true
            cnstHeightForView.constant = 0
            cnstWidthForTick.constant = 0
            btnTick.isHidden = true
            galleryVMObj.deleteImgArray.removeAllObjects()
            colVwGallery.reloadData()
        } else {
           sender.isSelected = true
            cnstWidthForTick.constant = 45
            cnstHeightForView.constant = 40
            btnTick.isHidden = false
            viewForSelect.isHidden = false
        }
    }
    @IBAction func btnSelect(_ sender: UIButton)
    {
        if sender.isSelected == true {
            sender.isSelected = false
            cnstWidthForTick.constant = 45
            cnstHeightForView.constant = 40
            btnTick.isHidden = false
            viewForSelect.isHidden = false
        } else {
            if galleryVMObj.deleteImgArray.count>0  {
            let ids =  Proxy.shared.arrToString(selectArr: galleryVMObj.deleteImgArray)
            let param = ["id" : ids] as [String:AnyObject]
            deleteImage(param: param)
            self.colVwGallery.reloadData()
            sender.isSelected = true
            viewForSelect.isHidden = true
            cnstHeightForView.constant = 0
            cnstWidthForTick.constant = 0
            btnTick.isHidden = true
            } else {
            Proxy.shared.displayStatusCodeAlert("Please select image. ")
            }
        }
    }
    @IBAction func btnSelectAll(_ sender: UIButton) {
      if sender.isSelected == true {
            sender.isSelected = false
            self.galleryVMObj.deleteImgArray.removeAllObjects()
            colVwGallery.reloadData()
        } else {
            sender.isSelected = true
            if self.galleryVMObj.arrGalleryModel.count>0{
                for i in 0..<self.galleryVMObj.arrGalleryModel.count {
                    let dictImage = self.galleryVMObj.arrGalleryModel[i]
                    self.galleryVMObj.deleteImgArray.add(dictImage.id!)
                }
                colVwGallery.reloadData()
            }
        }
    }
}

