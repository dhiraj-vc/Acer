
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

class IntroductionVC: UIViewController {
    //MARK:- Outlets
    
    @IBOutlet weak var imgViewIntro: UIImageView!
    @IBOutlet weak var lblIntroTitle: UILabel!
    @IBOutlet weak var lblIntroDesc: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var pageCntrl: UIPageControl!
    var imageIndex = Int()
    var timer = Timer()
    var arrIntroSlider = [["Title":"Welcome to A.S.E.R","Desc": " ","image":"ic_pic01"],["Title":"Get Started !","Desc":" " ,"image":"ic_pic02"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageCntrl.numberOfPages = arrIntroSlider.count
        self.pageCntrl.currentPage = 0
        
        let dictDesc = arrIntroSlider[0] as NSDictionary
        imgViewIntro.image = UIImage(named:"\(dictDesc["image"] as! String)")
        lblIntroTitle.text = dictDesc["Title"] as? String
       }
    //MARK:- Actions
    @IBAction func btnSkip(_ sender: UIButton) {
       Proxy.shared.pushToNextVC(identifier: "ChooseRoleVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func btnNext(_ sender: UIButton) {
        if imageIndex+1 == arrIntroSlider.count-1 {
           btnSkip.isHidden = true
        }
        moveToNext()
    }
    
    func moveToNext(){
        imageIndex = imageIndex+1;
        
        // check if index is in range
        if imageIndex == arrIntroSlider.count {
            imageIndex = 0
            UserDefaults.standard.set("1", forKey: "install")
            UserDefaults.standard.synchronize()
            Proxy.shared.pushToNextVC(identifier: "ChooseRoleVC", isAnimate: true, currentViewController: self)

        }
        let dictDesc = arrIntroSlider[imageIndex] as NSDictionary
        imgViewIntro.image = UIImage(named:"\(dictDesc["image"] as! String)")
        lblIntroTitle.text = dictDesc["Title"] as? String
        lblIntroDesc.text = dictDesc["Desc"] as? String
        self.pageCntrl.currentPage = imageIndex
    }
    
    
    
    // MARK:- Slider Methods
    @objc func swiped(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left :
                // decrease index first
                imageIndex = imageIndex+1;
                // check if index is in range
                if imageIndex == arrIntroSlider.count {
                    imageIndex = 0
                }
                let dictDesc = arrIntroSlider[imageIndex] as NSDictionary
                imgViewIntro.image = UIImage(named:"\(dictDesc["image"] as! String)")
                lblIntroTitle.text = dictDesc["Title"] as? String
                lblIntroDesc.text = dictDesc["Desc"] as? String
                self.pageCntrl.currentPage = imageIndex
            default:
                break //stops the code/codes nothing.
            }
        }
    }
    
    
    @objc func autoScrollImageSlider(){
        if arrIntroSlider.count>0 {
            imageIndex = imageIndex+1;
            // check if index is in range
            if imageIndex == arrIntroSlider.count {
                imageIndex = 0
            }
            let dictDesc = arrIntroSlider[imageIndex] as NSDictionary
            imgViewIntro.image = UIImage(named:"\(dictDesc["image"] as! String)")
            lblIntroTitle.text = dictDesc["Title"] as? String
            lblIntroDesc.text = dictDesc["Desc"] as? String
            self.pageCntrl.currentPage = imageIndex
        }
    }
}
