
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
import SDWebImage
import CropViewController
class SearchPrrogQuesAnsVM: NSObject {
    //MARK: VARIABLES DECLARATION
    var pageCount = 0
    var totalPageCount = 0
    var researchId = Int()
    var arrSurveyQuestModel = [SurveyQuestModel]()
    var galleryFunctions = GalleryCameraImage()
    var selectedImg = UIImage()
    var valueUpdated = false
    var mainImage = false
    var userPicVal = Int()
    var imgIndexPath = Int()
    var remainingDay = "0"
    var surveyDayQuest = 1
    var submitDayQuest = 1
    var dailyPicSub = String()
    var isLastDay = Int()
    var arrForAnswers = NSMutableArray()
    var arrForImages = NSMutableArray()
    var isSubmitted = Int()
    var isLastday = Int()
    
    
     var profileUpdateVmObj = UserProfileUpdateVM()
    //MARK: API METHODS
    func getSureveyAnswer(_ completion:@escaping() -> Void){
        var  urlStr = "\(Apis.KSurveyQuestionList)?research_id=\(researchId)&page=\(pageCount)"
        if (surveyDayQuest <= Int(remainingDay)!) {
            urlStr = "\(urlStr)&day=\(surveyDayQuest)"
        }else{
            self.remainingDay = "0"
        }
        WebServiceProxy.shared.getData(urlStr, showIndicator: true) { (response) in
            if response.success{
                
                if (self.surveyDayQuest <= Int(self.remainingDay)!){
                    self.surveyDayQuest += 1
                }
                if let dictResponse = response.data {
                    if let dictMeta = dictResponse["_meta"] as? NSDictionary{
                        if let totalPages = dictMeta["pageCount"] as? Int {
                            self.totalPageCount = totalPages
                        }
                    }
                    if self.pageCount == 0 {
                        self.arrSurveyQuestModel = []
                    }
                    if let arrResponse = dictResponse["list"]  as? NSArray{
                        for index in 0..<arrResponse.count{
                            if let dictData = arrResponse[index] as? NSDictionary{
                                let objM = SurveyQuestModel()
                                objM.getQuestionList(dictData: dictData)
                                //APPEND MODEL TO THE SAME ARRAY TYPE
                                self.arrSurveyQuestModel.append(objM)
                            }
                        }
                    }
                }
                completion()
            }
            else{
                if self.remainingDay == "0"{
                    if let isSubmittedVal =  response.data!["is_submitted"] as? Int {
                        if isSubmittedVal == 1 {
                            self.isSubmitted = 1
                            completion()
                        }
                    }
                }
                if self.pageCount == 0 {
                    Proxy.shared.displayStatusCodeAlert(response.message!)
                }                
            }
        }
    }
    
    func submitUserAnswer(_ param:[String:AnyObject], paramImage: [String:UIImage], completion:@escaping() -> Void){
        var  urlSubmit = "\(Apis.KSaveAnswer)"
        if (submitDayQuest <= Int(remainingDay)!) {
            urlSubmit = "\(urlSubmit)?day=\(submitDayQuest)"
        }else{
            self.remainingDay = "0"
        }
        
        WebServiceProxy.shared.uploadImage(param, parametersImage: paramImage, addImageUrl: urlSubmit, showIndicator: true){ (response) in
            if response.success{
                if (self.submitDayQuest <= Int(self.remainingDay)!){
                    self.submitDayQuest += 1
                }
                if let lastDay = response.data!["is_last_day"] as? Int {
                  self.isLastday = lastDay
                }
                completion()
            }else{
                Proxy.shared.displayStatusCodeAlert(response.message!)
            }
        }
    }
}
extension SearchProgramQuesAnsVC: UITableViewDataSource,UITableViewDelegate, UITextViewDelegate{
    //MARK:-->TABLE VIEW DELEGATE
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchPrrogQuesAnsVMObj.arrSurveyQuestModel.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dictVal = searchPrrogQuesAnsVMObj.arrSurveyQuestModel[section]
        
