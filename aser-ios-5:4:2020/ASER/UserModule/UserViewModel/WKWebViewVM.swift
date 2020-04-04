
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
import WebKit
class WKWebViewVM:NSObject {
    
    var webVw = WKWebView()
    var url = String()
    var ConstantType = ""
    let config = WKWebViewConfiguration()
    
    func getStaticPageData(completion: @escaping ResponseHandler){
        WebServiceProxy.shared.getData("\(Apis.KWebPageData)\(ConstantType)", showIndicator: true)  { (ApiResponse) in
            completion(ApiResponse)
        }
    }
}

extension WKWebViewVC: WKNavigationDelegate {
    //MARK:- WKNavigationDelegate
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        Proxy.shared.hideActivityIndicator()
        Proxy.shared.displayStatusCodeAlert("AlertMessges.TRYAGAIN")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Proxy.shared.hideActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor decidePolicyForNavigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}
