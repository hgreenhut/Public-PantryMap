//
//  Result.swift
//  City Sights
//
//  Created by Henry Greenhut on 8/22/22.
//

import Foundation

struct Search: Decodable  {
    var html_attributions: [String]
    var next_page_token: String?
    var results: [Place]
    var status: String?
}

class Place: Decodable, Identifiable, ObservableObject {
    var geometry: Geometry?
    var icon: String?
    var name: String?
    var place_id: String?
}


struct Geometry: Decodable {
    var location: LatLngLiteral?
}

struct LatLngLiteral: Decodable {
    var lat: Double?
    var lng: Double?
}
