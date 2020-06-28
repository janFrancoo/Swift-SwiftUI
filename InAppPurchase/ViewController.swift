//
//  ViewController.swift
//  InAppPurchaseTest
//
//  Created by JanFranco on 28.06.2020.
//  Copyright © 2020 janfranco. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var productsRequest = SKProductsRequest()
    var validProducts = [SKProduct]()
    var productIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let productIdentifiers = NSSet(objects:
            "com.jfranco.gatetmp.coin"         // 0
        )
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    @IBAction func purchaseCoins(_ sender: Any) {
        // this func must be called after product response
        // can be guarded, just an ex
        productIndex = 0
        purchaseMyProduct(validProducts[productIndex])
    }
    
    @IBAction func restoreCoins(_ sender: Any) {
        restorePurchase()
    }
    
    func productsRequest (_ request:SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count > 0 {
            validProducts = response.products
            let twoKCoins = response.products[0] as SKProduct
            print("1st rpoduct: " + twoKCoins.localizedDescription)
        } else {
            print("no product")
        }
    }
    
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if productIndex == 0 {
                        print("You've bought 2000 coins!")
                        fetchReceipt()
                    }
                    break
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    print("Payment has failed.")
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    print("Purchase has been successfully restored!")
                    break
                default: break
        }}}
    }
    
    func purchaseMyProduct(_ product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            print("Purchases are disabled in your device!")
        }
    }

    func restorePurchase() {
        SKPaymentQueue.default().add(self as SKPaymentTransactionObserver)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
        
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("The Payment was successfull!")
    }
    
    func fetchReceipt() {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
                do {
                    let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                    let receiptString = receiptData.base64EncodedString(options: [])
                    print(receiptString)
                    // send receiptString to api for check purchase
                } catch {
                    print("Couldn't read receipt data with error: " + error.localizedDescription)
                }
        }
    }
    
}
