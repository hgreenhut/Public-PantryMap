//
//  RectangleLinkView.swift
//  PantryMap
//
//  Created by Henry Greenhut on 8/27/22.
//

import SwiftUI

struct RectangleEmailView: View {
    @EnvironmentObject var model: ContentModel
    var link: String
    var prefix = "mailto:"
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
                if URL(string: link) != nil {
                    Link(link, destination: URL(string: prefix+link)!)
                        .lineLimit(1)
                        .allowsTightening(true)
                        .minimumScaleFactor(0.5)
                }
               
                Spacer()
            }

        }

            
    }
}
