//
//  DirectionsView.swift
//  PantryMap
//
//  Created by Henry Greenhut on 8/15/22.
//

import SwiftUI

struct DirectionsView: View {
    @EnvironmentObject var model: ContentModel
    @State var tabIndex: String
    private let green = Color(red: 150/255, green: 210/255, blue: 148/255)
    var place: Place
    var encodedType: String {
        switch tabIndex {
        case "Driving":
            return "d"
        case "Walking":
            return "w"
        case "Transit":
            return "r"
        default:
            return "w"
        }
    }
    
    var body: some View {
        GeometryReader {geo in
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    if model.distance != nil {
                        let unitDistance = ((model.distance ?? 0) / 1609)
                        let roundedDistance = round(unitDistance * 10) / 10.0
                        Text(String(roundedDistance) + " mi")
                            .scaledToFill()
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                    }
                    Spacer()
                    if model.expectedTravelTime != nil {
                        let (h,m,_) = secondsToHoursMinutesSeconds(Int(model.expectedTravelTime ?? 0.0))
                        if h == 0 {
                            Text("\(String(m)) minutes")
                                .scaledToFill()
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                        } else {
                            Text("\(String(h)) hr \(String(m)) minutes")
                                .scaledToFill()
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                            
                        }
                    }
                    Spacer()
                    
                    Text(tabIndex)
                        .scaledToFill()
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    Spacer()
                    
                    
                    
                    
                }
                .frame(maxWidth: geo.size.width)
                .padding()
                .background(green)
                
                ZStack {
                    DirectionsMap(tabIndex: tabIndex, place: place)
                        .background(green)
                        .ignoresSafeArea(.all, edges: .all)
                    
                    if let lat = place.geometry?.location?.lat, let long = place.geometry?.location?.lng, let name = place.name{
                        
                        // TODO: dirflg doesn't work
                        
                        Link(destination: URL(string: "http://maps.apple.com/?ll=\(lat),\(long)&q=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")!) {
                            ZStack {
                                VStack {
                                    Rectangle()
                                        .frame(height: 50)
                                        .cornerRadius(10)
                                        .foregroundColor(.blue)
                                        .shadow(radius: 5)
                                }
                                .padding(.horizontal)
                                Text("Open in Maps")
                                    .foregroundColor(.white)
                            }
                            
                        } .position(x: geo.size.width/2, y: geo.size.height-geo.size.height/5)
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                }
                
            }
            
        }
        
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}

