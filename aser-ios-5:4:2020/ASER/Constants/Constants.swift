//
//  WebServiceProxy.swift
//  A.S.E.R.
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
//BORDER : E8E8E8
//BACKGROUND : FAFAFA
enum AppInfo {
    static let Mode       = "production"
    static let AppName    = "ASER"
    static let Version    = "1.0"
    static let DeviceType = "2"
    static let DeviceName = UIDevice.current.name
    static let ZoomLevel  = Float(14.0)
    static let UserAgent  = "\(Mode)/\(AppName)/\(Version)"
    static let EmergencyNo = "911"
}

enum AdminRole:Int{
    case RoleAZ = 0, RoleSTT, Role, RoleDR, RolePT
}
//const SUB_ROLE_AZ = 0;
//const SUB_ROLE_STT = 1;
enum StaticData {
    static let GenderArray  = ["Male", "Female","Others"]
    static let ArrBool      = [["Yes",0],["No",1]]
    static let AdminRole    = [["AZ", "0"], ["STT","1"]]
}
enum BoolVal :Int{
    case FALSE = 0,TRUE
}
enum AppKeys{
    static let GoogleService = "AIzaSyDHkpVIkBLLdfk7vl-qGOM5B3I5CYZfNjo"
    static let GooglePlaces  = "AIzaSyCRhKPMIZLGkzneoI6oQgyfH52D9_Fe-II"
}
enum Colours{
    static let AppColor          = UIColor(red: 114/255, green: 3/255, blue: 3/255, alpha: 1)
    static let PopUpColor        = UIColor(red: 114/255, green: 3/255, blue: 3/255, alpha:0.5)
    static let SuccessColor      = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.0)
    static let DisbaleButtonColo = UIColor(red: 78/255, green: 177/255, blue: 217/255, alpha: 0.6)
    static let lightGreyColor    = UIColor (red: 112.0/255.0, green: 112.0/255.0, blue: 112.0/255.0, alpha: 1.0)
    static let buttonFrndColor   = UIColor(red: 184.0/255.0, green: 184.0/255.0, blue: 184.0/255.0, alpha: 1.0)
    static let PlaceHolderColor  = UIColor(red: 132.0/255.0, green: 132.0/255.0, blue: 132.0/255.0, alpha: 1.0)
}
enum Apis {
 //MARK : COMMON APIS
//    static let KServerUrl       = "http://jupiter.toxsl.in/aser/api/"
    static let KServerUrl       = "https://asernv.org/api/"
//  static let KServerUrl       = "http://192.168.1.61/asernv/api/"
    static let KCheckLogin      = "user/check?access-token="
    static let KSignUp          = "user/signup"
    static let KDoctorPlans     = "user/pricing-list"
    static let KTransactionSuccess = "transaction/success?"
    static let KTransactionUpdateSuccess = "transaction/upgrade-plan?"
//user/login"
    static let KLogIn           = "user/userlogin"
    static let KGetOTP          = "user/otp"
    static let KLogout          = "user/logout"
    static let KProfileComplete = "user/update-profile"
    static let KWebPageData     = "page/get-page?type="
    static let KGetCountryList  = "user/country-code"
    static let KProfileUpdate   = "user/update-profile"
    static let KGetStateList    = "user/state?country_id="
    static let KGetCityList     = "user/city?state_id="
    static let KChangePassword  = "user/change-password"
    static let KRemoveProfile   = "user/remove-image"
    static let KContactUS       = "user/contact-us"
    static let KForgotPassword  = "user/recover"
    static let KFAQ             = "page/faqs"
    static let KEditSurveyQuestion       = "research-program/update?id="
    static let KGetProductCatList        = "research-category/get-categories"
    //MARK :  ADMIN APIS
    static let KSharedResearchList       = "research-program/shared-program-list?page="
    static let KResearchProgList         = "research-program/program-list?page="
    static let KParticipantsList         = "research-program/participate-list?research_id="
    static let KDeleteParticipant        = "research-program/remove-participation"
    static let KAddSurveyQuestion        = "research-program/add" //?access-token=
    static let KParticipantListWhileAdd  = "research-program/participant-list?page="
    static let KAddParticipantToResearch = "research-program/add-participation"
    static let KParticipantProfile       = "user/get-profile?id="
    static let KParticipantProfileUpdate = "user/update-profile?id="
    static let KAdminListForShare        = "research-program/list-administrator?page="
    static let KShareSurveyToAdmin       = "research-program/share-program"
    static let KDeleteResearch           = "research-program/delete-research?id="
    static let KRemoveFromSharedSurvey   = "research-program/remove-shared-user?research_id="
    static let KSurveyReview             = "research-program/survey-review?research_id="
    //MARK :  USER APIS
    static let KEnterResearchIds        = "download-data/?research_id="
    static let KEnterAssignCode          = "research-program/user-code"
    static let KResearchAssignedList     = "research-program/assigned-list"
    static let KSubmitBasicQuest         = "basic-question/add"
    static let KSurveyQuestionList       = "research-program/get-question"    
    static let KResearchProgramDetail    = "research-program/program-details?id="
    static let KDeactivateUserAccount    = "user/delete-account"
    static let KUserGallery              = "user/user-gallary"
    static let KSaveAnswer               = "research-program/save-answer"
    static let KNotification             = "user/user-notifications?access-token="
    static let KForgotPasscode           = "user/forget-passcode?access-token="
    static let KUpdateResearch           = "research-program/get-update-question?research_id="
    static let KUpdatePasscode           = "user/update-passcode?access-token="
    static let KEnableSecurity           = "user/enable-security?access-token="
    static let KDownloadSurveyData       = "research-program/download-data?research_id="
    static let KDailyImagesGallery       = "research-program/get-daily-imge?research_id="
    static let KCheckAccessCode          = "research-program/check-access-code"
    static let KSaveTemplate             = "template/save-as-template?research_id="
    static let KDeleteGalleryImages      = "research-program/delete-gallery-image"
    static let KTemplateList             = "template/list"
    static let KGetTemplateData          = "template/get-template?template_id="
    static let KSetAlarm                 = "user/set-reminder"
    static let KQuestionBankList         = "question-bank/get-questions"
    static let KAddUserResearch          = "research-program/add-participant-research"
    static let KSetView                  = "research-program/set-view?research_id="
    static let KEndSurveyQuestions       = "end-survey-questions/get-questions"
    static let KSubmitEndSurvey          = "end-survey-questions/send-mail"
    
