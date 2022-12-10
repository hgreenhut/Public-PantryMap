//
//  Detail.swift
//  City Sights
//
//  Created by Henry Greenhut on 8/23/22.
//

import Foundation

//
//  Detail.swift
//  City Sights
//
//  Created by Henry Greenhut on 8/22/22.
//

struct Detail: Decodable  {
    var html_attributions: [String]
    var next_page_token: String?
    var result: PlaceDetail
    var status: String?
}

class PlaceDetail: Decodable, Identifiable, ObservableObject {
    var formatted_address: String?
    var icon: String?
    var name: String?
    var photos: [PlacePhoto]?
    var formatted_phone_number: String?
    var business_status: String?
    var geometry: Geometry?
    var address_components: [AddressComponent]?
    var adr_address: String?
    var opening_hours: PlaceOpeningHours?
    var website: String?
    var rating: Double?
    var url: String?
    

    // var icon_background_color: String?
    // var icon_mask_base_uri: String?
    // var place_id: String?

    // Reviews


    
}

struct AddressComponent: Decodable {
    var long_name: String?
    var short_name: String?
    var types: [String]?
    
}


struct PlaceOpeningHours: Decodable {
    var open_now: Bool?
    var periods: [PlaceOpeningHoursPeriod]?
    var weekday_text: [String]?
}

struct PlaceOpeningHoursPeriod: Decodable {
    var open: PlaceOpeningHoursPeriodDetail?
    var close: PlaceOpeningHoursPeriodDetail?
}

struct PlaceOpeningHoursPeriodDetail: Decodable {
    var day: Int?
    var time: String?
}

struct PlacePhoto: Decodable {
    var height: Double?
    var html_attributions: [String]
    var photo_reference: String?
    var width: Double?
}
