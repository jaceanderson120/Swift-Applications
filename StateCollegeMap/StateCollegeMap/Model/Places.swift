//
//  Places.swift
//  StateCollegeMap
//
//  Created by Jace Anderson on 10/3/24.
//


import Foundation
import MapKit

class Places: NSObject, Identifiable, Codable, MKAnnotation {
    var id : UUID? = UUID()
    
    let name: String
    let year_constructed: Int?
    let photo: String?
    let opp_bldg_code: Int?
    
    let latitude: Double
    let longitude: Double
    
    var selected: Bool?
    var favorited: Bool?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(id: UUID? = nil, name: String, year_construct: Int?, photo: String?, opp_building_code: Int?, latitude: Double, longitude: Double, favorited: Bool? = false, selected: Bool? = false) {
        self.id = id ?? UUID()
        self.name = name
        self.year_constructed = year_construct
        self.photo = photo
        self.opp_bldg_code = opp_building_code
        self.latitude = latitude
        self.longitude = longitude
        self.favorited = favorited
        self.selected = selected
    }
}
