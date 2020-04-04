//
//  ResearchPdfVC.swift
//  ASER
//
//  Created by God on 21/01/20.
//  Copyright © 2020 Priti Sharma. All rights reserved.
//

import UIKit


var urlRes = String()
class ResearchPdfVC: UIViewController, UIWebViewDelegate,UIDocumentInteractionControllerDelegate {


    @IBOutlet weak var researchWebView: UIWebView!
    var path = NSURL()
    var docController: UIDocumentInteractionController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(urlRes)
        let url1 : NSURL! = NSURL(string: urlRes)
        
        researchWebView.loadRequest(URLRequest(url: url1 as URL))
        researchWebView.delegate = self
      
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        print(urlRes)
//        let url1 : NSURL! = NSURL(string: urlRes)
//
//        researchWebView.loadRequest(URLRequest(url: url1 as URL))
//    }
    override func viewDidAppear(_ animated: Bool) {
        researchWebView.delegate = self
    }

    @IBAction func BackAction(_ sender: Any) {
        self.dismiss(animated: true)
        
    }
    @IBAction func DownloadAction(_ sender: Any) {
        Proxy.shared.showActivityIndicator()
        let request = URLRequest(url:  URL(string: urlRes)!)
        let config = URLSessionConfiguration.default
        let session =  URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if error == nil{
//                Proxy.shared.hideActivityIndicator()
                if let pdfData = data {
                    let pathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(Date()).pdf")
                    do {
                        try pdfData.write(to: pathURL, options: .atomic)
//                         Proxy.shared.showActivityIndicator()
                        if pathURL != nil{
                            self.path = pathURL as NSURL
                            self.docController = UIDocumentInteractionController(url: self.path as URL)
                            self.docController.delegate = self
                            Proxy.shared.hideActivityIndicator()
                            self.docController.presentPreview(animated: true)
                        }
                    }catch{
                        print("Error while writting")
                    }
                    
                 
                }
            }else{
                print(error?.localizedDescription ?? "")
                Proxy.shared.hideActivityIndicator()
            }
        }); task.resume()
        
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        Proxy.shared.showActivityIndicator()
        // UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("Strat Loading")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        Proxy.shared.hideActivityIndicator()
        // UIApplication.shared.isNetworkActivityIndicatorVisible = false
        print("Finish Loading")
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        print(error.localizedDescription)
    }
    
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
//    {
//        //        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        print("Strat Loading")
//        return true
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
