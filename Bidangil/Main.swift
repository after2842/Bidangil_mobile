//
//  Main.swift
//  Bidangil
//
//  Created by Samuel Choi on 6/24/25.
//
import SwiftUI
import StripePaymentSheet

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
            .ignoresSafeArea()               
    }
}
    //0: no item payment required
    //1: item payment required but not fulfilled
    //2: item payment fulfilled and delivery payment not required
    //3: item payment fulfilled and delivery payment required
    //4: item payment fulfilled and delivery payment fulfilled
struct PaymentButton: View {
   
    let title: String
    @Binding var currentStep: Int
    @Binding var paymentInfo: Int
    @Binding var showNotification: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12 )
                .fill(Color(white: 0.95))
                .frame(width: UIScreen.main.bounds.width*0.41, height: 50)
            
            Button(action: {
                print("PaymentButton tapped")
                showNotification = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showNotification = false
                }
            }) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
            }

            CheckoutView(currentStep: $currentStep, paymentInfo: $paymentInfo)

        }
    }
}

struct ProfileMenuView: View {
    @Binding var isPresented: Bool
    @State private var showOrderHistory = false
    @State private var showMyprofile = false
    @State private var showSettings = false
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.white.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                Button(action: { showMyprofile = true }) {
                HStack(){
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray)
                    Text("내 정보")
                        .font(.system(size: 20))
                        .padding()
                        .foregroundColor(.black)
                }
                }.sheet(isPresented: $showMyprofile) {
                    MyProfileView(isPresented: $showMyprofile)
                }
                Button(action: { showOrderHistory = true }) {
                    HStack {
                        Image(systemName: "cart.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.gray)
                        Text("주문 내역")
                            .font(.system(size: 20))
                            .padding()
                            .foregroundColor(.black)
                    }
                }
                .sheet(isPresented: $showOrderHistory) {
                    OrderHistoryView(isPresented: $showOrderHistory)
                }   
                Button(action: { showSettings = true }) {
                HStack(){
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray)
                    Text("설정")
                        .font(.system(size: 20))
                        .padding()
                        .foregroundColor(.black)
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView(isPresented: $showSettings)
                }
                }
                HStack(){
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray)
                    Text("로그아웃")
                        .font(.system(size: 20))
                        .padding()
                }   
                Divider().padding(.horizontal, 20)
                VStack(alignment: .leading, spacing: 8){
                    Text("고객상담") 
                        .font(.system(size: 14))
                        .padding()
                
                    Text("버전 1.0.0") 
                        .font(.system(size: 14))
                        .padding()
                  
                    Text("개인정보 처리방침")
                        .font(.system(size: 14))
                        .padding()
              
                    Text("서비스 이용약관")
                        .font(.system(size: 14))
                        .padding()
                }
                Spacer()
            }.padding(.leading, 20)

        }
    }
}

struct OrderHistoryView: View {
    @Binding var isPresented: Bool
    var body: some View {
        ZStack(alignment: .topTrailing){
            Color.white.ignoresSafeArea()
        VStack(alignment: .leading, spacing: 16){ 
        HStack{
            Spacer()
        Image(systemName:"minus")
            .resizable()
            .frame(width: 32, height: 4)
            .foregroundColor(.gray)
            .padding()
            .onTapGesture {
                isPresented = false
            }      
            Spacer()
        
        }

      
            Text("주문 내역 페이지")
                .font(.system(size: 20))
                .padding()
        }
        }
    }
}

struct MyProfileView: View {
    @Binding var isPresented: Bool
    var body: some View {
        ZStack(alignment: .topTrailing){
            Color.white.ignoresSafeArea()
        VStack(alignment: .leading, spacing: 16){ 
        HStack{
            Spacer()
        Image(systemName:"minus")
            .resizable()
            .frame(width: 32, height: 4)
            .foregroundColor(.gray)
            .padding()
            .onTapGesture {
                isPresented = false
            }      
            Spacer()
        
        }

      
            Text("내 정보 페이지")
                .font(.system(size: 20))
                .padding()
        }
        }
    }
}

