
//
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
import AFNetworking
import Alamofire

class SubmittedSurveyAnsVC: UIViewController,UIDocumentInteractionControllerDelegate{
    
    //MARK: OUTLETS
    @IBOutlet weak var tblVwSubmittedSurvey: UITableView!
    // color
    @IBOutlet weak var topBarVw: UIView!
    @IBOutlet weak var bottomBarVw: UIView!
    
    @IBOutlet weak var bckBtn: UIButton!
    @IBOutlet weak var useReviwLbl: UILabel!
    @IBOutlet weak var downLoadBtn: UIButton!
    @IBOutlet weak var viewDailyImage: UIButton!
    
    var objSubSurveyAnsVM = SubmittedSurveyAnsVM()
    var path = NSURL()
    var docController: UIDocumentInteractionController!
    var imageString: String = ""
    
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = UserDefaults.standard.string(forKey: "ColorKey")
        if color == "Green"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.3921568627, blue: 0.2156862745, alpha: 1)
            
        }else if color == "Default"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            
        }else if color == "Black"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.1596803617, green: 0.1596803617, blue: 0.1596803617, alpha: 1)
            
            
        }else if color == "Gold"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.4352941176, blue: 0.2078431373, alpha: 1)
            
        }else if color == "Blue"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.8784313725, alpha: 1)
            
        }else if color == "Pink"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.3254901961, blue: 0.431372549, alpha: 1)
            
        }else if color == "Red"{
            
            topBarVw.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.007843137255, blue: 0.01960784314, alpha: 1)
            
        }else {
            topBarVw.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            bottomBarVw.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        objSubSurveyAnsVM.getSubmittedSurveyData {
            self.tblVwSubmittedSurvey.reloadData()
        }
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnShowDailyImages(_ sender: UIButton) {
        let dailyImagesVC = mainStoryboard.instantiateViewController(withIdentifier: "DailyImagesGalleryVC") as! DailyImagesGalleryVC
        dailyImagesVC.galleryVMObj.researchId = objSubSurveyAnsVM.researchId
        self.navigationController?.pushViewController(dailyImagesVC, animated: true)
    }
    @IBAction func btnDownload(_ sender: UIButton) {
        Proxy.shared.showActivityIndicator()
        let headers = [
            "Authorization": "Bearer \(Proxy.shared.authNil())",
            "User-Agent":"\(AppInfo.UserAgent)"
        ]
        let url = "https://asernv.org/api/research-program/download-data" // This will be your link
        
        print("Bearer \(Proxy.shared.authNil())")
        let param = [
            "research_id":objSubSurveyAnsVM.researchId
            
        ]
       
        Alamofire.request(url, method: .post, parameters: param,headers:headers).responseJSON { response in
            switch response.result{
            case .success:
            
                let dict = response.value as! NSDictionary
                print(dict)
              
                let status = dict.value(forKey: "status") as! Int
                print(status as Any)
                if status == 200{
                    
                    let link = dict.value(forKey: "download_link") as! String
                    print(link)
                    
                    
                    let request = URLRequest(url:  URL(string: link)!)
                    let config = URLSessionConfiguration.default
                    let session =  URLSession(configuration: config)
                    let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
                        if error == nil{
//                            Proxy.shared.hideActivityIndicator()
                            if let pdfData = data {
                                let pathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(Date()).pdf")
                                do {
                                    try pdfData.write(to: pathURL, options: .atomic)
//                                    Proxy.shared.showActivityIndicator()
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
                        }
                    }); task.resume()
                    
                    
                    
                    
                }else{
                    let error = dict.value(forKey: "error") as! String
                    Proxy.shared.displayStatusCodeAlert(error)
                }
                
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
        

        
        
        
        /*
        Proxy.shared.showActivityIndicator()
        //&access-token=\(Proxy.shared.authNil())
        let url = URL(string: "\(Apis.KServerUrl)\(Apis.KDownloadSurveyData)\(objSubSurveyAnsVM.researchId)")
        let request = URLRequest(url: url!)
        let session = AFHTTPSessionManager()
        //var progress: Progress!
        let downloadTask: URLSessionDownloadTask? = session.downloadTask(with: request, progress : nil, destination: {(_ targetPath: URL, _ response: URLResponse) -> URL in
            let documentsDirectoryPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)
            return documentsDirectoryPath.appendingPathComponent("\(Date()).pdf")
        }, completionHandler: {(_ response: URLResponse, _ filePath: URL?, _ error: Error?) -> Void in
            DispatchQueue.main.async(execute: {(_: Void) -> Void in
               Proxy.shared.showActivityIndicator()
                if filePath != nil{
                    self.path = filePath! as NSURL
                    self.docController = UIDocumentInteractionController(url: self.path as URL)
                    self.docController.delegate = self
                    Proxy.shared.hideActivityIndicator()
                    self.docController.presentPreview(animated: true)
                }
            })
        })
        downloadTask?.resume()
 */
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