    //MARK:- Doctor Module API
    static let KPatientList              = "doctor/patient-list"
    static let KGetPatientDet            = "doctor/get-patient?id="
    static let KGetPatientAppointments   = "doctor/get-patient-appointments?id="
    static let KGetUpdateAppointment     = "appointment/update-appointment?id="
    static let KAddPrescription          = "prescribed-activities/add-prescription"
    static let KListPrescription         = "prescribed-activities/get-prescription?id="
    static let KEditPrescription         = "prescribed-activities/update-prescription?id="
    static let KDeletePrescription       = "prescribed-activities/delete-prescription?id="
    static let KGetAppointmentReports    = "report/get-appointment-reports?id="
    static let KPatientDelete             = "doctor/remove-patient"
    //MARK:- Patient Module API
    static let KCreateAppointment        = "appointment/create-appointment"
    static let KGetMyAppointment         = "doctor/get-appointments?page="
    static let KGetMyReports             = "report/get-reports"
    static let KAddReport                = "report/add-report"
    static let KChatList                 = "chat/chat-list"
    static let KGetNewMsg                = "chat/get-new-messages?id="
    static let KGetOldMsg                = "chat/get-message?id="
    static let KSendMsg                  = "chat/send-message"
    static let KDeleteReports            = "report/delete-reports"
    static let KChangeRole               = "user/change-patient-type?type="
    static let KGetUnreadCount           = "user/unread-count"
    static let KGetPatientPrescription   = "prescribed-activities/get-patient-prescription?page="
    static let KAddDoctor                = "doctor/add-doctor"

    
    }
