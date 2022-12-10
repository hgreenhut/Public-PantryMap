//
//  ContentModel.swift
//  PantryMap
//
//  Created by Henry Greenhut on 8/4/22.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

class ContentModel: NSObject,CLLocationManagerDelegate, ObservableObject {
    @Published var banks = [Bank]()
    @Published var selectedBank: Bank?
    @Published var expectedTravelTime: Double?
    @Published var distance: Double?
    @Published var transportType: MKDirectionsTransportType?
    @Published var places = [Place]()
    @Published var selectedPlace: PlaceDetail?
    @Published var selectedPhoto: Data?
    var locationManager = CLLocationManager()
    var tries = 0
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    @Published var placemark: CLPlacemark?
    @State var userLocation: CLLocation?
    override init() {
        super.init()
        
        
        locationManager.delegate  = self
        // Request Permission from the user
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
          print("error:: \(error.localizedDescription)")
     }
    func requestGeoLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    // MARK - Location Manager Delegate Methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationState = locationManager.authorizationStatus
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            // start geolocating the user
            locationManager.startUpdatingLocation()
    
        }
        else if locationManager.authorizationStatus == .denied {
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.first
        
        if userLocation != nil {
            locationManager.stopUpdatingLocation()
            locationManager.pausesLocationUpdatesAutomatically = true
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(userLocation!) { placemarks, error in
                if error == nil && placemarks != nil {
                    self.placemark = placemarks?.first
                }
            }
          //  self.getRemoteData()
            self.userLocation = userLocation!
           self.getPlaces(location: userLocation!)
            
            
        }
        
    }
      
    
    
    func getPlaces(location: CLLocation, token: String = "") {
        
        
        if (token == "") {
            var urlComponents = URLComponents(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json")
            urlComponents?.queryItems = [
                URLQueryItem(name: "keyword", value: "Food Bank"),
                URLQueryItem(name: "location", value: "\(String(location.coordinate.latitude)), \(String(location.coordinate.longitude))"),
                URLQueryItem(name: "rankby", value: "distance"),
                URLQueryItem(name: "key", value: Constants.apiKey)
            ]
            let url = urlComponents?.url
            if let url = url {
                
                // Create URL Request
                var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 100.0)
                
                request.httpMethod = "GET"
                request.addValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")
                
                // Get URLSession
                let session = URLSession.shared
                
                // Get Data Task
                let dataTask = session.dataTask(with: request) { data, response, error in
                    // check no error
                    if error == nil {
                        do {
                            
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(Search.self, from: data!)
                            DispatchQueue.main.async {
                                self.places += result.results
                                
                            }
                            if (result.status == "INVALID_REQUEST") {
                                self.getPlaces(location: location, token: token)
                            }
                            
                            if result.next_page_token != nil {
                                
                                let seconds = 4.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                    
                                    self.getPlaces(location: location, token: result.next_page_token!)
                                }
                                
                            }
                            else {
                                
                            }
                             
                            
                            
                            
                            
                        }
                        
                        catch {
                            //            print(error)
                        }
                        
                    }
                }
                dataTask.resume()
                
                // Start the Data Task
                
            }
        } else {
            var urlComponents = URLComponents(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json")
            urlComponents?.queryItems = [
                URLQueryItem(name: "pagetoken", value: token),
                URLQueryItem(name: "key", value: Constants.apiKey)
            ]
            let url = urlComponents?.url
            if let url = url {
                
                // Create URL Request
                var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 100.0)
                
                request.httpMethod = "GET"
                request.addValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")
                
                // Get URLSession
                let session = URLSession.shared
                
                // Get Data Task
                let dataTask = session.dataTask(with: request) { data, response, error in
                    // check no error
                    if error == nil {
                        do {
                            
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(Search.self, from: data!)
                            DispatchQueue.main.async {
                                self.places += result.results
                            }
                            if (result.status == "INVALID_REQUEST") {
                                self.getPlaces(location: location, token: token)
                            }
                            
                            if result.next_page_token != nil {
                                Thread.sleep(forTimeInterval: 2)
                                self.getPlaces(location: location, token: result.next_page_token!)
                            }
                            
                            
                            
                        }
                        
                        catch {
                            //      print(error)
                        }
                        
                    }
                }
                dataTask.resume()
                
                // Start the Data Task
                
            }
            
        }
        
        
        
    }
    
    func getDetail(placeID: String){
        var urlComponents = URLComponents(string: "https://maps.googleapis.com/maps/api/place/details/json")
        urlComponents?.queryItems = [
            URLQueryItem(name: "place_id", value: placeID),
            URLQueryItem(name: "fields", value: "formatted_address,name,photos,formatted_phone_number,opening_hours,website,geometry,url,adr_address"),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        let url = urlComponents?.url
        if let url = url {
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 100.0)
            
            request.httpMethod = "GET"
            request.addValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")
            
            // Get URLSession
            let session = URLSession.shared
            
            // Get Data Task
            let dataTask = session.dataTask(with: request) { data, response, error in
                if error == nil {
                    do {
                        
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(Detail.self, from: data!)
                        DispatchQueue.main.async {
                            self.selectedPlace = result.result
                            
                            
                        }
                        if self.selectedPlace != nil {
                            try self.findBank()
                        }
                        else {
                            sleep(1)
                            try self.findBank()
                        }
                        
                        
                        
                        if result.result.photos != nil {
                            self.getImage(reference: result.result.photos![0].photo_reference!)
                        }
                        else {
                   
                                self.getStreetView()
                            
                            
                            
                        }
                        
                        
                    }
                    
                    catch {
                    }
                    
                } else {
                }
            }
            dataTask.resume()
    
        }
        
    }
    func getImage(reference: String) {
        var urlComponents = URLComponents(string: "https://maps.googleapis.com/maps/api/place/photo")
        urlComponents?.queryItems = [
            URLQueryItem(name: "photo_reference", value: reference),
            URLQueryItem(name: "maxwidth", value: "1284"),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        let url = urlComponents?.url
        if let url = url {
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 100.0)
            
            request.httpMethod = "GET"
            request.addValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")
            
            // Get URLSession
            let session = URLSession.shared
            
            // Get Data Task
            let dataTask = session.dataTask(with: request) { data, response, error in
                if error == nil {
                    do {
                        DispatchQueue.main.async {
                            self.selectedPhoto = data!
                        }
                    }
                }
                else {
                    print("no photo")
                }
            }
            dataTask.resume()
        }
    }
    
    func getStreetView() {
        guard self.selectedPlace != nil else {
            getStreetView()
            return
        }
        if let lat = self.selectedPlace?.geometry?.location?.lat, let lng = self.selectedPlace?.geometry?.location?.lng {
            var urlComponents = URLComponents(string: "https://maps.googleapis.com/maps/api/streetview")
            urlComponents?.queryItems = [
                URLQueryItem(name: "location", value: "\(String(lat)), \(String(lng))"),
                URLQueryItem(name: "key", value: Constants.apiKey),
                URLQueryItem(name: "return_error_code", value: "true"),
                URLQueryItem(name: "size", value: "1284x1284")
            ]
            let url = urlComponents?.url
            if let url = url {
                var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 100.0)
                
                request.httpMethod = "GET"
                request.addValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")
                
                // Get URLSession
                let session = URLSession.shared
                
                // Get Data Task
                let dataTask = session.dataTask(with: request) { data, response, error in
                    if error == nil {
                        do {
                            DispatchQueue.main.async {
                                self.selectedPhoto = data!
                            }
                            
                        }
                        
                        
                    }
                    else{
                        print("error")
                    }
                }
                dataTask.resume()
                
            }
            
        }
        else {
            self.getStreetView()
        }
    }
    
    func getRemoteData() {
        
        // String path
        let urlString = Constants.bankInfoURL
        
        // Create a url object
        let url = URL(string: urlString)
        
        guard url != nil else {
            // Couldn't create url
            return
        }
        
        // Create a URLRequest object
        let request = URLRequest(url: url!)
        
        // Get the session and kick off the task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            // Check if there's an error
            guard error == nil else {
                // There was an error
                return
            }
            
            do {
                // Create json decoder
                let decoder = JSONDecoder()
                
                // Decode
                let banks = try decoder.decode([Bank].self, from: data!)
                
                // Append parsed modules into modules property
                DispatchQueue.main.async {
                    self.banks = banks
                }
                
            }
            catch {
                // Couldn't parse json
            }
        }
        
        // Kick off data task
        dataTask.resume()
        
    }
    
    func findBank() throws{
        if let name = self.selectedPlace?.name {
            let result = self.banks.filter { $0.title!.contains(name) }

            if result.count > 0 {
                
                DispatchQueue.main.async {
                    self.arrangeData(bank: result[0])
                    self.selectedBank = result[0]
                }
            }
            
            
            
        }
        else if tries < 20 {
            do {
                try self.findBank()
            }
            catch {
                sleep(1)
                try self.findBank()
            }
        }
        
        
    }
    
    
    func arrangeData(bank: Bank) {
        if bank.volunteerWebsite != nil && bank.volunteerWebsite != "" {
            bank.website = bank.volunteerWebsite!
            selectedPlace?.website = bank.volunteerWebsite
            if bank.volunteerInfo != nil && bank.volunteerInfo != ""{
                bank.volunteerInfo? += "\n\nVisit \(bank.volunteerWebsite!) for more volunteer information!"
            }
            else {
                bank.volunteerInfo? += "Visit \(bank.volunteerWebsite!) for more volunteer information!"
            }
           
        }
         if bank.volunteerEmail != nil && bank.volunteerEmail != "" {
            bank.email = bank.volunteerEmail!
            if bank.volunteerInfo != nil && bank.volunteerInfo != "" {
                bank.volunteerInfo? += "\n\nContact \(bank.volunteerEmail!) for volunteering details!"
            }
            else {
                bank.volunteerInfo? += "Contact \(bank.volunteerEmail!) for volunteering details!"
            }
            
         
        }
         if bank.volunteerPhone != nil && bank.volunteerPhone != "" {
            bank.phoneNumber = bank.volunteerPhone!
            selectedPlace?.formatted_phone_number = bank.volunteerPhone!
            if bank.volunteerInfo != nil && bank.volunteerInfo != ""{
                bank.volunteerInfo? += "\n\nContact \(bank.volunteerPhone!) for volunteering details!"
            }
            else {
                bank.volunteerInfo? += "Contact \(bank.volunteerPhone!) for volunteering details"
            }
            
            
           
        }
    
    }
    
    
    func formatPhone(number: String) -> String{
        return number.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    
}

