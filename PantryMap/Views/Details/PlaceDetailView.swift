//
//  PlaceDetailView.swift
//  PantryMap
//
//  Created by Henry Greenhut on 8/23/22.
//

import SwiftUI

struct PlaceDetailView: View {
    var selectedPlace: Place
    @State var tabIndex = "Walking"
    @State private var showDirections = false
    @EnvironmentObject var model: ContentModel
    private let green = Color(red: 150/255, green: 210/255, blue: 148/255)
    private let green2 = Color(red: 138/255, green: 171/255, blue: 145/255)
    private let darkGreen = Color(red: 105/255, green: 147/255, blue: 114/255)
    private let blue = Color(red: 176/255, green: 190/255, blue: 197/255)
    
    
    
    @State var isExpanded = false
    @State var subviewHeight : CGFloat = 0
    
    @State var isExpanded2 = false
    @State var subviewHeight2 : CGFloat = 0
    
    
    init(selectedPlace: Place){
        self.selectedPlace = selectedPlace
        UITabBar.appearance().backgroundColor = UIColor(green)
        UITabBar.appearance().barTintColor = UIColor(green)
    }
    var body: some View {
        GeometryReader {geo in
            VStack{
                VStack {
                    ScrollView {
                        VStack {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    if model.selectedPlace?.name != nil {
                                        Text(model.selectedPlace?.name ?? "No Name")
                                            .font(Font.custom("Gilroy-Bold", size: 25))
                                            .frame(maxHeight: 400)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .padding()
                                            .layoutPriority(1)
                                        
                                    }
                                    else {
                                        ProgressView()
                                            .scaleEffect(8)
                                            .padding(.all, 100)
                                            .position(x: geo.size.width/2, y: geo.size.height/2)
                                    }
                                    
                                    if (model.selectedPhoto != nil){
                                        Spacer()
                                        let uiImage = UIImage(data: model.selectedPhoto ?? Data())
                                        Image(uiImage: uiImage ?? UIImage())
                                            .resizable()
                                            .scaledToFill()
                                            .frame(minWidth: geo.size.width/4)
                                            .frame(maxHeight: geo.size.height/7)
                                            .frame(maxWidth: geo.size.width/2)
                                            .clipped()
                                            .cornerRadius(5)
                                            .shadow(radius: 5)
                                            .padding()
                                    }
                                    else {
                                        Spacer()
                                        Image(systemName: "pencil")
                                            .resizable()
                                            .foregroundColor(green)
                                        
                                            .scaledToFill()
                                            .frame(minWidth: geo.size.width/4)
                                            .frame(maxHeight: geo.size.height/7)
                                            .frame(maxWidth: geo.size.width/2)
                                            .clipped()
                                            .cornerRadius(5)
                                            .padding()
                                    }
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                            
                            
                            
                            VStack(spacing: 20) {
                                if model.selectedPlace?.formatted_address != nil {
                                    RectangleView(text: model.selectedPlace?.formatted_address ?? "No formatted address", icon: "map")
                                        .frame(height: 66)
                                        .padding(.horizontal)
                                    
                                    
                                
                                }
                                
                                if URL(string: model.selectedPlace?.website ?? "") != nil && URL(string: model.selectedBank?.website ?? "") == nil {
                                    RectangleWebsiteView(link: model.selectedPlace?.website ?? "", icon: "link")
                                        .padding(.horizontal)
                                        .frame(height: 66)
                                    
                                    
                                }
                                
                                if URL(string: model.selectedBank?.website ?? "") != nil {
                                    RectangleWebsiteView(link: model.selectedBank?.website ?? "", icon: "link")
                                        .frame(height: 66)
                                        .padding(.horizontal)
                                }
                                
                                
                                if model.selectedBank?.email != nil && model.selectedBank?.email != ""{
                                    RectangleEmailView(link: model.selectedBank?.email ?? "", icon: "mail")
                                        .frame(height: 66)
                                        .padding(.horizontal)
                                }
                                
                                
                                if model.selectedBank?.phoneNumber != "" && model.selectedBank?.phoneNumber != nil && (model.selectedPlace?.formatted_phone_number == "" || model.selectedPlace?.formatted_phone_number == nil){
                                    Text("here")
                                    RectangleLinkView(link: model.selectedBank?.phoneNumber ?? "", prefix: "tel://", icon: "phone")
                                        .frame(height: 66)
                                        .padding(.horizontal)
                                    
                                    
                                }
                                
                                
                          
                     
                                
                                
                                
                                
                                
                                
                                
                                if model.selectedPlace?.formatted_phone_number != "" && model.selectedPlace?.formatted_phone_number != nil {
                                    RectangleLinkView(link: model.selectedPlace?.formatted_phone_number ?? "", prefix: "tel://", icon: "phone")
                                        .frame(height: 66)
                                        .padding([.horizontal, .bottom])
                                    
                                    
                                    
                                }
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            if model.selectedBank?.volunteerInfo != nil && model.selectedBank?.volunteerInfo != "" {
                                VStack {
                                    if isExpanded == false {
                                        HStack {
                                            
                                            
                                            Text("View volunteer info")
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                        }
                                        .padding()
                                        
                                    } else {
                                        VStack {
                                            HStack {
                                                Text("View volunteer info")
                                                Spacer()
                                                Image(systemName: "chevron.up")
                                            }
                                            .padding()
                                            HStack {
                                                Text(model.selectedBank?.volunteerInfo ?? "")
                                                    .font(Font.custom("Gilroy-Medium", size: 16))
                                                    .foregroundColor(.white)
                                                    .padding([.horizontal, .bottom])
                                                Spacer()
                                            }
                                            
                                        }
                                        .fixedSize(horizontal: false, vertical: true)
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                }
                                .cornerRadius(5)
                                .background(blue)
                                .background(GeometryReader {
                                    Color.clear.preference(key: ViewHeightKey.self,
                                                           value: $0.frame(in: .local).size.height)
                                })
                                .onPreferenceChange(ViewHeightKey.self) { subviewHeight = $0 }
                                .frame(height: isExpanded ? subviewHeight : 50, alignment: .top)
                                .padding(.horizontal)
                                .clipped()
                                .transition(.move(edge: .bottom))
                                // .background(Color.gray.cornerRadius(10.0))
                                .onTapGesture {
                                    withAnimation(.easeIn(duration: 2.0)) {
                                        isExpanded.toggle()
                                    }
                                }
                            }
                            
                            
                            if let hours = model.selectedPlace?.opening_hours?.weekday_text {
                                VStack {
                                    if isExpanded2 == false {
                                        HStack {
                                            
                                            
                                            Text("View open hours")
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                        }
                                        .padding()
                                        
                                    } else {
                                        VStack {
                                            HStack {
                                                Text("View open hours")
                                                
                                                Spacer()
                                                Image(systemName: "chevron.up")
                                            }
                                            .padding()
                                            HStack {
                                                VStack (alignment: .leading) {
                                                    
                                                    ForEach(hours, id: \.self) {hour in
                                                        VStack(alignment: .leading) {
                                                            Text(hour)
                                                                .fixedSize(horizontal: false, vertical: true)
                                                                .font(Font.custom("Gilroy-Medium", size: 16))
                                                                .foregroundColor(.white)
                                                            
                                                        }
                                                        .padding(.horizontal)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                        .multilineTextAlignment(.leading)
                                                    }
                                                    
                                                }
                                                .padding(.bottom)
                                                Spacer()
                                            }
                                            
                                            
                                            
                                            
                                            
                                        }
                                        
                                        
                                        
                                    }
                                }
                                .cornerRadius(5)
                                .background(blue)
                                .background(GeometryReader {
                                    Color.clear.preference(key: ViewHeightKey.self,
                                                           value: $0.frame(in: .local).size.height)
                                })
                                .onPreferenceChange(ViewHeightKey.self) { subviewHeight2 = $0 }
                                .frame(height: isExpanded2 ? subviewHeight2 : 50, alignment: .top)
                                .padding()
                                .clipped()
                                .transition(.move(edge: .bottom))
                                // .background(Color.gray.cornerRadius(10.0))
                                .onTapGesture {
                                    withAnimation(.easeIn(duration: 2.0)) {
                                        isExpanded2.toggle()
                                    }
                                }
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                        .sheet(isPresented: $showDirections) {
                            DirectionsView(tabIndex: tabIndex, place: selectedPlace)
                        }
                        .ignoresSafeArea()
                        .font(Font.custom("Gilroy-Bold", size: 20))
                        .background(green)
                        
                    }
                    .frame(maxHeight: .infinity)
                    .background(green)
                    
                }
                VStack {
                    Button {
                        showDirections = true
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(height: 48)
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                            
                            Text("Get \(tabIndex) Directions")
                                .foregroundColor(.white)
                                .bold()
                        }
                    }
                    .padding()
                    
                    
                    TabView(selection: $tabIndex) {
                        Text("").frame(width: 0, height: 0)
                            .tabItem {
                                Image(systemName: "figure.walk")
                                    .fixedSize(horizontal: false, vertical: true)
                                
                            }.tag("Walking")
                            .foregroundColor(.red)
                        Text("").frame(width: 0, height: 0)
                            .tabItem {
                                Image(systemName: "car")
                                    .fixedSize(horizontal: false, vertical: true)
                            }.tag("Driving")
                        Text("").frame(width: 0, height: 0)
                            .tabItem {
                                Image(systemName: "train.side.front.car")
                                    .fixedSize(horizontal: false, vertical: true)
                            }.tag("Transit")
                        
                    }
                    .frame(height: 40)
                }
                .background(green)
                .frame(alignment: .bottom)
            }
            .background(green)
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
    }
}





struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
