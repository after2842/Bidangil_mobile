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
                //SlideABTest()
            case "main":
                Group {
                    if let profile = sessionManager.profile {
                        MainView(currentView: $currentView, nickname: $sessionManager.nickname, orders: $sessionManager.orders, sessionManager: sessionManager)
                    } else {
                        MainView(currentView: $currentView, nickname: $sessionManager.nickname, orders: $sessionManager.orders, sessionManager: sessionManager)
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
                MainView(currentView: $currentView, nickname: .constant(""), orders: .constant([]), sessionManager: sessionManager)
            }
        }
    }
}
    

struct SlideABTest: View {
    @State private var step:Int = 1   

    private func adjustOffset(in geo: GeometryProxy, eachStep: Int) -> CGFloat {
        if eachStep > step {
            return geo.size.width
        }
        if eachStep < step {
            return -geo.size.width
        }
        return 0



    }


    var body: some View {
        GeometryReader { geo in              // gives us screen width
            ZStack {
                // ── Screen A ──
  
                Text("a")
                    .font(.system(size: 80, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.yellow.opacity(0.2))
                    .offset(x: step == 1 ? 0 : -geo.size.width)
                    .disabled(step != 1)

                // ── Screen B ──
                Text("b")
                    .font(.system(size: 80, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.green.opacity(0.2))
                    .offset(x: step == 2 ? 0 : adjustOffset(in: geo, eachStep: 2))
                    .disabled(step != 2)
                // ── Screen C ──
                Text("C")
                    .font(.system(size: 80, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.red.opacity(0.2))
                    .offset(x: step == 3 ? 0 : adjustOffset(in: geo, eachStep: 3))
                    .disabled(step != 3)
                Text("D")
                    .font(.system(size: 80, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.blue.opacity(0.2))
                    .offset(x: step == 4 ? 0 : adjustOffset(in: geo, eachStep: 4))
                    .disabled(step != 4)
            }.animation(.easeInOut(duration: 0.35), value: step)
            Spacer()
            HStack{
            Button(action: {
       
                step -= 1
            }) {
                Text("Prev")
            }
            Button(action: {
            
                step += 1
            }) {
                Text("Next")
            }
            
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
            if let httpResponse = response as? HTTPURLResponse {
                print("✅ Response status: \(httpResponse.statusCode)")
                
                // Handle token expiration (401 Unauthorized)
                if httpResponse.statusCode == 401 {
                    print("🔄 Token expired, attempting refresh...")
                    if await refreshToken() {
                        // Retry the request with new token
                        return await fetchProfileData()
                    } else {
                        print("❌ Failed to refresh token, redirecting to login")

                        return
                    }
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("✅ Response: \(responseString)")
                }
            }
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


    private func refreshToken() async -> Bool {
        guard let refreshToken = KeychainWrapper.standard.string(forKey: "refresh_token") else {
            print("❌ No refresh token found")
            return false
        }
        
        guard let url = URL(string: "http://127.0.0.1:8000/api/token/refresh/") else {
            print("❌ Invalid refresh URL")
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let refreshPayload = ["refresh": refreshToken]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: refreshPayload)
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let tokenResponse = try? JSONSerialization.jsonObject(with: data) as? [String: String],
                   let newAccessToken = tokenResponse["access"] {
                    KeychainWrapper.standard.set(newAccessToken, forKey: "access_token")
                    print("✅ Token refreshed successfully")
                    return true
                }
            }
            
            print("❌ Failed to refresh token")
            return false
        } catch {
            print("❌ Error refreshing token: \(error)")
            return false
        }
    }