//
//  Order.swift
//  Bidangil
//
//  Created by Samuel Choi on 7/3/25.
//

import SwiftUI
import MapKit
import CoreLocation


public struct Order: View {
    @Binding var currentView: String
    
    public init(currentView: Binding<String>) {
        self._currentView = currentView
    }
    
    public var body: some View {
        CustomFormView(currentView: $currentView)
    }
}
struct OrderItem: Identifiable {
    let id = UUID()
    var urlText: String = ""
    var optionText: String = ""
}

struct OrderCardView: View {
    @Binding var item: OrderItem
    var body:some View{
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.2)
           
            VStack(){
                TextField("웹 주소", text: $item.urlText)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            
      
            VStack(alignment: .leading, spacing: 6) {
                TextEditor(text: $item.optionText)
                        .padding(8)
                        .frame(height: UIScreen.main.bounds.height * 0.1)
                        .scrollContentBackground(.hidden)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(content: {
                            if item.optionText.isEmpty  {
                                Text("사이즈 색상등의 옵션을 입력해주세요.").foregroundColor(.gray).opacity(0.7)
                            }
                            
                        })
                       
                
            }
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

        }
        .frame(width: UIScreen.main.bounds.width * 0.9,
               height: UIScreen.main.bounds.height * 0.2, alignment: .center)
    }
}

struct CustomFormView: View {
    @Binding var currentView: String
    @State var name: String = ""
    @State var phone: String = ""
    @State var address_1: String = ""
    @State var address_2: String = ""
    @State var city: String = ""
    @State var state: String = ""
    @State var zipcode: String = ""
    @State private var step: Int = 1
    @State var text: String = ""
    @State private var items: [OrderItem] = [OrderItem()]
    @State private var errorMessage: String?
    @State private var errmessage: String = "한개 이상의 주문이 필요합니다."
    
    private var completedItems: [OrderItem] {
        items.filter {
            !$0.urlText.isEmpty && !$0.optionText.isEmpty
        }
    }
    private func adjustOffset(in geo: GeometryProxy, eachStep: Int) -> CGFloat {
        if eachStep > step {
            return geo.size.width+geo.size.width*0.1
        }
        if eachStep < step {
            return -geo.size.width-geo.size.width*0.1
        }
        return 0



    }


    
    
    var body: some View {
        ZStack(alignment: .topLeading){


            VStack() {
                if step == 1 {
                    HStack{
                        Button(action: {
                            self.currentView = "main"
                        }) {
                            
                                Image(systemName: "arrow.backward").foregroundColor(.black)
                        }
                        Spacer()
                    }.padding(.horizontal)


                }
                if step > 1 {
                    HStack{
                        Button(action: {
                            step -= 1
                        }) {
                            Image(systemName: "arrow.backward").foregroundColor(.black)
                        }
                        Spacer()
                    }.padding(.horizontal)


                }
                Spacer()
                ZStack(){
               GeometryReader{ geo in
                ZStack(){
                    NameandEmail(name: $name, phone: $phone)
                        .frame(width: .infinity)
                        .offset(x: step == 1 ? 0 : -geo.size.width-geo.size.width*0.1)
                        .disabled(step != 1)
             
          
                    Address(address_1: $address_1, address_2: $address_2, city:$city, state: $state, zipcode: $zipcode)
                        .frame(width: .infinity)
                        .offset(x: step == 2 ? 0 : adjustOffset(in: geo, eachStep: 2))
                        .disabled(step != 2)
                 
                  
                    OrderPage(items: $items)
                        .offset(x: step == 3 ? 0 : adjustOffset(in: geo, eachStep: 3))
                        .disabled(step != 3)
           
                    
                    ScrollView{
                        FinalReviewView(items: $items, name: $name, phone: $phone, address_1: $address_1, address_2: $address_2, city: $city, state: $state, zipcode: $zipcode)
                    }.scrollIndicators(.hidden).padding(.top,30)
                    .offset(x: step == 4 ? 0 : adjustOffset(in: geo, eachStep: 4))
                    .disabled(step != 4)
               }
               .animation(.easeInOut(duration: 0.35), value: step)
              


                    }               
                }
                .frame(width: .infinity)
                .padding()
                

                Spacer()
                VStack(){
                Text(errorMessage ?? "" ).foregroundColor(.red)
                Button(action: {
                    print("next clicked")
                    if step == 1{
                        if name.isEmpty || phone.isEmpty{
                            errorMessage = "이름과 전화번호를 입력해주세요."
                        }else{
                            step += 1
                            errorMessage = nil
                            
                        }
                    }else if step == 2{
                        if address_1.isEmpty || state.isEmpty || zipcode.isEmpty || city.isEmpty{
                            errorMessage = "주소 정보를 확인해주세요."
                        }
                        else{
                            step += 1
                            errorMessage=nil
                         
                        }
                    }else if step == 3{
                        if completedItems.isEmpty {
                            errorMessage = "한개 이상의 상품을 주문해주세요."
                        }else{
                            step += 1
                            errorMessage=nil
                         
                        }
                        
                    }else{
                        print("submitForm")
                        //submitForm()
                    }
                }) {
                    if step < 4{

                        Text("다음")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hue: 0.574,
                                              saturation: 0.871,
                                              brightness: 0.935,
                                              opacity: 0.925))
                            .foregroundColor(.white)
                            .cornerRadius(100)
                    }else if step == 4{
      
                            
                            Text("신청하기")
                            .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hue: 0.574,
                                                  saturation: 0.871,
                                                  brightness: 0.935,
                                                  opacity: 0.925))
                                .foregroundColor(.white)
                                .cornerRadius(100)
                        

                    }

                }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            }
        }

        
        
        
        
        }
        
        // func submitForm() {
        //     print("✅ Name: \(name)")
        //     print("✅ Email: \(phone)")
        //     print("✅ Address: \(address_1)")
        //     print("✅ Age: \(state)")
            
        // }

