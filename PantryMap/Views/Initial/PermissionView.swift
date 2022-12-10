//
//  PermissionView.swift
//  PantryMap
//
//  Created by Henry Greenhut on 9/10/22.
//

import SwiftUI

struct PermissionView: View {
    @EnvironmentObject var model: ContentModel
    private let green = Color(red: 150/255, green: 210/255, blue: 148/255)
    var body: some View {
        
        ZStack {
            Color(hex: "ADD8E6")
            VStack {
                Spacer()
                Text("PantryMapper")
                    .font(Font.custom("Gilroy-Bold", size: 60))
                    .shadow(color: .black, radius: 20, x: 10, y: 19)
                    .lineLimit(1)
                    .allowsTightening(true)
                    .minimumScaleFactor(0.5)
                    .padding()
                Spacer()
                
                Button("Find Nearby Pantries!", action: {
                    model.requestGeoLocationPermission()
                    
                    
                }).padding(20)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .shadow(color: .white, radius: 15, x: -10, y: -10)
                                .shadow(color: .black, radius: 15, x: 10, y: 10)
                                .blendMode(.overlay)
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(green)
                        }
                    )
                    .foregroundColor(.primary)
                Spacer()
            }
            .font(Font.custom("Gilroy-Bold", size: 25))
            
        }
        .ignoresSafeArea()
        
    }
}

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionView()
    }
}

extension Color {
    static let neuBackground = Color(hex: "96D294")
    static let dropShadow = Color(hex: "aeaec0").opacity(0.4)
    static let dropLight = Color(hex: "ffffff").opacity(0.4)
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        // scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}
