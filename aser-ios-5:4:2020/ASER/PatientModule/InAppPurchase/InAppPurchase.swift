 //
//  InAppPurchase.swift
//  ios_swift_in_app_purchases_sample
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
import StoreKit

class InAppPurchase : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
	
	static let sharedInstance = InAppPurchase()
	
#if DEBUG
	let verifyReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
#else
	let verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"
#endif
	
    let kInAppProductPurchasedNotification = "InAppProductPurchasedNotification"
    let kInAppPurchaseFailedNotification   = "InAppPurchaseFailedNotification"
    let kInAppProductRestoredNotification  = "InAppProductRestoredNotification"
    let kInAppPurchasingErrorNotification  = "InAppPurchasingErrorNotification"
	var planId = 0

    var autorenewableSubscriptionProductId = ""
	
    var doctoSubsVMobj = DoctorSubscriptionVM()

    
	override init() {
		super.init()
		
		SKPaymentQueue.default().add(self)
	}
	
    // MARK : InAppPurchases Function
    
	func buyProduct(_ product: SKProduct) {
		print("Sending the Payment Request to Apple")
		let payment = SKPayment(product: product)
		SKPaymentQueue.default().add(payment)
	}
	
	func restoreTransactions() {
		SKPaymentQueue.default().restoreCompletedTransactions()
	}
	
	func request(_ request: SKRequest, didFailWithError error: Error) {
		print("Error %@ \(error)")
		NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppPurchasingErrorNotification), object: error.localizedDescription)
	}
    // MARK : InAppPurchases Delegate

	func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
		print("Got the request from Apple")
		let count: Int = response.products.count
		if count > 0 {
			_ = response.products
			let validProduct: SKProduct = response.products[0] 
			print(validProduct.localizedTitle)
			print(validProduct.localizedDescription)
			print(validProduct.price)
			buyProduct(validProduct);
		}
		else {
			print("No products")
		}
	}
	
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		print("Received Payment Transaction Response from Apple");
		
		for transaction: AnyObject in transactions {
			if let trans: SKPaymentTransaction = transaction as? SKPaymentTransaction {
				switch trans.transactionState {
				case .purchased:
					print("Product Purchased")
					
					savePurchasedProductIdentifier(trans.payment.productIdentifier)
					SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "InAppProductPurchasedNotification"), object: transaction.transactionIdentifier as Any?)
                    
                    let param = [
                        "Plan[plan_id]": planId,
                        "Transaction[response]": "",
                        "Transaction[transaction_id]": transaction.transactionIdentifier] as [String: AnyObject]
                    
                    doctoSubsVMobj.sendSubscriptionIdToServer(param: param) {
                        
                    }
                    					
					break
					
				case .failed:
					print("Purchased Failed")
					SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
					NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppPurchaseFailedNotification), object: nil)
					break
					
				case .restored:
					print("Product Restored")
					savePurchasedProductIdentifier(trans.payment.productIdentifier)
					SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
					NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppProductRestoredNotification), object: nil)
					break
					
				default:
					break
				}
			}
			else {
				
			}
		}
	}
	
	func savePurchasedProductIdentifier(_ productIdentifier: String!) {
		UserDefaults.standard.set(productIdentifier, forKey: productIdentifier)
		UserDefaults.standard.synchronize()
	}
	
	
	func unlockProduct(_ productIdentifier: String!)
    {
        
		if SKPaymentQueue.canMakePayments() {
			let productID: NSSet = NSSet(object: productIdentifier)
			let productsRequest: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
			productsRequest.delegate = self
			productsRequest.start()
			print("Fetching Products")
		}
		else {
			print("Сan't make purchases")
			NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppPurchasingErrorNotification), object: NSLocalizedString("CANT_MAKE_PURCHASES", comment: "Can't make purchases"))
		}
	}
    

	
}
