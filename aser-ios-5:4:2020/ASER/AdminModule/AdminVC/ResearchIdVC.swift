//
//  ResearchIdVC.swift
//  ASER
//
//  Created by God on 20/01/20.
//  Copyright © 2020 Priti Sharma. All rights reserved.
//

import UIKit
import Alamofire

class ResearchIdVC: UIViewController {
@IBOutlet weak var txtFldEnteredCode: UITextField!
    
    var objEnterReserchVM = ResearchIdVM()
    var urlTxt = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
   
    
    @IBAction func actionSubmit(_ sender: UIButton) {
//        self.dismiss(animated: true)
//        let resVC = mainStoryboard.instantiateViewController(withIdentifier: "ResearchPdfVC") as! ResearchPdfVC
//       urlRes = "https://asernv.org/site/download-data?id=318"
//        Proxy.shared.presentToNextVC(identifier: "ResearchPdfVC", isAnimate: true, currentViewController: self)
        
//        self.navigationController?.pushViewController(resVC, animated: true)
        if txtFldEnteredCode.isBlank{
            Proxy.shared.displayStatusCodeAlert(AlertMsgs.ENTERASSIGNCODE)
        }else{
//            objEnterReserchVM.urlString
             urlTxt = txtFldEnteredCode.text!
           


    
            let headers = [
                "Authorization": "Bearer \(Proxy.shared.authNil())",
                "User-Agent":"\(AppInfo.UserAgent)"
            ]
            let url = "https://asernv.org/api/research-program/download-data" // This will be your link
            
            print("Bearer \(Proxy.shared.authNil())")
            let param = [
                "research_id":urlTxt
                
            ]
//            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:headers).responseJSON { response in
            Alamofire.request(url, method: .post, parameters: param,headers:headers).responseJSON { response in
                switch response.result{
                case .success:
//                    activityIndicator.stopAnimating()
                    let dict = response.value as! NSDictionary
                    print(dict)
//                    let adminArray = dict.value(forKeyPath: "dataset") as! NSArray
                    //let userArray = dict.value(forKeyPath: "dataset.UserAvatars") as! NSArray
                    //MARK : Admin avtar
                    let status = dict.value(forKey: "status") as! Int
                    print(status as Any)
                    if status == 200{
                    
                   let link = dict.value(forKey: "download_link") as! String
                    print(link)
                        urlRes = link
                        Proxy.shared.presentToNextVC(identifier: "ResearchPdfVC", isAnimate: true, currentViewController: self)
                        
                        
                    }else{
                        let error = dict.value(forKey: "error") as! String
                        Proxy.shared.displayStatusCodeAlert(error)
                    }
                   
                    
                case .failure(let error):
                    print(error.localizedDescription)
                   
                }
            }
 
 
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true) {
            //MARK: ACTION
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
