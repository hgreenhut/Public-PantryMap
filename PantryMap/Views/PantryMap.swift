//
//  PantryMap.swift
//  PantryMap
//
//  Created by Henry Greenhut on 9/4/22.
//

import SwiftUI

@main
struct PantryMap: App {
    var body: some Scene {
        WindowGroup {
            LaunchView().environmentObject(ContentModel())
        }
    }
}