        if dictVal.arrOptionModel.count>0{ //MULTIPLE CHOICE & CHOOSE ONE
            return (dictVal.pictureSubmission == BoolVal.TRUE.rawValue ) ? dictVal.arrOptionModel.count+1 : dictVal.arrOptionModel.count
        }
        else{  //case  NO_OPTION = 0, MULTIPLE
            if dictVal.typeId == 0 {  //No Option
                return (dictVal.pictureSubmission == BoolVal.TRUE.rawValue ) ? 1 : 0
            }
            else{ // Options.TYPE_ANS
                return (dictVal.pictureSubmission == BoolVal.TRUE.rawValue) ? 2 : 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let modelDict = searchPrrogQuesAnsVMObj.arrSurveyQuestModel[indexPath.section]
        var modelDictCount = Int()
        if modelDict.arrOptionModel.count>0{
            modelDictCount = modelDict.arrOptionModel.count
        }else{
            if modelDict.typeId == 0 && modelDict.pictureSubmission == BoolVal.TRUE.rawValue{
                modelDictCount = 0
            }else{
                modelDictCount = 1
            }
        }
        if modelDictCount == indexPath.row {
            let cell = tblVwSearchQues.dequeueReusableCell(withIdentifier: "InputCameraTVC", for: indexPath) as! InputCameraTVC
            cell.btnCamera.tag  = 10000*indexPath.section+indexPath.row
            cell.imgPreview.image = modelDict.selectedImage
            cell.btnCamera.addTarget(self, action:  #selector(cameraAction(_:)), for: .touchUpInside)
            return cell
        }
        if  modelDict.typeId == Options.MULTIPLE.rawValue || modelDict.typeId == Options.CHOOSE_ONE.rawValue {
            let arrOption = modelDict.arrOptionModel
            let cellOptions = tblVwSearchQues.dequeueReusableCell(withIdentifier: "OptionsTVC", for: indexPath) as! OptionsTVC
            
            cellOptions.btnCheckBox.tag  = 10000*indexPath.section+indexPath.row
            //            cellOptions.btnCheckBox.addTarget(self, action:  #selector(checkBoxAction(_:)), for: .touchUpInside)
            cellOptions.btnCheckBox.addTarget(self, action:  #selector(checkBoxAction(sender:)), for: .touchUpInside)

            
            cellOptions.lblOption.text = arrOption[indexPath.row].option!
            if modelDict.typeId == Options.CHOOSE_ONE.rawValue {
                
                if optForQuestion .contains(10000*indexPath.section+indexPath.row){
                cellOptions.btnCheckBox.setImage(UIImage(named:"ic_radio_selected"), for: .normal)
//                if  selectedIndex[10000*indexPath.section+indexPath.row]==true{
//                     cellOptions.btnCheckBox.setImage(UIImage(named:"ic_radio_selected"), for: .normal)
//                }else{
//                   cellOptions.btnCheckBox.setImage(UIImage(named:"ic_radio_unselected"), for: .normal)
//                }
                }else{
                    cellOptions.btnCheckBox.setImage(UIImage(named:"ic_radio_unselected"), for: .normal)
                }
//                if optForQuestion .contains(10000*indexPath.section+indexPath.row){
//                    cellOptions.btnCheckBox.setImage(UIImage(named:"ic_radio_selected"), for: .normal)
//                }else{
//                    cellOptions.btnCheckBox.setImage(UIImage(named:"ic_radio_unselected"), for: .normal)
//                }
                
//                if modelDict.arrOptionModel[indexPath.row].selectedIndexPath == indexPath {
//                    cellOptions.btnCheckBox.setImage(UIImage(named: "ic_radio_selected"), for: .normal)
//                }
//                else{
//                    cellOptions.btnCheckBox.setImage(UIImage(named: "ic_radio_unselected"), for: .normal)
//                }
                
            } else {
                if modelDict.arrOptionModel[indexPath.row].isSelected == true {
                    cellOptions.btnCheckBox.setImage(UIImage(named: "ic_chk"), for: .normal)
                }
                else{
                    cellOptions.btnCheckBox.setImage(UIImage(named: "ic_unchk"), for: .normal)
                }
            }
            
            return cellOptions
        }
        else if modelDict.typeId == Options.TYPE_ANS.rawValue  {
            let cell = tblVwSearchQues.dequeueReusableCell(withIdentifier: "InputTxtFldTVC", for: indexPath) as! InputTxtFldTVC
            cell.txtVw.tag = indexPath.section
            return cell
        }
        else{
            let cell = UITableViewCell()
            return cell
        }
    }
//    @objc func checkBoxAction(_ sender: UIButton) {
    @objc func checkBoxAction(sender: UIButton) {
        var getsection = Int()
        getsection = sender.tag/10000
        var getRow = Int()
        getRow = sender.tag%10000
        let dictAns = searchPrrogQuesAnsVMObj.arrForAnswers[getsection] as! NSMutableDictionary
        let dictModelAns = searchPrrogQuesAnsVMObj.arrSurveyQuestModel[getsection]
        let dictModelOpt = dictModelAns.arrOptionModel[getRow]
        //CHECKIN IF THE QUESTION IS OF CHOOSE ONE TYPE
        let dictOpt = NSMutableDictionary()
        if dictModelAns.typeId == Options.CHOOSE_ONE.rawValue {
             searchPrrogQuesAnsVMObj.arrSurveyQuestModel[getsection].arrOptionModel[getRow].selectedIndexPath = IndexPath.init(row: getRow, section: getsection)
            print(sender.tag)
           
            
            if optForQuestion.contains(sender.tag){
           
                self.optForQuestion.remove(sender.tag)
           
            }else{
                
                  self.optForQuestion.removeAllObjects()
                
                self.optForQuestion.add(sender.tag)
               
                
                
           
            }
            
//            if selectedIndex[sender.tag]==false{
//                updtSelect(indx: sender.tag)
//                //bgImage.image = UIImage(named: imageArray[sender.tag] )
////                selectedBG = UIImage(named: imageArray[sender.tag] )
////                backgroundImageNamee = imageArray[sender.tag]
//            }else{
//                selectedIndex[sender.tag] = false
//
//            }
            

            if let arrOpt = dictAns["SurveyAnswerOption"] as? NSMutableArray {
                arrOpt.removeAllObjects()
                dictOpt.setValue(dictModelOpt.id, forKey: "option_id")
                arrOpt.add(dictOpt)
                dictAns.setValue(arrOpt, forKey: "SurveyAnswerOption")
            }
        } else {
            if searchPrrogQuesAnsVMObj.arrSurveyQuestModel[getsection].arrOptionModel[getRow].isSelected == true {
                searchPrrogQuesAnsVMObj.arrSurveyQuestModel[getsection].arrOptionModel[getRow].isSelected = false
                if let arrOpt = dictAns["SurveyAnswerOption"] as? NSMutableArray {
                    for i in 0..<arrOpt.count {
                        let dictOptPre = arrOpt[i] as! NSMutableDictionary
                        if dictModelOpt.id == dictOptPre.value(forKey: "option_id") as? Int {
                            arrOpt.removeObject(at: i)
                            break
                        }
                    }
                    dictAns.setValue(arrOpt, forKey: "SurveyAnswerOption")
                }
            }else{
                searchPrrogQuesAnsVMObj.arrSurveyQuestModel[getsection].arrOptionModel[getRow].isSelected = true
                if let arrOpt = dictAns["SurveyAnswerOption"] as? NSMutableArray {
                    dictOpt.setValue(dictModelOpt.id, forKey: "option_id")
                    arrOpt.add(dictOpt)
                    dictAns.setValue(arrOpt, forKey: "SurveyAnswerOption")
                }
            }
        }
        tblVwSearchQues.reloadData()
    }
    
    func updtSelect(indx : Int) {
        for i in 0..<selectedIndex.count{
            if i==indx{
                selectedIndex[i]=true
            }else{
                selectedIndex[i]=false
            }
        }
       
    }
    //MARK:- TextViewDelegates
    func textViewDidEndEditing(_ textView: UITextView) {
        let dictAns = searchPrrogQuesAnsVMObj.arrForAnswers[textView.tag] as! NSMutableDictionary
        dictAns.setValue(textView.text, forKey: "answer")
    }
    
    @objc func cameraAction(_ sender: UIButton) {
        searchPrrogQuesAnsVMObj.imgIndexPath = sender.tag
        
        searchPrrogQuesAnsVMObj.valueUpdated = true
        
        //himanshu
        Proxy.shared.pushToNextVC(identifier: "CameraViewController", isAnimate: false, currentViewController: self)
//        profileUpdateVmObj.galleryFunctions.customActionSheet(true, controller: self)
        
    }
    
    
    //MARK:- PROTOCOL FUNCTION
    func passSelectedimage(selectImage: UIImage) {
        searchPrrogQuesAnsVMObj.userPicVal = 1
        searchPrrogQuesAnsVMObj.selectedImg = selectImage
        let cropViewController = TOCropViewController(image: searchPrrogQuesAnsVMObj.selectedImg)
        cropViewController.delegate = self
        self.navigationController?.present(cropViewController, animated: true, completion: nil)
    }
    //MARK:-CropViewController Delegate
    
  
    internal func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        //WATERMARK IMAGE
        let newImageView = UIImageView(image : image)
        //ADDING LABEL ABOVE CROPPED IMAGE  FOR SETTING WATERMARK OF DATE N TIME STAMP
        let frameVal = CGRect(x: 0, y: newImageView.frame.height-100, width: newImageView.frame.width, height:  100)
        let labelView = UILabel(frame: frameVal) //adjust frame to change position of water mark or text
        labelView.textAlignment = .right
        let fontVal =  UIFont(name: "Roboto-Regular", size: 60.0)
        labelView.font = fontVal
        let timeStamp = Date()
        let timeVal = Proxy.shared.changeDateFormat("\(timeStamp)", oldFormat: "yyyy-MM-dd HH:mm:ss z", dateFormat: "yyyy-MM-dd HH:mm")
        labelView.text = "\(timeVal)"
        labelView.textColor = UIColor.red
        newImageView.addSubview(labelView)
        //END LABEL ADDING AND NOW PROCESSING IMAGE
        UIGraphicsBeginImageContext(newImageView.frame.size)
        newImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let watermarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var getsection = -1
        getsection = searchPrrogQuesAnsVMObj.imgIndexPath/10000
        var getRow = Int()
        getRow = searchPrrogQuesAnsVMObj.imgIndexPath%10000
        
        if searchPrrogQuesAnsVMObj.mainImage {
            self.imgPreview.isHidden = false
            self.imgPreview.image =  watermarkedImage
            self.searchPrrogQuesAnsVMObj.mainImage = false
        }else{
            let indexpath = NSIndexPath.init(row: getRow, section: getsection)
            let cell = tblVwSearchQues.cellForRow(at: indexpath as IndexPath) as? InputCameraTVC
            cell?.imgPreview.isHidden = false
            cell?.imgPreview.image =  watermarkedImage
            let dictAnsModel = searchPrrogQuesAnsVMObj.arrSurveyQuestModel[getsection]
            if getsection != -1 {
                dictAnsModel.selectedImage = watermarkedImage!
            }
            let dictImage = ["QuesId":"\(dictAnsModel.id!)","AnsImg": watermarkedImage!] as [String : Any]
            searchPrrogQuesAnsVMObj.arrForImages.add(dictImage)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tblVwSearchQues.dequeueReusableCell(withIdentifier: "UserQuestionTVC") as! UserQuestionTVC
        headerView.lblQuesTitle.text = searchPrrogQuesAnsVMObj.arrSurveyQuestModel[section].question!
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tblVwSearchQues.dequeueReusableCell(withIdentifier: "FooterViewTVC") as! FooterViewTVC
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    //MARK : FOR DYNAMIC HEIGHT
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
