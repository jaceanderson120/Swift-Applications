//
//  MapViewUICoordinator.swift
//  StateCollegeMap
//
//  Created by Jace Anderson on 10/17/24.
//

import Foundation
import MapKit

class MapViewUICoordinator: NSObject, MKMapViewDelegate {
    var manager : Manager
    var tapMarkers: [MKPointAnnotation] = []
    
    init(manager: Manager) {
        self.manager = manager
        super.init()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        polylineRenderer.lineWidth = 4.0
        polylineRenderer.strokeColor = UIColor.red
        return polylineRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let placesId = "PlaceId"
        
        var annotations = mapView.dequeueReusableAnnotationView(withIdentifier: placesId) as? MKMarkerAnnotationView
        
        if annotations == nil {
            annotations = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: placesId)
            annotations?.canShowCallout = true
            annotations?.displayPriority = .required
        } else {
            annotations?.annotation = annotation
        }
        
        if let placeAnnotation = annotation as? MKPointAnnotation, let place = manager.places.first(where: { $0.name == placeAnnotation.title }) {
            if place.favorited == true {
                annotations?.markerTintColor = .orange
                annotations?.glyphText = "★"
            } else {
                annotations?.markerTintColor = .blue
                annotations?.glyphText = nil
            }
        }
            
        return annotations
    }
    
    @objc func tapHandler(recognizer: UITapGestureRecognizer) {
        guard let mapView = recognizer.view as? MKMapView else { return }
        
        let tapLocation = recognizer.location(in: mapView)
        let coordinate = mapView.convert(tapLocation, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Marker \(manager.tapMarkers.count + 1)"
        manager.tapMarkers.append(annotation)
    }
}