enum Gender: Int {
    case Male = 0,Female
}
var mainStoryboard: UIStoryboard{
    
    switch KAppDelegate.loginTypeVal {
    case UserRole.Medical.rawValue, UserRole.Patient.rawValue:
        if KAppDelegate.loginTypeVal == UserRole.Patient.rawValue && KAppDelegate.objUserDetailModel.isParticipant == 1 {
        return UIStoryboard(name: "User", bundle: Bundle.main)
        } else {
        return UIStoryboard(name: "Medical", bundle: Bundle.main)
        }
    case UserRole.User.rawValue:
        return UIStoryboard(name: "User", bundle: Bundle.main)
    case UserRole.Admin.rawValue:
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    default:
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    

}

enum UserRole:Int {
    case Admin = 1, User,Medical,Patient
}
enum UserStatus : Int {
    case InActive = 0, Complete, Incomplete
}
enum AppointmentState : Int {
    case InActive = 0, Active, Pending, Complete
 }
enum GalleryType {
    static let KGallery = "Gallery"
    static let KCamera  = "Camera"
    static let KCancel  =  "Cancel"
}
enum TitleValue {
    static let setting         = "Settings"
    static let cancel          = "Cancel"
    static let deletePhoto     = "Delete Photo"
    static let choosePhoto     = "Choose Photo"
    static let takePhoto       = "Take Photo"
    static let alert           = "Alert"
    static let ok              = "Ok"
    static let REMOVEPARTICIPANTS =  "Remove Participants?"
    static let UNATTENDEDSURVEY   = "Unattended Survey"
}

enum AlertMsgs {
    //MARK : SELECT MESSGES
    static let KEMAILSENT      = "Mail successfully sent"
    static let AGEVALID        = "Entered age is not valid"
    static let ENTERDOCTORCODE = "Please enter doctor code."
    static let SELECTCOUNTRY   = "Please select Country"
    static let SELECTSTATE     = "Please select State/Provience"
    static let SELECTGENDER    = "Please select Gender"
    //MARK : ENTER MESSAGES
    static let ENTERFIRSTNAME      =  "Please enter First Name"
    static let ENTERLASTNAME       =  "Please enter Last Name"
    static let ENTERAGE            =  "Please enter age"
    static let ENTERPHONENOS       =  "Please enter phone number"
    static let VALIDPHONENOS       =  "Please enter valid phone number"
    static let ENTERZIPCODE        =  "Please enter Zip-Code/Postal-Code"
    static let VALIDZIPCODE        =  "Please enter valid Zip-Code/Postal-Code"
    static let ENTERCITY           =  "Please enter city"
    static let ENTERAPART          =  "Please enter apartment details"
    static let ENTERSTREET         =  "Please enter street"
    static var COMMENT             =  "Please enter your message."
    static var NAME                =  "Please enter name"
    static var validName           =  "Please enter valid name"
    static var email               =  "Please enter email"
    static var validEmail          =  "Please enter valid email"
    static var phoneNumber         =  "Please enter phone number or email"
    static var enterRole           =  "Please enter admin roll"
    static var acceptTerms         =  "Please accept term and conditions"
    static var phoneNumberVal      =  "Please enter mobile number"
    static var password            =  "Please enter password"
    static var validPassword       =  "Password should have minimum 8 characters"
    static var newPassword         =  "Please enter new password"
    static var repeatPassword      =  "Please enter new repeat password"
    static var confirmPassword     =  "Please enter confirm password"
    static var wrongConfirmPassword =  "Confirm password is not correct"
    static var notMatchpassword     =  "Password does not match"
    static var accountHolderName    =  "Please enter account holder name"
    static var changePasswordSuccessfully =  "Passowrd changed successfully"
    static var selectProfileImage   =  "Please select image for your profile"
    static var oldPassword          =  "Please enter old password"
    static var passwordSame         =  "Password should be same"
    static var reviewNetwork        = "Please Review your network settings"
    static var enableJsonEncode     = "Error: Unable to encode JSON Response"
    static var errorServerResponse  = "Error: Unable to get response from server"
    static var userLoggedOut        = "User logged out successfully"
    static var eventStartDate       = "Please select start date & time"
    static var selectStartDate      = "Please select start date first"
    static var enterDOB             = "Please enter date of birth"
    static var cameraNotSupport     =  "Camera is not supported"
    static var cammeraNotAccess     =  "Unable to access the Camera"
    static let openSettingCamera    =  "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app."
    static let LOGOUT               = "Successfully Logged Out"
    static let PROFILEUPDATED       = "Profile updated successfully"
    static let FAILSIGNUP           = "Fail to sign up. Try again"
    static let CHANGEPWD            = "Password updated"
    static let PASSCODESAVED        = "Passcode saved successfully"
    static let ENTERASSIGNCODE      = "Please enter doctor's code"
    static let FAILEDLOAD           = "Failed to load data please try again after sometime"
    static let KSELECTROLE          = "Please select role to proceed"
    static let KEnterPasscode       = "Please enter passcode"
    static let KIncorrectPasscode   = "Passcode is incorrect. Try again.."
    static let KCONFIRMACCOUNTDELETE = "Are you sure want to delete your acount ?"
    static let KACCOUNTDELETED      = "Account deleted successfully"
    static let KREMOVEPARTICIPANTS  = "Are you sure want to remove participant from research ?"
    static let KADDPARTICIPANTS     = "Do you want to add this participant to the research ?"
    static let KPARTICIPANTSADDED   = "Participant added to the research."
    static let ENTERDESIGNATION     = "Please enter your designation"
    static let SKIPEDSUREYMESSAGE   = ""
    static let SURVEYREMOVED        = "Survey removed successfully"
    static let KSHARERESEARCHWITHADMIN = "Do you want to share this research with selected admin ?"
    static let AREYOUSUREWANTTODELETETHISSURVEY = "Are you sure want to delete this survey ?"
    static let AREYOUSUREWANTTODELETEPRESCRIPTION = "Are you sure want to delete this prescription ?"
    static let DOYOUWANTOREMOVETHISADMINFROMSHAREDLIST = "Do you want to remove this admin from the shared list ?"
    static let KOldPassCodeIncorrect  = "Confirm Passcode is incorrect"
    static let EnterTitle             = "Please Enter Template Title"
    static let EnterDescription       = "Please Enter Template Description"
    static let TemplateSaved          = "Template Saved Successfully"
    static let SelectTime             = "Please Select Time"
    static let AlarmSetSuccess        = "Alarm Set Successfully"
    static let AlarmSetRemoved        = "Alarm Removed Successfully"
    static let PaymentAlert           = "Please select subscription package"
    static let passcodeAlert          = "Please check your registered email to receive your passcode"
}
enum WebPage:Int{
    case ABOUT_US = 0, GUIDELINES, PRIVACY, TERMS
}
enum Options:Int{
    case  NO_OPTION = 0, MULTIPLE, CHOOSE_ONE, TYPE_ANS    
}

struct ApiResponse {
    var data: NSDictionary?
    var success: Bool
    var message: String?
}

struct ApiResponse2 {
    var success : String
    var urlname : String
    var download_link : String
}
