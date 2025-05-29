//
//  DirectionsExtension.swift
//  StateCollegeMap
//
//  Created by Jace Anderson on 10/10/24.
//

import Foundation
import MapKit


extension Manager {
    
    func provideDirections(place1: CLLocationCoordinate2D, place2: CLLocationCoordinate2D) {
        self.routes.removeAll()
        let request = MKDirections.Request()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: place2))
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: place1))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard error == nil else { return }
            
            if let route = response?.routes.first {
                self.routes.append(route)
            }
            
            self.getETA(routes: self.routes)
        }
    }
    
    func getETA(routes: [MKRoute]) {
        var total = 0.0
        self.etaMins = 0
        self.etaSecs = 0
        for route in routes {
            total += route.expectedTravelTime
        }
        self.etaMins = Int(total) / 60
        self.etaSecs = Int(total) % 60
        showEta = true
    }
}