struct SettingsView: View {
    @Binding var isPresented: Bool
    var body: some View {
        ZStack(alignment: .topTrailing){
            Color.white.ignoresSafeArea()
        VStack(alignment: .leading, spacing: 16){ 
        HStack{
            Spacer()
        Image(systemName:"minus")
            .resizable()
            .frame(width: 32, height: 4)
            .foregroundColor(.gray)
            .padding()
            .onTapGesture {
                isPresented = false
            }      
            Spacer()
        
        }

      
            Text("알림설정")
                .font(.system(size: 20))
                .padding()
                .foregroundColor(.black)
            Text("개인정보 및 보안")
                .font(.system(size: 20))
                .padding()
                .foregroundColor(.black)
            Text("결제수단")
                .font(.system(size: 20))
                .padding()
                .foregroundColor(.black)
        }
        }
    }
}


struct MainView: View {
    @Binding var currentView: String
    @Binding var nickname: String
    @Binding var orders: [OrderData]
    @ObservedObject var sessionManager: UserSessionManager
    private let steps = ["주문접수", "상품 결제", "물건도착", "배송비 결제", "배송출발", "배송중", "배송완료"]
    @State private var togglemenu: Bool = false
    @State private var showOrder = false
    @State private var currentStep: Int = 0
    @State private var paymentInfo: Int = 0
    @State private var showNotification: Bool = false
    @State private var expandCard: Bool = false

    
    private var lastOrder: OrderData {
        return orders.last ?? OrderData(id: 0, address: "", order_created_at: "", exchange_rate: "", items: [], Payment: nil, Delivery: nil, Steps: nil)
    }
    
    private var lastOrderBinding: Binding<OrderData> {
        Binding(
            get: { self.lastOrder },
            set: { newValue in
                if let lastIndex = self.orders.indices.last {
                    self.orders[lastIndex] = newValue
                }
            }
        )
    }
    
    private func updateCurrentStep() {
        print("updateCurrentStep called, orders count: \(orders.count)")
        guard !orders.isEmpty, let orderSteps: [StepData] = orders.last?.Steps else { 
            print("No steps found")
            currentStep = 0
            return 
        }
        var count = 0
        for step: StepData in orderSteps {
            print("step: \(step.isDone)")
            if step.isDone {
                count += 1
            }
        }
        if count == 6{
            count = 7
            }
    
        print("Setting currentStep to: \(count)")
        currentStep = count

    }
    //0: no item payment required
    //1: item payment required but not fulfilled
    //2: item payment fulfilled and delivery payment not required
    //3: item payment fulfilled and delivery payment required
    //4: item payment fulfilled and delivery payment fulfilled
    private func updatePaymentInfo(){
        guard !orders.isEmpty, let orderPayment: PaymentData = orders.last?.Payment else { 
            paymentInfo = 0 //no item payment required
            print("No payment info found")
            return
            }
        if orderPayment.item_price != nil{
            if orderPayment.delivery_price == nil && !orderPayment.item_is_paid{ //item payment required 
                paymentInfo = 1
            } 
            if orderPayment.delivery_price == nil && orderPayment.item_is_paid{ //item payment fulfilled but delivery payment not required
                paymentInfo = 2
            } 
            if orderPayment.delivery_price != nil && !orderPayment.delivery_is_paid{ //delivery payment required
                paymentInfo = 3
            } 
            if orderPayment.delivery_price != nil && orderPayment.delivery_is_paid{ //delivery payment fulfilled
                paymentInfo = 4
            }
        }else{
            paymentInfo = 0
        }
        print("paymentInfo: \(paymentInfo)")
    }
    
    private func refreshData() async {
        print("🔄 Refreshing data...")
        // Re-fetch profile data from the server
        await sessionManager.fetchProfileData()
        updateCurrentStep()
        updatePaymentInfo()
        print("✅ Data refreshed")
    }
    
    public init(currentView: Binding<String>, nickname: Binding<String>, orders: Binding<[OrderData]>, sessionManager: UserSessionManager) {
        self._currentView = currentView
        self._nickname = nickname
        self._orders = orders
        self.sessionManager = sessionManager
    }


