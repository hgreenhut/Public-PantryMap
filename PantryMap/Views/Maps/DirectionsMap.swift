//
//  DirectionsMap.swift
//  PantryMap
//
//  Created by Henry Greenhut on 8/15/22.
//

import SwiftUI
import MapKit

struct DirectionsMap: UIViewRepresentable {
    @EnvironmentObject var model: ContentModel
    @State var tabIndex: String
    var place: Place
    var start: CLLocationCoordinate2D {
        return model.locationManager.location?.coordinate ?? CLLocationCoordinate2D()
    }
    
    var end: CLLocationCoordinate2D {
        
        if let lat = place.geometry?.location?.lat, let long = place.geometry?.location?.lng {
            return CLLocationCoordinate2D(latitude: lat, longitude: long)
            
        }
        else {
            return CLLocationCoordinate2D()
        }
    }
    
    var locations: [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        // Create a set of annotations from our list of places
        let a = MKPointAnnotation()
        a.coordinate = CLLocationCoordinate2D(latitude: start.latitude, longitude: start.longitude)
        annotations.append(a)
        
        let b = MKPointAnnotation()
        b.coordinate = CLLocationCoordinate2D(latitude: end.latitude, longitude: end.longitude)
        b.title = place.name
        annotations.append(b)
        return annotations
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        
        map.showsUserLocation = true
        map.userTrackingMode = .followWithHeading
        // Create directions request
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
        request.requestsAlternateRoutes = false
        if (tabIndex == "Driving") {
            request.transportType = .automobile
        } else if (tabIndex == "Transit") {
            request.transportType = .transit
        } else {
            request.transportType = .walking
        }
        
        // Create directions object
        let directions = MKDirections(request: request)
        if (request.transportType == .transit) {
            directions.calculateETA { response, error in
                if error == nil && response != nil {
                    map.showAnnotations(locations, animated: true)
                    model.expectedTravelTime = response!.expectedTravelTime
                    model.distance = response!.distance.magnitude
                    // Add source & destination to map w/0 overlay
                }
                
            }
        }
        directions.calculate { response, error in
            if error == nil && response != nil {
                for route in response!.routes {
                    model.expectedTravelTime = route.expectedTravelTime
                    model.distance = route.distance.magnitude
                    map.addOverlay(route.polyline)
                    map.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
                    
                }
                
                
            }
            else{
                
            }
        }
        // Place annotation for the end point
        let annotation = MKPointAnnotation()
        annotation.coordinate = end
        annotation.title = place.name ?? ""
        map.addAnnotation(annotation)
        // Calculate route
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    static func dismantleUIView(_ uiView: MKMapView, coordinator: ()) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.removeOverlays(uiView.overlays)
    }
    
    func makeCoordinator() -> (Coordinator) {
        return Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            return renderer
            
        }
    }
}

