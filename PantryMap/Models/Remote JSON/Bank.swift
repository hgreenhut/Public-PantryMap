//
//  Bank.swift
//  City Sights
//
//  Created by Henry Greenhut on 8/30/22.
//

import Foundation



class Bank: Decodable, Identifiable, ObservableObject {
    var title: String?
    var placeUrl: String?
    var website: String?
    var address: String?
    var phoneNumber: String?
    var email: String?
    var volunteerInfo: String?
    var extraInfo: String?
    var volunteerWebsite: String?
    var volunteerEmail: String?
    var volunteerPhone: String?

}
