//
//  AppDelegate.swift
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
import Alamofire

class WebServiceProxy {
    static var shared: WebServiceProxy {
        return WebServiceProxy()
    }
   private init(){}
    //MARKK:- API Interaction
    func postData(_ urlStr: String, params: Dictionary<String, AnyObject>? = nil, showIndicator: Bool, completion: @escaping (ApiResponse) -> Void) {
       if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
        
//            request("\(Apis.KServerUrl)\(urlStr)",method: .post, parameters: params!,encoding: )
        //   //responseString
        // URLEncoding.httpBody
            request("\(Apis.KServerUrl)\(urlStr)", method: .post, parameters: params!, headers:
                ["Authorization": "Bearer \(Proxy.shared.authNil())","User-Agent":"\(AppInfo.UserAgent)"])
                .responseJSON
                { response in
                    //responseJSON responseString
                   DispatchQueue.main.async {
                        Proxy.shared.hideActivityIndicator()
                    }
                    let res : ApiResponse?
                    if response.data != nil && response.result.error == nil {
                        debugPrint("RESPONSE",response.result.value!)
                        if response.response?.statusCode == 200 {
                            if let JSON = response.result.value as? NSDictionary {
                                //completion( JSON, true, "")
                                if JSON["status"] as? Int == 200 {
                                    res = ApiResponse(data: JSON, success: true, message: JSON["message"] as? String ?? nil)
                                }else{
                                    res = ApiResponse(data: nil, success: false, message: JSON["error"] as? String ?? "Error")
                                }
                            } else {
                                res = ApiResponse(data: nil, success: false, message:  "Error")
                            }
                        } else {
                            res = ApiResponse(data: nil, success: false, message: "")
                            self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                        }
                    } else {
                        res = ApiResponse(data: nil, success: false, message: "Error: Unable to encode JSON Response")
                    }
                    completion(res!)
            }
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    func getData(_ urlStr: String, showIndicator: Bool, completion: @escaping (ApiResponse) -> Void)  {
        let apiUrl = "\(Apis.KServerUrl)\(urlStr)"
        let urlStr1 = apiUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        if NetworkReachabilityManager()!.isReachable {            
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            request(urlStr1!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:
                ["Authorization": "Bearer \(Proxy.shared.authNil())","User-Agent":"\(AppInfo.UserAgent)"] )
                .responseJSON { response in
                    
                    DispatchQueue.main.async {
                        Proxy.shared.hideActivityIndicator()
                    }
                    let res : ApiResponse?
                    if response.data != nil && response.result.error == nil {
                        if response.response?.statusCode == 200 {
                            if let JSON = response.result.value as? NSDictionary {
                                //completion( JSON, true, "")
                                if JSON["status"] as? Int == 200 {
                                    res = ApiResponse(data: JSON, success: true, message: nil)
                                }else{
                                    res = ApiResponse(data: JSON, success: false, message: JSON["error"] as? String ?? "Error")
                                }
                            } else {
                                res = ApiResponse(data: nil, success: false, message:  "Error")
                            }
                        } else {
                            res = ApiResponse(data: nil, success: false, message: "Page not found")
                            self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                        }
                    } else {
                        if let JSON = response.result.value as? NSDictionary {
                            res = ApiResponse(data: nil, success: false, message:  "Error")
                            
                        } else {
                            res = ApiResponse(data: nil, success: false, message:  "Error")
                        }
                    }
                    completion(res!)
            }
        } else {
            DispatchQueue.main.async {
                Proxy.shared.hideActivityIndicator()
            }
            Proxy.shared.openSettingApp()
        }
    }
    
    // Himanshu , himanshu
    func uploadImage(_ parameters:[String:AnyObject],parametersImage:[String:UIImage],addImageUrl:String, showIndicator: Bool, completion: @escaping (ApiResponse) -> Void)  {
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    for (key, val) in parameters {
                        multipartFormData.append(val.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }

                    for (key, val) in parametersImage {
                        let timeStamp = Date().timeIntervalSince1970 * 1000
                        let fileName = "image\(timeStamp).png"
                        //himanshu
                        let imaget : UIImage = val
                        guard let imageData = imaget.jpegData(compressionQuality: 0.5)
                            //UIImageJPEGRepresentation(val, 0.5)
                            else {
                                return
                    }
                    multipartFormData.append(imageData, withName: key, fileName: fileName , mimeType: "image/png")
                }
            },
            to: "\(Apis.KServerUrl)\(addImageUrl)",
            method:.post,
            headers:["Authorization": "Bearer \(Proxy.shared.authNil())","User-Agent":"\(AppInfo.UserAgent)"], encodingCompletion: { encodingResult in
                switch encodingResult {
                    case .success(let upload, _, _):
                        upload.validate()
                        upload.responseJSON { response in
                            guard response.result.isSuccess else {
                                Proxy.shared.hideActivityIndicator()
                                self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                                Proxy.shared.displayStatusCodeAlert(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)! as String)
                                return
                            }
                            Proxy.shared.hideActivityIndicator()
                            let res : ApiResponse?
                            if let responseJSON = response.result.value as? NSDictionary{
                                //completion( JSON, true, "")
                                if responseJSON["status"] as? Int == 200 {
                                    res = ApiResponse(data: responseJSON, success: true, message: nil)
                                }else{
                                    res = ApiResponse(data: nil, success: false, message: responseJSON["error"] as? String ?? "Error")
                                }
                                completion(res!)
                            }
                        }
                    case .failure(let errorcoding):
                        debugPrint(errorcoding)
                        Proxy.shared.hideActivityIndicator()
                        break
                    }
                })
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    // MARK: - Error Handling
    
    func statusHandler(_ response:HTTPURLResponse? , data:Data?, error:NSError?) {
        if let code = response?.statusCode {
            switch code {
            case 400:
                Proxy.shared.displayStatusCodeAlert("Please check the URL : 400")
            case 401, 403:
                UserDefaults.standard.set("", forKey: "auth_code")
                UserDefaults.standard.synchronize()
                Proxy.shared.displayStatusCodeAlert("Session Logged out")
                Proxy.shared.rootWithoutDrawer(identifier: "WelcomeVC")
            case 404:
                Proxy.shared.displayStatusCodeAlert("URL does not exists : 404")
            case 500:
                
                let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                Proxy.shared.displayStatusCodeAlert(myHTMLString as String)
            case 408:
                
                Proxy.shared.displayStatusCodeAlert("Server error, Please try again..")
            default:
                let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                Proxy.shared.displayStatusCodeAlert(myHTMLString as String)
            }
        } else {
            let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            Proxy.shared.displayStatusCodeAlert(myHTMLString as String)
        }
        
        if let errorCode = error?.code {
            switch errorCode {
            default:
                break
                //Proxy.shared.displayStatusCodeAlert("Server error, Please try again..")
            }
        }
    }
    
    func HtmlDisplayStatusAlert(userMessage: String)  {
//                let pushControllerObj = storyboardObj?.instantiateViewController(withIdentifier: "HtmlViewController") as! HtmlViewController
//                pushControllerObj.HtmlSting = userMessage
//                KAppDelegate.window?.currentViewController()?.navigationController?.pushViewController(pushControllerObj, animated: true)
    }
}
