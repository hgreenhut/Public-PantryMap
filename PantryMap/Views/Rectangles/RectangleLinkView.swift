//
//  RectangleLinkView.swift
//  PantryMap
//
//  Created by Henry Greenhut on 8/27/22.
//

import SwiftUI

struct RectangleLinkView: View {
    @EnvironmentObject var model: ContentModel
    var link: String
    var prefix = ""
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
                let number = model.formatPhone(number: link)
                if URL(string: prefix + number) != nil {

                    Link(link, destination: URL(string: prefix + number)!)
                }
               
                Spacer()
            }

        }

            
    }
}
