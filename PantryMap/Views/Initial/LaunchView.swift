//
//  LaunchView.swift
//  PantryMap
//
//  Created by Henry Greenhut on 8/4/22.
//

import SwiftUI
import CoreLocation

struct LaunchView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var selectedIcon: Place?
    
    var body: some View {
        if model.authorizationState == .notDetermined{
            PermissionView()
        }
        
        else if model.authorizationState == .authorizedAlways || model.authorizationState == .authorizedWhenInUse{
            ZStack {
                NearbyMap(selectedIcon: $selectedIcon).ignoresSafeArea()
                    .onAppear {
                        model.getRemoteData()
                        
                    }
                    .sheet(item: $selectedIcon) { place in
                        PlaceDetailView(selectedPlace: place)
                            .onAppear {
                                model.getDetail(placeID: selectedIcon?.place_id ?? "")
                            }
                            .onDisappear {
                                model.selectedPlace = nil
                                model.selectedPhoto = nil
                                model.selectedBank?.volunteerInfo = ""
                                model.selectedBank = nil
                            }
                    }
                
            }
            
        }
        else {
            DeniedView()
            
        }
        
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