        var body: some View {
        let _ = print("MainView body called, orders count: \(orders.count)")
        return ZStack(alignment: .top) {
            // ① background layer
            TopSplashBackground()

                        // ② foreground UI
            VStack() {
                // Fixed header
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
                .padding(.bottom, 20)
                
                // Scrollable middle section
                Spacer()
                VStack(spacing: expandCard ? UIScreen.main.bounds.height * 0.33 : UIScreen.main.bounds.height*0.05){
                ScrollView {
                    VStack(spacing: 24) {
                
                        Spacer()
                        
                        // Show CurrentOrderCard with a real binding if possible, else use a constant
                        if let lastIndex = orders.indices.last {
                 
                            CurrentOrderCard(
                                title: String(orders[lastIndex].id),
                                progress: .init(steps: steps, currentStep: currentStep),
                                accent: .blue,
                                order: $orders[lastIndex],
                                expandCard: $expandCard
                                
                            ).onTapGesture {
                               
                                expandCard.toggle()
                            }.animation(.easeInOut(duration: 0.3), value: expandCard)
                            
                        } else {
                     
                            CurrentOrderCard(
                                title: "",
                                progress: .init(steps: steps, currentStep: 0),
                                accent: .blue,
                                order: .constant(OrderData(id: 0, address: "", order_created_at: "", exchange_rate: "", items: [], Payment: nil, Delivery: nil, Steps: nil)),
                                expandCard: $expandCard
                            ).onTapGesture {
                        
                                expandCard.toggle()
                            }.animation(.easeInOut(duration: 0.3), value: expandCard)
                        }
                        
                        
                        HStack{PaymentButton(title: "이전 주문", currentStep: $currentStep, paymentInfo: $paymentInfo, showNotification: $showNotification)
                            PaymentButton(title:"결제", currentStep: $currentStep, paymentInfo: $paymentInfo, showNotification: $showNotification)}.animation(.easeInOut(duration: 0.3), value: expandCard)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal)
                }
                .refreshable {
                    await refreshData()
                }
                .scrollIndicators(.hidden)
        }.padding(.top, expandCard ? UIScreen.main.bounds.height * 0.05 : UIScreen.main.bounds.height*0.2)
        .animation(.easeInOut(duration: 0.3), value: expandCard)
                
                // Fixed bottom button
                Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentView = "order"
                        }
                    } label: {
                        Text("주문하기")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hue: 0.574,
                                              saturation: 0.871,
                                              brightness: 0.935,
                                              opacity: 0.925))
                            .cornerRadius(100)
                }.padding(.horizontal)
                .padding(.bottom, 55)
            }
        }
        .ignoresSafeArea()
        .overlay(
            VStack {
                if showNotification {
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.white)
                            Text("결제 정보 확인")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Button(action: { showNotification = false }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        if paymentInfo == 0 {
                        Text("비단길에서 통관 정보를 확인 후 결제를 진행하실 수 있습니다.")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.leading)
                        }
                        if paymentInfo == 2 {
                        Text("상품 결제가 완료되었습니다. 상품이 도착할 때까지 기다려주세요.")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.leading)
                        }
                        if paymentInfo == 4 {
                        Text("상품과 배송비 결제가 모두 완료되었습니다.")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.leading)
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 50) // Add top padding for status bar
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.5), value: showNotification)
            , alignment: .top
        )
        .onAppear {
            updateCurrentStep()
            updatePaymentInfo()
        }
        .onChange(of: orders) {
            print("orders changed")
            updateCurrentStep()
            updatePaymentInfo()
        }
        .fullScreenCover(isPresented: $togglemenu) {
            ProfileMenuView(isPresented: $togglemenu)
        }
        .fullScreenCover(isPresented: $showOrder) {
            Order(currentView: $currentView)
        }
        


        
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
    @State private var showExpandedContent: Bool = false
    @State private var animationProgress: CGFloat = 0
    @State private var animationTimer: Timer?
    @Binding var order: OrderData
    @Binding var expandCard: Bool
    
    private func startRepeatingAnimation() {
        // Cancel existing timer
        animationTimer?.invalidate()
        
        // Reset and start animation
        animationProgress = 0
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            animationProgress = 1.0
        }
        
        // Set up timer to restart animation every 2 seconds
        animationTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            animationProgress = 0
            withAnimation(.linear(duration: 2.0)) {
                animationProgress = 1.0
            }
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSxxx"
        formatter.timeZone = TimeZone.current
        
        if let date = formatter.date(from: order.order_created_at) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MM.dd.yyyy"
            outputFormatter.timeZone = TimeZone.current
            return outputFormatter.string(from: date)
        }
        return order.order_created_at
    }
    
    private var formattedAddress: (String, String, String) {
        print("Debug - order.address: '\(order.address)'")
        let components = order.address.components(separatedBy: "\n")
        let filteredComponents = components.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        guard filteredComponents.count >= 3 else {
            return ("주소 정보 로딩 중...", "", "")
        }

        if filteredComponents.count == 5 {
            let firstPart: String = filteredComponents[0]
            let secondPart: String = filteredComponents[1]
            let thirdPart:[String] = Array(filteredComponents.suffix(3))
            return (firstPart, secondPart, thirdPart.joined(separator: ", "))
        }
        if filteredComponents.count == 4 {
            let firstPart: String = filteredComponents[0]
            let secondPart: String = Array(filteredComponents.suffix(3)).joined(separator: ", ")
            let thirdPart: String = ""
            return (firstPart, secondPart, thirdPart)
        }
        return ("주소 정보 로딩 중...", "", "")
    }
    // Keep the dot size in one place so the layout is predictable
    private let dotSize: CGFloat = 18
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(stops: [
                    .init(color: Color.blue, location: 0.00),
                    .init(color: Color.blue, location: expandCard ? 1.00 : 0.33),
                    .init(color: Color(white: 0.95), location: expandCard ? 1.01 : 0.33),
                    .init(color: Color(white: 0.95), location: 1.00)
                ], startPoint: .top, endPoint: .bottom))
                .animation(.easeInOut(duration: 0.3), value: expandCard)
            
            
            
            VStack{
                if !expandCard {
                VStack{
                    HStack{                                  
                        Image(systemName: "tag.fill")
                            .foregroundColor(.white)
                        Text("dualsonic.com, spao.com 외 2개")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)
                }
                }else{
                    VStack(alignment: .leading, spacing: 16){
                       
                        if showExpandedContent {
                            Text("주문번호: \(order.id)")
                                .font(.system(size: 12))
                                .foregroundColor(.black)
                                .transition(.opacity)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.bottom, 4)
                            HStack(alignment: .top){
                            Text("주문일")
                                .font(.headline)
                                .foregroundColor(.white)
                                .transition(.opacity)
                            Spacer()
                            Text("\(formattedDate)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .transition(.opacity)
                            }
                            HStack(alignment: .top){
                            Text("적용환율")
                                .font(.headline)
                                .foregroundColor(.white)
                                .transition(.opacity)
                            Spacer()
                            Text("\(order.exchange_rate)원")
                                .font(.headline)
                                .foregroundColor(.white)
                                .transition(.opacity)

                            }
                            HStack(alignment: .top){
                            Text("배송주소")
                                .font(.headline)
                                .foregroundColor(.white)
                                .transition(.opacity)
                                
                            Spacer()
                            VStack(alignment: .trailing){
                            Text("\(formattedAddress.0)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .transition(.opacity)
                            Text("\(formattedAddress.1)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .transition(.opacity)     
                                  
                            Text("\(formattedAddress.2)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .transition(.opacity)
                            }
                              
                            }
                            Text("📦주문 상품").frame(maxWidth: .infinity, alignment: .center).font(.headline)
                            .foregroundColor(.white).transition(.opacity)
                            .padding(.top, 8)

                            ScrollView(.vertical, showsIndicators: false){
                            VStack(alignment: .leading, spacing: 4){
                            ForEach(order.items) { item in
                           
                          
                            VStack(alignment: .leading){
                                Text(item.url.count > 30 ? String(item.url.prefix(30)) + "..." : item.url)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .transition(.opacity)
                                Text(item.description)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .transition(.opacity)
                            }.padding(.bottom, 4)
                            
                            
                            
                            }
                            }
                            }
                            
                        }
                       
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                  // 33% of the blue zone
                }
                Spacer()

                
                VStack(spacing: 8) {
                    // ─── Row 1: dots + connectors ───
                    if !expandCard {
                    HStack(spacing: 0) {
                        ForEach(progress.steps.indices, id: \.self) { index in
                            if index%2 == 0 {
                            StepDot(
                                isComplete: index%2 == 0 && index < progress.currentStep,
                                accent: accent
                            )
                            .frame(width: 18, height: 18)
                            .frame(maxWidth: .infinity)
                            }
                            if index < progress.steps.count - 1 && index%2 == 1 {
                                ZStack(alignment: .leading){  
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 2)
                                        .frame(maxWidth: .infinity)
                                        
                                    if index == progress.currentStep{
                                    Rectangle()
                                        .fill(accent)
                                        .frame(height: 2)
                                        .frame(maxWidth: .infinity)
                                        .scaleEffect(x: animationProgress, anchor: .leading)
                                        .onAppear {
                                            startRepeatingAnimation()
                                        }
                                        .onChange(of: expandCard) { _ in
                                            startRepeatingAnimation()
                                        }
                                    }else if (index < progress.currentStep) {
                                        Rectangle()
                                        .fill(accent)
                                        .frame(height: 2)
                                        .frame(maxWidth: .infinity)                                   
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // ─── Row 2: labels + *placeholder* columns ───
                    HStack(spacing: 0) {
                        ForEach(progress.steps.indices, id: \.self) { index in
                            if index%2 == 0 {
                            Text(progress.steps[index])
                                .font(.caption)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .center)
                            }                            
                            // placeholder column (same spot as connector above)
                            if index < progress.steps.count - 1 {
                                Spacer()                      
                                    
                            }
                        }
                    }
                    .padding(.horizontal, 0)
                    }
                    
                   
                }
            Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width*0.85, height: expandCard ? UIScreen.main.bounds.height*0.5 : UIScreen.main.bounds.height*0.2)
        .animation(.easeInOut(duration: 0.3), value: expandCard)
        .onTapGesture {
            expandCard.toggle()
            if expandCard {
                // Show text after animation starts
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.27) {
                    showExpandedContent = true
                }
            } else {
                // Hide text immediately when collapsing
                showExpandedContent = false
            }
        }
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

struct OrderHistoryCard: View {
    var body: some View {
        Text("주문번호: 99999")
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


struct CheckoutView: View {
    @State private var paymentSheet: PaymentSheet?
    @State private var isLoading = false
    @State private var alert: AlertItem?
    @State private var glowAnimation = false
    @Binding var currentStep: Int
    @Binding var paymentInfo: Int
    var body: some View {
        if currentStep == 1 && paymentInfo == 1 {
            Button(action: { loadPaymentSheet() }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(UIColor.systemGray6).opacity(1.0))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 0.7)
                                .shadow(color: .blue, radius: glowAnimation ? 3 : 1, x: 0, y: 0)
                                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: glowAnimation)
                        )
                        .onAppear {
                            glowAnimation = true
                        }
                    
                    Text("결제하기")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .frame(width: UIScreen.main.bounds.width*0.41, height: 50)
            }
            .disabled(isLoading)
            .alert(item: $alert) { $0.alert }
        }
        if currentStep == 3 && paymentInfo == 3 {
            Button(action: { loadPaymentSheet() }) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: UIScreen.main.bounds.width*0.41, height: 50)
            }
            .disabled(isLoading)
            .alert(item: $alert) { $0.alert }
        }
    }

    /// 1️⃣ Talk to Django
    private func loadPaymentSheet() {
        isLoading = true
        Task {
            do {
                let url = URL(string: "http://127.0.0.1:8000/api/mobile_intent/")!
                var req = URLRequest(url: url); req.httpMethod = "POST"
                req.httpBody = try JSONEncoder().encode(["order_id": "24"])
                req.setValue("application/json", forHTTPHeaderField: "Content-Type")

                let (data, _) = try await URLSession.shared.data(for: req)
                let secret = try JSONDecoder().decode(Response.self, from: data).clientSecret

                /// 2️⃣ Configure sheet
                var config = PaymentSheet.Configuration()
                config.merchantDisplayName = "Bidangil"
                config.applePay = .init(merchantId: "merchant.co.bidangil", merchantCountryCode: "US")   // optional
                config.defaultBillingDetails = .init()
                config.allowsDelayedPaymentMethods = true
                paymentSheet = PaymentSheet(paymentIntentClientSecret: secret,
                                            configuration: config)
                isLoading = false

                /// 3️⃣ Present
                if let sheet = paymentSheet,
                   let root = UIApplication.shared.firstKeyWindow?.rootViewController {
                    root.modalPresentationStyle = .fullScreen
                    sheet.present(from: root) { result in
                        switch result {
                        case .completed:
                            alert = .init(title: "Paid ✓")
                        case .canceled:
                            break
                        case .failed(let error):
                            alert = .init(title: "Payment failed", message: error.localizedDescription)
                        }
                    }
                }
            } catch {
                isLoading = false
                alert = .init(title: "Error", message: error.localizedDescription)
            }
        }
    }

    private struct Response: Codable { let clientSecret: String }
    private struct AlertItem: Identifiable { var id = UUID(); var title: String; var message: String? = nil
        var alert: Alert { Alert(title: Text(title), message: message.map(Text.init)) }
    }
}

// little helper so we don't fight the window hierarchy
extension UIApplication {
    var firstKeyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }
    }
}
