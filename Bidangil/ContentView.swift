//
//  ContentView.swift
//  Bidangil
//
//  Created by Samuel Choi on 6/24/25.
//

import SwiftUI
import Foundation
import SwiftKeychainWrapper

let baseURL = "http://127.0.0.1:8000"

// 2. What we expect back from Django
struct Tokens: Decodable {
    let access:  String
    let refresh: String
}

// 3. One simple async/await login function
func login(email: String, password: String) async -> Tokens? {

    guard let url = URL(string: "\(baseURL)/api/token/") else {
        print("Bad baseURL")
        return nil
    }

    // Build POST request with JSON body
    var req = URLRequest(url: url)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.httpBody = try? JSONEncoder().encode(["username": email, "password": password])

    do {
        let (data, response) = try await URLSession.shared.data(for: req)
        let http = response as! HTTPURLResponse

        if http.statusCode == 200 {
            // success path
            if let tok = try? JSONDecoder().decode(Tokens.self, from: data) {
                return tok
            } else {
                print("✅ 200 but JSON didn’t match Tokens")
                return nil
            }
        } else {
            
            if let json = try? JSONSerialization.jsonObject(with: data) {
                print("❌ \(http.statusCode) JSON error:", json)
                print("not serializable")
            } else if let text = String(data: data, encoding: .utf8) {
                print("❌ \(http.statusCode) plain error:", text)
            } else {
                print("❌ \(http.statusCode) (no body)")
            }
            return nil
        }
    } catch {
        print("Network or decode error:", error.localizedDescription)
        return nil
    }
}


struct ContentView: View {
    @Binding var currentView: String
    func signin() {
        print("sign-up 버튼이 눌렸습니다.")
       
    }


    var body: some View {
        NavigationStack {
        VStack {
            Text("한국에서 물건 사기 어려울 때는")
            Text("비단길")
                .font(.system(size: 80, weight: .bold, design: .default))
                .fontWeight(.black)
                .multilineTextAlignment(.center)
            
            
        }.padding(.bottom, -10)
        
            
            VStack {
                NavigationLink(destination:LoginView(currentView: $currentView)){
                    Text("로그인")
                        .font(.system(size: 23))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .frame(width: 360)
                        .padding(.vertical, 10)
                        .background(Color(hue: 0.574, saturation: 0.871, brightness: 0.935, opacity: 0.868))
                        .foregroundColor(Color.black)
                        .cornerRadius(100)
                    
                    
                }
                Button(action: {
                    signin()
                }) {
                    Text("회원가입")
                        .font(.system(size: 23))
                        .fontWeight(.semibold)
                        .frame(width: 360)
                        .padding(.vertical, 10)
                        .background(Color(hue: 0.637, saturation: 0.012, brightness: 0.889))
                        .foregroundColor(Color.black)
                        .cornerRadius(100)
                    
                    
                }
                
                
                
            }.padding(.top, 100)
            
            
        }
       
        
    }
    }


struct TabView: View {
    var body: some View{
        VStack{
            Text("TabView")
        }
    }
}


struct LoginView: View {
    @Binding var currentView: String
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {

       
            Spacer()

            TextField("이메일", text: $email)
                .padding(12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 0.2)
                )
                .autocapitalization(.none)
                .keyboardType(.emailAddress)

            TextField("비밀번호", text: $password)
                .padding(12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 0.2)
                )
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            Button(action: {
                print("Logging in with \(email) / \(password)")
                Task {
                    if let tok = await login(email: email, password: password) {
                        let access_tok = tok.access
                        let refresh_tok = tok.refresh
                        
                        KeychainWrapper.standard.set(access_tok, forKey: "access_token")
                        KeychainWrapper.standard.set(refresh_tok, forKey: "refresh_token")
                        print("✅ logged in! access: \(tok.access)…")
                        DispatchQueue.main.async {
                            currentView = "main"
                        }
                    } else {
                        print( "❌ login failed")
                    }
                }
            }) {
                Text("로그인")
                    .fontWeight(.semibold)
                    .font(.system(size: 23))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color(red: 0.233, green: 0.632, blue: 0.947))
                    .foregroundColor(.black)
                    .cornerRadius(100)
            }
            Button(action: {
                print("Logging in with \(email) / \(password)")
            }) {
                Text("비밀번호가 생각이 안나요")
                    .fontWeight(.regular)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.black)
                    .cornerRadius(100)
            }
            Spacer()
        }
        .padding(32)
    }
}



public struct LoginLandingView: View {
    @Binding var currentView: String
    
    public init(currentView: Binding<String>) {
        self._currentView = currentView
    }
    
    public var body: some View {
        ContentView(currentView: $currentView)
    }
}

