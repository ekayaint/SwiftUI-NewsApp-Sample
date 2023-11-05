//
//  PurchaseViewModel.swift
//  SwiftUI-NewsApp-Sample
//
//  Created by ekayaint on 29.10.2023.
//

import Foundation
import StoreKit

typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

class PurchaseViewModel: ObservableObject {
    @Published  var subscriptions: [Product] = []
    @Published  var purchasedSubscriptions: [Product] = []
    @Published  var subscriptionGroupStatus: RenewalState?
    
    private let productIds: [String] = ["subscription.yearly", "subscription.monthly"]
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    init() {
        updateListenerTask = listenForTransactions()
        Task {
            await requestProducts()
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    @MainActor
    func requestProducts() async {
        do {
            subscriptions = try await Product.products(for: productIds)
        } catch {
            print("Failed product request from app store server \(error)")
        }
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updateCustomerProductStatus()
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                } //: do
            } //: for
        } //: return
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        } //: switch
    }
    
    @MainActor
    func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                switch transaction.productType {
                case .autoRenewable:
                    if let subscriptions = subscriptions.first(where: { $0.id == transaction.productID }) {
                        purchasedSubscriptions.append(subscriptions)
                    }
                default:
                    break
                }
            
                await transaction.finish()
            } catch {
                print("Failed updating products")
            } //: do
        } //: for
    }
    
    func purchase (_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updateCustomerProductStatus()
            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        } //: switch
    }
    
    
}

enum StoreError: Error {
    case failedVerification
}
