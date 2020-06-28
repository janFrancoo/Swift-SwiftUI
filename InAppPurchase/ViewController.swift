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
            "com.jfranco.gatetmp.coin250",
            "com.jfranco.gatetmp.coin500",
            "com.jfranco.gatetmp.coin1000",
            "com.jfranco.gatetmp.sub1m",
            "com.jfranco.gatetmp.sub3m"
        )
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    @IBAction func purchaseCoins(_ sender: Any) {
        // this func must be called after product response
        // can be guarded, just an ex
        productIndex = 3
        purchaseMyProduct(validProducts[productIndex])
    }
    
    @IBAction func restoreCoins(_ sender: Any) {
        restorePurchase()
    }
    
    func productsRequest (_ request:SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count > 0 {
            validProducts = response.products
            for product in response.products {
                print(product.localizedTitle, product.localizedDescription)
            }
        } else {
            print("No products")
        }
    }
    
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    fetchReceipt()
                    break
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    print("Payment has failed.")
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    fetchReceipt()
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
        fetchReceipt()
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
