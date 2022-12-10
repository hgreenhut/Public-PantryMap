//
//  NearbyMap.swift
//  PantryMap
//
//  Created by Henry Greenhut on 8/13/22.
//

import SwiftUI
import MapKit

struct NearbyMap: UIViewRepresentable {
    @EnvironmentObject var model: ContentModel
    @Binding var selectedIcon: Place?
    var locations: [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        // Create a set of annotations from our list of places
        for icon in model.places {
            // Create a new annotation
            if let lat = icon.geometry?.location?.lat, let long = icon.geometry?.location?.lng{
                let a = MKPointAnnotation()
                a.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                a.title = icon.name ?? ""
                annotations.append(a)
            }
            
            
        }
        return annotations
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        
        // Make the user show up on the map
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        mapView.mapType = .hybridFlyover
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        // Remove all annotations
        
        
        // uiView.removeAnnotations(uiView.annotations)
        if (self.locations.count <= 20) {
            uiView.showAnnotations(self.locations, animated: true)
        }
        else {
            uiView.addAnnotations(self.locations)
        }
        
        
    }
    
    static func dismantleUIView(_ uiView: MKMapView, coordinator: ()) {
        uiView.removeAnnotations(uiView.annotations)
    }
    
    func makeCoordinator() -> (Coordinator) {
        return Coordinator(map: self)
    }
    class Coordinator: NSObject, MKMapViewDelegate {
        var map: NearbyMap
        init(map: NearbyMap){
            self.map = map
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            // Check if there's a reusable annotatin view first
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.annotationReuseID
            )
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Constants.annotationReuseID)
                
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                
                return annotationView
            }
            else {
                annotationView!.annotation = annotation
            }
            // Create an annotation view
            return annotationView
            
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            // User tapped on the annotation view
            
            // Get the business object that this annotation represents
            for icon in map.model.places {
                if icon.name == view.annotation?.title {
                    map.selectedIcon = icon
                    return
                }
            }
            // Set the selectedIcon property to that icon object
        }
    }
}

