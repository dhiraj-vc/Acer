
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
import FBSDKShareKit
import FBSDKLoginKit
import FBSDKCoreKit
import Photos
import TwitterKit
class SocialShareVC: UIViewController,UIDocumentInteractionControllerDelegate {
    var documentController: UIDocumentInteractionController!
    var shareImgUrl = String()
    var shareImg = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func actionFacebook(_ sender: Any) {
        if UIApplication.shared.canOpenURL(NSURL(string:"fb://") as! URL) {
            let photo = FBSDKSharePhoto()
            photo.image = shareImg
            photo.caption = "Post Image"
            photo.isUserGenerated = true
            let content = FBSDKSharePhotoContent()
            content.photos = [photo]
            let dialog = FBSDKShareDialog()
            dialog.fromViewController = self
            dialog.shareContent = content
            dialog.mode = .shareSheet
            dialog.show()
        }else {
            Proxy.shared.displayStatusCodeAlert("Please install facebook in your device")
        }
    }
    @IBAction func actionTwitter(_ sender: Any) {
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
            vc.setInitialText("Post Image")
            vc.add(shareImg)
            present(vc, animated: true)
        }
    }
    @IBAction func actionInstagram(_ sender: Any) {
        DispatchQueue.main.async {
            let image = self.shareImg
            //Share To Instagram:
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
        
        }
        
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error != nil {
            print(error)
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if let lastAsset = fetchResult.firstObject {
            let localIdentifier = lastAsset.localIdentifier
            let u = "instagram://library?LocalIdentifier=" + localIdentifier
            let url = NSURL(string: u)!
            if UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.openURL(NSURL(string: u)! as URL)
            } else {
                let alertController = UIAlertController(title: "Error", message: "Instagram is not installed", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func actionSnapchat(_ sender: Any) {
        let image = shareImg
        let avc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        avc.completionWithItemsHandler = { activity, success, items, error in
        }
        self.present(avc, animated: true, completion: nil)

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
}