struct NameandEmail: View {
    @Binding var name: String
    @Binding var phone: String

    var body: some View {
        
        VStack(spacing: 20){
            VStack(alignment:.leading) {
                HStack {
                     Image(systemName: "person.fill")
                     Text("이름")
                         .font(.headline)
                 }
                     
                         HStack {
                            
                             TextField("고길동", text: $name)
                                 .padding()
                                 .background(Color(.systemGray6))
                                 .cornerRadius(8)
                                 .frame(width: UIScreen.main.bounds.width * 0.9)
                             Spacer()
                         }
            }

                
            VStack(alignment: .leading){
            HStack{
                Image(systemName:"phone.fill")
                Text("전화번호")
                    .font(.headline)
            }
        HStack{
                 TextField("000-000-0000", text: $phone)
                     .keyboardType(.phonePad)
                     .padding()
                     .background(Color(.systemGray6))
                     .cornerRadius(8)
                     .frame(width: UIScreen.main.bounds.width * 0.9)
                Spacer()        
                    }
                    
            }

                     
                     
                     
        }.frame(width: .infinity)

    }
}
struct Address:View{
    @Binding var address_1:String
    @Binding var address_2:String
    @Binding var city:String
    @Binding var state:String
    @Binding var zipcode:String
    
    var body: some View {
        VStack(){
            VStack(alignment:.leading) {
                HStack {
                     Image(systemName: "house.fill")
                     Text("배송 받을 주소")
                         .font(.headline)
                 }
                VStack(spacing: 10){
                    HStack{
                    TextField("주소1", text: $address_1)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        Spacer()
                    }
                    HStack{
                        TextField("주소2", text: $address_2)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .frame(width: UIScreen.main.bounds.width * 0.44)
                        TextField("도시", text: $city)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .frame(width: UIScreen.main.bounds.width * 0.44)
                        Spacer()

                    }
                    HStack{
                        StateSelector(selectedState: $state)
           
                        TextField("우편번호", text: $zipcode)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .frame(width: UIScreen.main.bounds.width * 0.44)
                        Spacer()
                    }


                }
                     

            }

                


                     
                     
                     
        }

    }
}

struct StateSelector: View {
    @Binding var selectedState : String
    let states = ["CA", "NY", "TX", "WA", "FL", "AZ", "IL", "GA", "NJ", "MA"]

    var body: some View {
        Menu {
            Picker(selection: $selectedState, label: EmptyView()) {
                ForEach(states, id: \.self) { state in
                    Text(state).tag(state)
                }
            }
        } label: {
            HStack {
                Text(selectedState.isEmpty ? "주" : selectedState)
                    .foregroundColor(selectedState.isEmpty ? .gray : .primary)
                Spacer()
                Image(systemName: "chevron.down")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .frame(width: UIScreen.main.bounds.width * 0.44)
        }
    }
}

struct OrderPage: View {
    @Binding var items: [OrderItem]

    var body: some View {
     

        ScrollView {

            VStack(spacing: 20) {
                ForEach($items) { $item in
                HStack{
                    OrderCardView(item: $item)
                    Spacer()
                }
                }
            }
            .padding(.vertical)
            

            
         
        }
        .scrollIndicators(.hidden)
        
        .overlay(
            Button {
                withAnimation { items.append(OrderItem()) }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(17)
                    .background(.blue)
                    .clipShape(Circle())
               
            }
            .padding(),
            alignment: .bottomTrailing
        )

    }
}

struct MapPhotoView: View {
    @State private var snapshot: UIImage?
    let fullAddress: String = "3630 Westminister Ave, Sanata Ana, CA 92703"
    
    var body: some View {
        Group {
            if let img = snapshot {
                ZStack(){
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                    Image(systemName: "mappin").foregroundColor(.blue)
                }
	
            } else {
                RoundedRectangle(cornerRadius: 20).background(Color.gray).foregroundColor(.gray)
            }
        }
        .task {
            await MainActor.run {
                MapSnapshotter.snapshot(for: fullAddress) { image in
                    snapshot = image
                }
            }
        }
    }
}

struct FinalReviewView: View {
    let labelWidth: CGFloat = 70
    @Binding var items: [OrderItem]
    @Binding var name: String
    @Binding var phone: String
    @Binding var address_1: String
    @Binding var address_2: String
    @Binding var city: String
    @Binding var state: String
    @Binding var zipcode: String
    
