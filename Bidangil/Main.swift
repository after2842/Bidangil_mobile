//
//  Main.swift
//  Bidangil
//
//  Created by Samuel Choi on 6/24/25.
//
import SwiftUI


struct MainView: View {
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    private var current = 2
    private let steps = ["주문 접수", "상품결제", "상품구매", "배송비 결제"]
    @State private var togglemenu: Bool = false


    var body: some View {
        ZStack(alignment: .top) {
            // ① background layer
            TopSplashBackground()

            // ② foreground UI
            VStack(alignment: .center, spacing: 24) {

                // profile button aligned to the right
                HStack {
                    Spacer()
                    Button{}label: {
                        Image(systemName: "message.fill").foregroundColor(.white)
                        Text("도와드릴까요?").font(.body).foregroundColor(.white)

                    }.frame(maxWidth: .infinity, alignment: .leading)
                    Button {
                        print("Profile tapped")
                        togglemenu = !togglemenu
                    } label: {
                        Circle()
                            .stroke(.white)
                            .frame(width: 35, height: 35)
                            .overlay(Image(systemName: "person.fill")
                                .foregroundColor(Color.white))
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.top, 60)
                .padding(.horizontal)
             
Spacer()

               
                CurrentOrderCard(
                    title: "Order #123-456",
                    progress: .init(steps: steps, currentStep: current),
          
                    accent: .blue
                )
                
                
                HStack{PastOrder(title: "이전 주문")
                    PastOrder(title:"결제")}
                Spacer()
                

                



                // call-to-action button
                Button {
                    print("Cart tapped")
                } label: {
                    Text("주문하기")
                        .font(.system(size: 25, weight: .medium))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(hue: 0.574,
                                          saturation: 0.871,
                                          brightness: 0.935,
                                          opacity: 0.925))
                        .cornerRadius(100)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 55)
            .frame(maxWidth: .infinity, maxHeight: .infinity,
                   alignment: .bottom)
            
            if togglemenu{
                Rectangle().frame(maxWidth: .infinity, maxHeight: .infinity).edgesIgnoringSafeArea(.all).shadow(radius: 10).foregroundColor(Color.white).ignoresSafeArea().padding(.top,20)
            }
           
        }
        .ignoresSafeArea()
        


        
    }
}



struct OrderProgress {
    var steps: [String]          // e.g.
    var currentStep: Int         // index of LAST completed step (–1 if none yet)
}

struct CurrentOrderCard: View {
    let title: String
    let progress: OrderProgress
    var accent: Color = .blue
    
    // Keep the dot size in one place so the layout is predictable
    private let dotSize: CGFloat = 18
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(        LinearGradient(stops: [
                    .init(color: Color.blue,  location: 0.00),   // top colour
                    .init(color: Color.blue,  location: 0.33),   //      ─┤
                    .init(color: Color(white: 0.95), location: 0.33),   // bottom colour
                    .init(color: Color(white: 0.95), location: 1.00)
                ], startPoint: .top, endPoint: .bottom))
            
            
            
            VStack{
                VStack{
                    HStack{                    Image(systemName: "house.fill")
                        .foregroundColor(.white)
                    Text("3630 Westminister Ave")
                        .font(.caption)
                    
                    
                    
                }
                    HStack{                                  Image(systemName: "tag.fill")
                            .foregroundColor(.white)
                        Text("에이블리, 무신사 외3")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    }
                    
                    
                }.padding(.top, 8)


                Spacer()

                
                VStack(spacing: 8) {
                    // ─── Row 1: dots + connectors ───
                    HStack(spacing: 0) {
                        ForEach(progress.steps.indices, id: \.self) { index in
                            // dot column
                            StepDot(
                                isComplete: index <= progress.currentStep,
                                accent: accent
                            )
                            .frame(width: 18, height: 18)
                            .frame(maxWidth: .infinity)
                            
                            // connector column (skip after last dot)
                            if index < progress.steps.count - 1 {
                                Rectangle()
                                    .fill(index < progress.currentStep
                                          ? accent
                                          : Color.gray.opacity(0.3))
                                    .frame(height: 2)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // ─── Row 2: labels + *placeholder* columns ───
                    HStack(spacing: 0) {
                        ForEach(progress.steps.indices, id: \.self) { index in
                            // label column
                            Text(progress.steps[index])
                                .font(.caption)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            // placeholder column (same spot as connector above)
                            if index < progress.steps.count - 1 {
                                Spacer()                      // invisible, takes the width
                                    
                            }
                        }
                    }
                    .padding(.horizontal, 0)
                    
                   
                }
Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width*0.85, height: UIScreen.main.bounds.height*0.2)
    }
}



/// Small circle that “lights up” when complete
private struct StepDot: View {
    let isComplete: Bool
    let accent: Color

    var body: some View {
        Circle()
            .strokeBorder(accent, lineWidth: isComplete ? 0 : 2)
            .background(Circle().fill(isComplete ? accent : Color.clear))
            .frame(width: 20, height: 20)
            .shadow(color: isComplete ? accent.opacity(0.4) : .clear,
                    radius: isComplete ? 6 : 0)
            .padding(.vertical, 4)
            .animation(.easeInOut(duration: 0.25), value: isComplete)
    }
}

struct PastOrder: View {
    let title: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(white: 0.95))
                .frame(width: UIScreen.main.bounds.width*0.41, height: 50)

            Text(title)
                .font(.headline)
                .foregroundColor(.black)
        }
    }
}

struct AddressInputView: View {
    @State private var fullName: String = ""
    @State private var streetAddress: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zipCode: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {


            Group {
                TextField("이름 (Name)", text: $fullName)
                TextField("Street Address", text: $streetAddress)
                TextField("City", text: $city)
                TextField("State (e.g. CA)", text: $state)
                TextField("ZIP Code", text: $zipCode)
                    .keyboardType(.numberPad)
            }
            .padding(12)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.3), lineWidth: 1)
            )
            .autocapitalization(.words)

            Spacer()
        }
        .padding()
    }
}

struct TopSplashShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: .zero)                               // top-left
        p.addLine(to: CGPoint(x: rect.maxX, y: 0))      // top-right
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.65))

        // Wave ①
        p.addCurve(to: CGPoint(x: rect.midX, y: rect.maxY),
                   control1: CGPoint(x: rect.maxX * 0.85, y: rect.maxY * 0.9),
                   control2: CGPoint(x: rect.maxX * 0.65, y: rect.maxY))

        // Wave ②
        p.addCurve(to: CGPoint(x: 0, y: rect.maxY),
                   control1: CGPoint(x: rect.maxX * 0.35, y: rect.maxY),
                   control2: CGPoint(x: rect.maxX * 0.1,  y: rect.maxY * 0.85))

        p.closeSubpath()
        return p
    }
}

struct TopSplashBackground: View {
    private let splashColor = Color(hue: 0.574,
                                    saturation: 0.871,
                                    brightness: 0.935,
                                    opacity: 0.925)

    var body: some View {
        TopSplashShape()
            .fill(splashColor)
            .frame(height: UIScreen.main.bounds.height / 2)
            .frame(maxWidth: .infinity, alignment: .top)
            .ignoresSafeArea()               // extend under status-bar / notch
    }
}
#Preview {
    MainView()
}
