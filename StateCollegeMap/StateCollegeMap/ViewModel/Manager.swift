//
//  Manager.swift
//  StateCollegeMap
//
//  Created by Jace Anderson on 10/3/24.
//

import Foundation
import MapKit


@Observable
class Manager : NSObject {
    var places : [Places] = []
    
    var numFavs : Int = 0
    var numSelected : Int = 0
    
    var routes = [MKRoute]()
    var polylines : [MKPolyline] {routes.map { $0.polyline }}
    var tapMarkers : [MKAnnotation] = []
    
    var etaMins : Int = 0
    var etaSecs : Int = 0
    var showEta = false
    
    var userLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.8021172314745, longitude: -77.853609484381), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    var region = MKCoordinateRegion(center: .stateCollege, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    let placeManager : BuildingStorage = BuildingStorage<[Places]>()
    
    let locationManager : CLLocationManager = .init()
    
    override init() {
        super.init()
        if let modelData = placeManager.modelData {
            for place in modelData {
                if place.id == nil {
                    place.id = UUID()
                }
                if place.favorited == nil {
                    place.favorited = false
                }
                if place.selected == nil {
                    place.selected = false
                }
                places.append(place)
            }
            sortPlaces()
        } else {
            self.places = []
        }
        findNumSelect()
        findNumFavorited()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func sortPlaces() {
        places.sort { (firstName, secondName) in
            firstName.name < secondName.name
        }
    }
    
    func save() {
        placeManager.save(components: places)
    }
    
    func favorite() {
        numFavs -= 1
    }
    
    func unfavorite() {
        numFavs -= 1
    }
    
    func favAll() {
        numFavs = places.count
        for index in places.indices {
            places[index].favorited = true
        }
    }
    
    func unfavAll() {
        numFavs = 0
        for index in places.indices {
            places[index].favorited = false
        }
    }
    
    func findNumFavorited() {
        for index in places.indices {
            if places[index].favorited == true {
                numFavs += 1
            }
        }
    }
    
    func select() {
        numSelected += 1
    }
    
    func deselect() {
        numSelected -= 1
    }
    
    func selectAll() {
        numSelected = places.count
        for index in places.indices {
            places[index].selected = true
        }
    }
    
    func deselectAll() {
        numSelected = 0
        for index in places.indices {
            places[index].selected = false
        }
    }
    
    func findNumSelect() {
        for index in places.indices {
            if places[index].selected == true {
                numSelected += 1
            }
        }
    }
    
    func removeRoutes() {
        routes.removeAll()
        etaMins = 0
        etaSecs = 0
        showEta = false
    }
    
    func forceUpdate() {
        self.places.append(Places(name: "none", year_construct: 1999, photo: nil, opp_building_code: 12, latitude: 12.12, longitude: 12.12))
        self.places.removeLast()
    }
    
    func removeMarkers() {
        self.tapMarkers.removeAll()
    }
    
    func removeTapMarker(index: Int) {
        tapMarkers.remove(at: index)
    }
}
