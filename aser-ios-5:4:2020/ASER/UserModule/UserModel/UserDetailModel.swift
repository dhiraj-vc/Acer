//
//  SignUpModel.swift
//  Findmykaki
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
class UserDetailModel: NSObject {
    var idUser,typeId,roleID,stateID,isPasscode,isFingerPrint,isParticipant,unReadChat:Int!
    var fullName,firstName,aboutMe,gender,contactNumber,address,contactNo,emailId,latitute,langitute,zipCode,profileImage,accessToken,city, apartment, age,country,state,street, genderIntVal, userCountryID, userStateId, adminRoleId, adminRole, designation, passCode, coverFile, accessCode :String!
    var rating:Float?
    var doctorSubPlanDict : NSDictionary!
    
    var doctorDet = DoctorModel()
    func userDict(dict: NSDictionary)  {
        if let valI = dict["sub_role_id"] as? Int{
            adminRoleId = "\(valI)"
        }else if let vals = dict["sub_role_id"] as? String{
            adminRoleId = vals
        }
        if adminRoleId ==  StaticData.AdminRole[0][1]{
            adminRole = StaticData.AdminRole[0][0]
        }else if adminRoleId ==  StaticData.AdminRole[1][1]{
            adminRole = StaticData.AdminRole[1][0]
        }else {
            adminRole = ""
        }
        if let dictDoctor = dict["doctor"] as? NSDictionary
        {
            doctorDet.getDrDetail(dictDoctor)
        }
        accessCode = dict["access_code"] as? String ?? ""
        if let unread = dict["unread_chat"] as? String {
            unReadChat = Int(unread)!
        } else {
            unReadChat = dict["unread_chat"] as? Int ?? 0
        }
        
        designation = dict["designation"] as? String ?? ""
        fullName = dict["full_name"] as? String ?? ""
        firstName = dict["first_name"] as? String ?? ""
        aboutMe = dict["about_me"] as? String ?? ""
        passCode = dict["passcode"] as? String ?? ""
        if let genderValS = dict["gender"] as? Int{
            genderIntVal = "\(genderValS)"
        } else if let genderValI = dict["gender"] as? String{
            if genderValI != ""{
                genderIntVal = genderValI
            }
        }
        gender = (genderIntVal == "\(Gender.Male.rawValue)") ? "Male" : "Female"
        contactNumber = dict["contact_no"] as? String ?? ""
        stateID = dict["state_id"] as? Int ?? 0
        if let passcode = dict["is_passcode"] as? Int {
            isPasscode = passcode
        } else if let passcode = dict["is_passcode"] as? String {
            isPasscode = Int(passcode)!
        } else {
            isPasscode = 0
        }
        if let fingerPrint = dict["is_fingerprint"] as? Int {
            isFingerPrint = fingerPrint
        } else if let fingerPrint = dict["is_fingerprint"] as? String {
            isFingerPrint = Int(fingerPrint)!
        } else {
           isFingerPrint = 0
        }
        idUser = dict["id"] as? Int ?? 0
        address  = dict["address"] as? String ?? ""
        city  = dict["city"] as? String ?? ""
        contactNo  = dict["contact_no"] as? String ?? ""
        emailId = dict["email"] as? String ?? ""
        latitute = dict["latitude"] as? String ?? ""
        langitute = dict["longitude"] as? String ?? ""
        zipCode = dict["zipcode"] as? String ?? ""
        profileImage = dict["profile_file"] as? String ?? ""
        coverFile = dict["cover_file"] as? String ?? ""
        accessToken = dict["access_token"] as? String ?? ""
        apartment = dict["apartment"] as? String ?? ""
        age = dict["age"] as? String ?? ""
        country = dict["country"] as? String ?? ""
        state = dict["state"] as? String ?? ""
        street = dict["street"] as? String ?? ""
        
        if let dataValS = dict["user_country_id"] as? String {
            userCountryID = dataValS
        }else if let dataValI = dict["user_country_id"] as? Int {
            userCountryID = "\(dataValI)"
        }else{
            userCountryID = "0"
        }
        if let dataValS =  dict["is_participant"] as? Int {
            isParticipant = dataValS
        }else if let dataValI = dict["user_country_id"] as? String {
            isParticipant = Int(dataValI)!
        }else{
            isParticipant = 0
        }
        
        if let dataVal = dict["user_state_id"] as? String {
            userStateId = dataVal
        }else if let dataVals = dict["user_state_id"] as? Int {
            userStateId = "\(dataVals)"
        }else{
            userStateId = "0"
        }
        //CHECK FOR ROLE IS USER == 2 || ADMIN == 1
        if let roleVal =  dict["role_id"] as? Int {
            KAppDelegate.loginTypeVal = roleVal
        }else if let roleVals = dict["role_id"] as? String {
            if roleVals != ""{
                KAppDelegate.loginTypeVal = Int(roleVals) ?? 1
            }
        }else{
            KAppDelegate.loginTypeVal = UserRole.Admin.rawValue
        }
        rating = dict["rating"] as? Float ?? 0
        
        doctorSubPlanDict = dict["user_plan"] as? NSDictionary
        
    }
}
class DoctorModel: NSObject {
    var docName,accessCode,designation,profileFile:String?
    var doctorId = Int()
    func getDrDetail(_ dictDoc:NSDictionary){
        docName = dictDoc["full_name"] as? String ?? ""
        accessCode = dictDoc["access_code"] as? String ?? ""
        designation = dictDoc["designation"] as? String ?? ""
        profileFile = dictDoc["profile_file"] as? String ?? ""
        doctorId = dictDoc["id"] as? Int ?? 0
    }
}
