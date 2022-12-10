//
//  DeniedView.swift
//  PantryMap
//
//  Created by Henry Greenhut on 9/10/22.
//

import SwiftUI

struct DeniedView: View {
    @EnvironmentObject var model: ContentModel
    private let green = Color(red: 150/255, green: 210/255, blue: 148/255)
    var body: some View {
        
        ZStack {
            Color(hex: "ADD8E6")
            VStack {
                Spacer()
                Text("PantryMapper")
                    .font(Font.custom("Gilroy-Bold", size: 50))
                    .shadow(color: .black, radius: 20, x: 10, y: 19)
                Spacer()
                Text("PantryMapper needs your location to find nearby food pantries!")
                    .font(Font.custom("Gilroy-Bold", size: 30))
                    .multilineTextAlignment(.center)
                    .padding()
                Button {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options:[:], completionHandler: nil)
                        }
                    }
                } label: {
                    ZStack {
                        
                        Text("Go to Settings")
                            .font(Font.custom("Gilroy-Bold", size: 20))
                        
                        
                    }
                }
                .padding(20)
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



