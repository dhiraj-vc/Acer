
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

class DailyImagesGalleryVC: UIViewController {
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet var colVwGallery: UICollectionView!
    
    var galleryVMObj = DailyImagesVM()

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UserDefaults.standard.string(forKey: "ColorKey")
        if color == "Green"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            
        }else if color == "Default"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            
        }else if color == "Black"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            
            
        }else if color == "Gold"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            
        }else if color == "Blue"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            
        }else if color == "Pink"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            
        }else if color == "Red"{
            
            topBarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            
        }else {
            topBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarView.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        }
        
        galleryVMObj.getUserGallery {
            if self.galleryVMObj.arrGalleryModel.count>0{
                self.colVwGallery.isHidden = false
                self.colVwGallery.reloadData()
            }else{
                self.colVwGallery.isHidden = true
            }
        }
    }
    //MARK:-Actions
    @IBAction func actionBack(_ sender:UIButton){
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
}
