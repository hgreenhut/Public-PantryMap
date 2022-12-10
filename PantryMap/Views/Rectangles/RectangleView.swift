//
//  RectangleView.swift
//  PantryMap
//
//  Created by Henry Greenhut on 8/27/22.
//

import SwiftUI

struct RectangleView: View {
    var text: String
    var icon: String
    private let blue = Color(red: 176/255, green: 190/255, blue: 197/255)
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(blue)
                .cornerRadius(10)
                .shadow(radius: 5)
            HStack() {
                Image(systemName: icon)
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    .scaleEffect(2)
                Text(text)
                    .foregroundColor(.white)
                    .padding(.trailing)
                
                Spacer()
            }

        }

            
    }
}

struct RectangleView_Previews: PreviewProvider {
    static var previews: some View {
        RectangleView(text: "This is a test", icon: "phone")
    }
}
