 //
 //  RootControllerProxy.swift
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
 
 class RootControllerProxy {
    static var shared: RootControllerProxy {
        return RootControllerProxy()
    }
    private init(){}
    
    func rootWith(identifier: String){
        let blankController = mainStoryboard.instantiateViewController(withIdentifier: identifier)
        var homeNavController:UINavigationController = UINavigationController()
        homeNavController = UINavigationController.init(rootViewController: blankController)
        //KAppDelegate.mainNavController = homeNavController
        homeNavController.isNavigationBarHidden = true
        KAppDelegate.currentViewCont = blankController
        KAppDelegate.window!.rootViewController = homeNavController
        KAppDelegate.window!.makeKeyAndVisible()
    }
}
