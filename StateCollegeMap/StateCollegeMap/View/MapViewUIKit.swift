//
//  MapViewUIKit.swift
//  StateCollegeMap
//
//  Created by Jace Anderson on 10/17/24.
//

import SwiftUI
import MapKit
import UIKit

struct MapViewUIKit: UIViewRepresentable {
    @Environment(Manager.self) var manager
    @Binding var typeOfMap : MapType
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.region = manager.region
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.showsUserTrackingButton = true
        mapView.mapType = typeOfMap.mkMapType
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(MapViewUICoordinator.tapHandler(recognizer:)))
        mapView.addGestureRecognizer(tapGesture)
        
        
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        mapView.mapType = typeOfMap.mkMapType
        
        let selectedPlaces = manager.places.filter { $0.selected! }
        
        selectedPlaces.forEach { place in
            if place.favorited == true {
                let annotation = MKPointAnnotation()
                annotation.coordinate = place.coordinate
                annotation.title = place.name
                annotation.subtitle = "Favorited"
                mapView.addAnnotation(annotation)
            } else {
                let annotation = MKPointAnnotation()
                annotation.coordinate = place.coordinate
                annotation.title = place.name
                mapView.addAnnotation(annotation)
            }
        }
        mapView.addAnnotations(manager.tapMarkers)
        mapView.addOverlays(manager.polylines)
        
        mapView.setNeedsDisplay()
        mapView.setNeedsLayout()
    }
        
        
    func makeCoordinator() -> MapViewUICoordinator {
        return MapViewUICoordinator(manager: manager)
    }
}

#Preview {
    @Previewable @State var map : MapType = .standard
    MapViewUIKit(typeOfMap: $map)
}