    var fullAddress: String {
        let line1 = [address_1, address_2]
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        let line2 = [city, state, zipcode]
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
        
        var fullAddress: String {
            [line1, line2]
                .filter { !$0.isEmpty }
                .joined(separator: "\n")   // ← newline instead of “, ”
        }
        return fullAddress
    }
    var body: some View {
        VStack(alignment: .leading){
            if items.isEmpty{
                EmptyView()
            }else{
                Text("신청 내역").font(.title).fontWeight(.heavy).foregroundColor(.black).padding(.bottom,10).padding(.horizontal).font(.title)
                ForEach(items.filter {
                    !$0.urlText.isEmpty
                 &&
                    !$0.optionText.isEmpty
                }, id: \.id){ item in
                    VStack(alignment:.leading){
                        HStack{
                            Image(systemName: "globe").foregroundColor(.blue)
                            Text(item.urlText)
                        }
                        HStack{
                            Image(systemName: "shippingbox.fill").foregroundColor(.blue)
                            Text(item.optionText).foregroundColor(.blue).opacity(0.5)
                            
                        }
            

                    }.padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)).padding(.vertical,6))

                }.padding(.horizontal,20)
                
                Text("배송 정보").font(.title).fontWeight(.heavy).foregroundColor(.black).padding(.bottom,10).padding(.horizontal).font(.title).padding(.top ,20)
                
                
                
                VStack(alignment: .leading){
                    HStack(){
                        Text("이름").frame(width: labelWidth, alignment: .leading) .fontWeight(.bold)
                        Text(name)
                    }.padding(.vertical,4)
                    HStack(){
                        Text("전화번호").frame(width: labelWidth, alignment: .leading)
                            .fontWeight(.bold)
                        Text(phone)
                        
                    }.padding(.vertical,4)
                    HStack(alignment:.top){
                        Text("배송주소").fontWeight(.bold).frame(width: labelWidth, alignment: .leading).fontWeight(.bold)
                        Text(fullAddress)
                    }.padding(.vertical,4)
                    
                    
                    

                }.padding(.vertical,12).frame(maxWidth: .infinity, alignment: .center)                                      .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6))).padding(.horizontal,20)

            }
            DropDownDemo()
            


        }
        
     
    }
}
/// Builds a snapshot image with a pin at the given address.
final class MapSnapshotter {
    
    /// - Parameters:
    ///   - address: Full address string, e.g. “1 Infinite Loop, Cupertino CA 95014”
    ///   - size: Desired pixel size of the image
    ///   - completion: Returns `UIImage?` (nil if anything fails)
    static func snapshot(for address: String,
                         size: CGSize = .init(width: 800, height: 400),
                         completion: @escaping (UIImage?) -> Void) {
        
        // ❶ Forward-geocode the address → CLPlacemark
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            guard
                let coordinate = placemarks?.first?.location?.coordinate,
                error == nil
            else { return completion(nil) }
            
            // ❷ Build the camera region
            let region = MKCoordinateRegion(center: coordinate,
                                            latitudinalMeters: 500,
                                            longitudinalMeters: 500)
            
            // ❸ Configure the snapshot request
            let options = MKMapSnapshotter.Options()
            options.region = region
            options.size   = size
            options.mapType = .standard
            options.showsBuildings = true
            options.traitCollection = UITraitCollection(userInterfaceStyle: .light)
            
            // ❹ Snapshot
            MKMapSnapshotter(options: options).start { result, error in
                guard let snapshot = result?.image, error == nil else {
                    return completion(nil)
                }
                
                // ❺ Draw a pin over the snapshot
                let pin = MKMarkerAnnotationView(annotation: nil, reuseIdentifier: nil)
                pin.markerTintColor = .red
                
                // Convert geo-coord → pixel-point
                let point = result!.point(for: coordinate)
                
                // Begin graphics context
                let renderer = UIGraphicsImageRenderer(size: size)
                let finalImage = renderer.image { _ in
                    snapshot.draw(at: .zero)
                    
                    // Center pin on the point (marker’s image is ~36×40 pt)
                    let pinOrigin = CGPoint(x: point.x - pin.intrinsicContentSize.width / 2,
                                            y: point.y - pin.intrinsicContentSize.height)
                    pin.image?.draw(at: pinOrigin)
                }
                completion(finalImage)
            }
        }
    }
}

struct DropDownDemo: View {
    @State private var isOpen = false

    var body: some View {
        DisclosureGroup(
            "더보기",
            isExpanded: $isOpen              // toggle when tapped
        ) {
            VStack(alignment: .leading, spacing: 8) {
                MapPhotoView()
                Text("신청 시점의 환율이 적용됩니다.").fontWeight(.light)
                Text("신청 후 요청하신 상품의 가격과 통관 정보를 종합하여 결제합니다.").fontWeight(.light)
            }
            .padding(.top, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
        .animation(.easeInOut, value: isOpen) // smooth open/close
        .padding(.horizontal,20)
    }
}


#Preview {
    Order(currentView: .constant("order"))
}
