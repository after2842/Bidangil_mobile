//
//  BidangilApp.swift
//  Bidangil
//
//  Created by Samuel Choi on 6/24/25.
//

import SwiftUI
import Foundation
import SwiftKeychainWrapper
import StripePaymentSheet
@main
struct BidangilApp: App {
    @State public var currentView: String = "login" 
    @State public var usrData: Bool = false
    @StateObject private var sessionManager = UserSessionManager()
    
    init() {StripeAPI.defaultPublishableKey = "pk_test_51PtQWTC3qQke2faE0Bp08gJUbuyVxPbqYrYbkpMU6GaVNInI4gaJblF7x98IJddLwkI9CUGTipocwFyPJhum9moT00cNtFKwfp"}
    
    var body: some Scene {
        WindowGroup {
            switch currentView {
            case "login":
                LoginLandingView(currentView: $currentView)
            case "main":
                Group {
                    if let profile = sessionManager.profile {
                        MainView(currentView: $currentView, nickname: $sessionManager.nickname, orders: $sessionManager.orders)
                    } else {
                        MainView(currentView: $currentView, nickname: $sessionManager.nickname, orders: $sessionManager.orders)
                            .task {
                                print("Fetching profile data...")
                                await sessionManager.fetchProfileData()
                                print("Profile data loaded...!")
                            }
                    }
                }
            case "order":
                Order(currentView: $currentView)
            default:
                MainView(currentView: $currentView, nickname: .constant(""), orders: .constant([]))
            }
        }
    }
}
struct ProfileResponse: Codable, Equatable {
    let msg: String
    let data: [OrderData]
    let nickname: String
}

struct OrderData: Codable, Identifiable, Equatable {
    let id: Int
    let address: String
    let order_created_at: String
    let exchange_rate: String
    let items: [OrderItemData]
    let Payment: PaymentData?
    let Delivery: DeliveryData?
    let Steps: [StepData]?

}

struct OrderItemData: Codable, Identifiable, Equatable {
    let id: UUID = UUID()
    let url: String
    let description: String
}

struct PaymentData: Codable, Equatable {
    let item_price: Double?
    let delivery_price: Double?
    let total_price: Double?
    let item_is_paid: Bool
    let delivery_is_paid: Bool
    let stripe_item_url: String?
    let stripe_delivery_url: String?
}

struct DeliveryData: Codable, Equatable {
    let delivery_start_at: String
    let courier: String
    let tracking_number: String
    let delivered_at: String
}

struct StepData: Codable, Equatable {
    let label: String
    let isDone: Bool
}

class UserSessionManager: ObservableObject, @unchecked Sendable {
    @Published var profile: ProfileResponse?
    @Published var orders: [OrderData] = []
    @Published var nickname: String = ""
    
    func fetchProfileData() async {
        guard let token = KeychainWrapper.standard.string(forKey: "access_token") else { return }

        guard let url = URL(string: "http://127.0.0.1:8000/api/profile_info/") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print("Raw data received: \(String(data: data, encoding: .utf8) ?? "Could not decode")")
            let decoded: ProfileResponse = try JSONDecoder().decode(ProfileResponse.self, from: data)
            print("breakpoint 1")
            DispatchQueue.main.async {
                self.profile = decoded
                self.orders = decoded.data
                self.nickname = decoded.nickname
                
                // Print the loaded data
                print("💕 orders: \(decoded.data)")
                print("📱 Nickname: \(decoded.nickname)")
                print("📦 Orders count: \(decoded.data.count)")
                
                // Print orders as JSON
                do {
                    let ordersData = try JSONEncoder().encode(decoded.data)
                    if let ordersString = String(data: ordersData, encoding: .utf8) {
                        print("📦 Orders JSON:")
                        print(ordersString)
                    }
                } catch {
                    print("❌ Failed to encode orders: \(error)")
                }
            }
            print("Profile data loaded\(response)")
        } catch {
            print("❌ Failed to load profile: \(error.localizedDescription)")
            print("❌ Failed to load profile: \(error)")
        }
    }
}