
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

class SelectCountryVwModel: NSObject {
    var selectionType = String()
    var Id = Int()
    var arrCountryList = [CountryModel]()
    var filterArr = [CountryModel]()
    func getCountryList(completion: @escaping ResponseHandler){
        var UrlString = String()
        switch selectionType {
        case "State":
            UrlString = "\(Apis.KGetStateList)\(Id)"
        case "City" :
            UrlString = "\(Apis.KGetCityList)\(Id)"
        case "ProductCat" :
            UrlString = "\(Apis.KGetProductCatList)"
        default:
            UrlString = "\(Apis.KGetCountryList)"
        }
        WebServiceProxy.shared.getData(UrlString, showIndicator: true) {  (ApiResponse) in
            completion(ApiResponse)
        }
    }
    func handelReponseForCountryList(_ response:ApiResponse,view:UIViewController){
        if response.success {
            if let userDetDict = response.data {
                var arrList = NSArray()
                if userDetDict["countries"] as? NSArray != nil {
                    arrList = userDetDict["countries"] as! NSArray
                } else if userDetDict["states"] as? NSArray != nil {
                    arrList = userDetDict["states"] as! NSArray
                }
                else if userDetDict["categories"] as? NSArray != nil {
                    arrList = userDetDict["categories"] as! NSArray
                }else {
                    arrList = userDetDict["cities"] as! NSArray
                }
                for i in 0..<arrList.count{
                    if let dictList = arrList[i] as? NSDictionary {
                        let countryObj = CountryModel()
                        countryObj.countryDet(countDict: dictList)
                        arrCountryList.append(countryObj)
                        filterArr = arrCountryList
                    }
                }
            }
        }
    }
}

extension SelectCounrtyVC : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectCountryVMobj.filterArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewList.dequeueReusableCell(withIdentifier: "CountryNameTVC") as! CountryNameTVC
        let dictCountry = selectCountryVMobj.filterArr[indexPath.row]
        cell.lblCountryName.text = dictCountry.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictCountry = selectCountryVMobj.filterArr[indexPath.row]
        self.dismiss(animated: true) {
            let selectionType = ["Name":"\(self.selectCountryVMobj.selectionType)"]
            NotificationCenter.default.post(name: NSNotification.Name("SelectedCountry"), object: dictCountry, userInfo: selectionType)
        }
    }
    //MARK:- SearchBar Delegates
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            let filteredArray = selectCountryVMobj.arrCountryList.filter { ($0.name as! String).range(of: searchBar.text!, options: [.diacriticInsensitive, .caseInsensitive]) != nil }
            selectCountryVMobj.filterArr = filteredArray
        } else {
            searchBar.resignFirstResponder()
            selectCountryVMobj.filterArr = selectCountryVMobj.arrCountryList
        }
        tblViewList.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != "" {
            let filteredArray = selectCountryVMobj.arrCountryList.filter { ($0.name as! String).range(of: searchBar.text!, options: [.diacriticInsensitive, .caseInsensitive]) != nil }
            selectCountryVMobj.filterArr = filteredArray
            
        } else {
            searchBar.resignFirstResponder()
            selectCountryVMobj.filterArr = selectCountryVMobj.arrCountryList
        }
        tblViewList.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        selectCountryVMobj.filterArr = selectCountryVMobj.arrCountryList
    }
}
