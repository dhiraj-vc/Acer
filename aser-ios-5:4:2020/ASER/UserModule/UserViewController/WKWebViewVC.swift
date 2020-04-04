//
//  WKWebViewVC.swift
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
import WebKit

class WKWebViewVC: UIViewController, WKUIDelegate {
    
    // MARK: IB Outlets
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var vwLoadWebVw: UIView!
    
    var checkStr : String!
    var objWKWebViewVM = WKWebViewVM()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMainTitle.text = self.title
        
            if checkStr == "subscription"
            {
                btnBack.setImage(UIImage(named: "ic_back"), for: .normal)
            }else{
                btnBack.setImage(UIImage(named: "ic_menu"), for: .normal)
            }
        
        if Proxy.shared.authNil() == ""{
             btnBack.setImage(UIImage(named:"ic_back"), for: .normal)
        }else{
            
            switch self.title! {
            case "Privacy Policy" :
                objWKWebViewVM.ConstantType = "\(WebPage.PRIVACY.rawValue)"
            case "About us" :
                objWKWebViewVM.ConstantType = ""
            case "Guidelines" :
                objWKWebViewVM.ConstantType = "\(WebPage.GUIDELINES.rawValue)"
            case "Terms & Conditions" :
                objWKWebViewVM.ConstantType = "\(WebPage.TERMS.rawValue)"
            default:
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if objWKWebViewVM.ConstantType == ""
        {
            let url = URL (string: "https://asernv.org/site/about")
            let requestObj = URLRequest(url: url!)
            objWKWebViewVM.webVw = WKWebView(frame: CGRect(x: self.vwLoadWebVw.frame.origin.x, y: self.vwLoadWebVw.frame.origin.x, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-(44+UIApplication.shared.statusBarFrame.size.height)), configuration: objWKWebViewVM.config)
            self.vwLoadWebVw.addSubview(objWKWebViewVM.webVw)

            objWKWebViewVM.webVw.navigationDelegate = self
            objWKWebViewVM.webVw.load(requestObj)
        }else{
            objWKWebViewVM.webVw = WKWebView(frame: CGRect(x: self.vwLoadWebVw.frame.origin.x, y: self.vwLoadWebVw.frame.origin.x, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-(44+UIApplication.shared.statusBarFrame.size.height)), configuration: objWKWebViewVM.config)
            self.vwLoadWebVw.addSubview(objWKWebViewVM.webVw)
            objWKWebViewVM.webVw.navigationDelegate = self
            //MARK : GET STATIC PAGE CONTENT
            objWKWebViewVM.getStaticPageData { (response) in
                if response.success {
                    debugPrint(response.data)
                    if let json = response.data {
                        if let detail = json["page"] as? NSDictionary{
                            self.objWKWebViewVM.url = detail["description"] as? String ?? ""
                        }
                    }
                    let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
                    
                    self.objWKWebViewVM.webVw.loadHTMLString(headerString + (self.objWKWebViewVM.url), baseURL: nil)
                    
                    
                }else{
                    Proxy.shared.displayStatusCodeAlert(response.message!)
                }
            }
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        if objWKWebViewVM.webVw.isLoading == true {
            Proxy.shared.showActivityIndicator()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        objWKWebViewVM.webVw.removeFromSuperview()
    }
    // MARK: IB Actions
    @IBAction func acrtionBack(_ sender: UIButton)
    {
        if checkStr == "subscription"
        {
            Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
        }else{
            if Proxy.shared.authNil() == ""{
                Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
            }else{
                sideMenuViewController?._presentLeftMenuViewController()
            }
        }
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
