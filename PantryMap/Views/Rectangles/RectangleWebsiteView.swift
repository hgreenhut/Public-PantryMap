//
//  RectangleWebsiteView.swift
//  PantryMap
//
//  Created by Henry Greenhut on 8/27/22.
//

import SwiftUI

struct RectangleWebsiteView: View {
    @EnvironmentObject var model: ContentModel
    var link: String
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
                        
               if verifyUrl(urlString: link) {
                 Link("Visit website", destination: URL(string: link)!)
                       .padding([.trailing, .vertical])
                       .lineLimit(3)
                       .allowsTightening(true)
                       .minimumScaleFactor(0.5)
                 
                      
                          
                           
                    
                    }
                else {
                    Link("Visit website", destination: URL(string: "https://"+link)!)
                          .padding([.trailing, .vertical])
                          .lineLimit(3)
                          .allowsTightening(true)
                          .minimumScaleFactor(0.5)

                }
                
                Spacer()
                    
                }
                   
               
    
            }

        }

            
    }

func verifyUrl (urlString: String?) -> Bool {
    if let urlString = urlString {
        if let url = NSURL(string: urlString) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
    }
    return false
}
