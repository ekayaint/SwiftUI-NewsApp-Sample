//
//  SettingsView.swift
//  SwiftUI-NewsApp-Sample
//
//  Created by ekayaint on 22.10.2023.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @StateObject var purchaseViewModel = PurchaseViewModel()
    @AppStorage("purchased") var purchased = false
    
    func buy(product: Product) async {
        do {
            if try await purchaseViewModel.purchase(product) != nil {
                purchased = true
            }
        } catch {
            print("Purchase failed.")
        } //: do
    }
    
    var body: some View {
        NavigationStack {
            if purchased == false {
                VStack{
                    Text("Subscribe to access settings.")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    
                    Spacer()
                    
                    Image(systemName: "lock.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .padding(.bottom)
                    
                    Text("Unlock all features with a subsciption")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                    
                    HStack(spacing: 30) {
                        Button {
                            Task {
                                let viewModel = purchaseViewModel
                                await buy(product: viewModel.subscriptions[1])
                            }
                            
                        } label: {
                            VStack{
                                Text("Monthly")
                                    .font(.headline)
                                Text("3.99/Month")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            } //: VStack
                        } //: Button
                        
                        Button {
                            Task {
                                await buy(product: purchaseViewModel.subscriptions.first!)
                            }
                            
                        } label: {
                            VStack{
                                Text("Yearly")
                                    .font(.headline)
                                Text("39.99/Year")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            } //: VStack
                        } //: Button
                        
                    } //: HStack
                    
                    Spacer()
                    
                    Text("By subscribing, you agree to the terms of use and privacy policy.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.bottom)
                    
                } //: VStack
                .padding()
                .preferredColorScheme(.dark)
            } else {
                Form {
                    Section("About") {
                        Text("This app keeps you up to date on the latest news. Premium content coming soon.")
                    }
                } //: form
                .navigationTitle("Settings")
                .preferredColorScheme(.dark)
            } //: if
        } //: Nav
        .task {
            if purchaseViewModel.purchasedSubscriptions.isEmpty {
                purchased = false
            } else {
                purchased = true
            }
        }
    }
}

#Preview {
    SettingsView()
}
