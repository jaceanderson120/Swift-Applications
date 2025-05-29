//
//  Map.swift
//  StateCollegeMap
//
//  Created by Jace Anderson on 10/3/24.
//

import SwiftUI
import MapKit
import UIKit

extension CLLocationCoordinate2D {
    static let stateCollege = CLLocationCoordinate2D(latitude: 40.79550030, longitude: -77.85900170)
    
    init(coord: Coord) {
        self = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
    }
    
}

enum MapType {
    case standard
    case hybrid
    case imagery
    
    var mkMapType: MKMapType {
        switch self {
        case .standard:
            return .standard
        case .hybrid:
            return .hybrid
        case .imagery:
            return .satellite
        }
    }
}

struct MapView: View {
    @State var manager : Manager
    @State var camera : MapCameraPosition = .automatic
    @State var typeOfMap : MapType = .standard
    
    @State var showBuildingMenu : Bool = false
    @State var showOptionsMenu : Bool = false
    @State var showDirections : Bool = false
    @State var showTapDirections : Bool = false
    
    @State var currentRoute : Int = 0
    
    @State var showFavorites : Bool = true
    
    @State var showInfo : Bool = false
    @State var infoIndex : InfoIndex? = nil
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottomLeading) {
                MapViewUIKit(typeOfMap: $typeOfMap)
                HStack {
                    Button(action: {
                        manager.removeRoutes()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerSize: CGSize(width: 12, height: 12))
                                .foregroundColor(manager.routes.first != nil ? .red : .white)
                                .frame(height: 50)
                            Text("End")
                                .bold()
                                .foregroundStyle(Color.black)
                        }
                    }
                    .frame(width: 100, height: 100)
                    .opacity(manager.routes.first != nil ? 1.0 : 0)
                    .padding()
                    Spacer()
                    TabView(selection: $currentRoute) {
                        if let routes = manager.routes.first {
                            ForEach(routes.steps.indices, id: \.self) {index in
                                Text("\(routes.steps[index].instructions)")
                                    .bold()
                            }
                        }
                    }
                    .frame(width: 100, height: 100)
                    .padding()
                    .tabViewStyle(.page)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Button(action: {
                            showBuildingMenu.toggle()
                        }) {
                            Image(systemName: "building.2")
                        }
                        Button(action: {
                            showDirections.toggle()
                        }) {
                            Image(systemName: "map")
                        }
                        Button(action: {
                            showTapDirections.toggle()
                        }) {
                            Image(systemName: "map.circle")
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button(action: {
                            showOptionsMenu.toggle()
                        }) {
                            Image(systemName: "gear")
                        }
                        Button(action: {
                            manager.removeMarkers()
                        }) {
                            Image(systemName: "trash.slash")
                        }
                    }
                }
                ToolbarItem(placement: .navigation) {
                    Text("ETA: \(manager.etaMins) Mins \(manager.etaSecs) Secs")
                        .opacity(manager.showEta ? 1.0 : 0.0)
                        .bold()
                }
            }
            .sheet(isPresented: $showTapDirections) {
                MarkerView(manager: $manager)
            }
            .sheet(isPresented: $showBuildingMenu) {
                BuildingMenu(manager: $manager)
            }
            .sheet(isPresented: $showDirections) {
                ChooseDirections(manager: $manager)
            }
            .sheet(isPresented: $showOptionsMenu) {
                Options(manager: $manager, showFavs: $showFavorites, mapType: $typeOfMap)
            }
            .sheet(item: $infoIndex) { index in
                AnnotationView(manager: $manager, index: index.id)
            }
        }
    }
}

extension MapView {
    var favoriteLocations: some MapContent {
        ForEach(manager.places.indices, id: \.self) { index in
            let place = manager.places[index]
            if place.selected == true && place.favorited == true {
                Annotation(place.name, coordinate: place.coordinate) {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(Color.pink)
                        .onTapGesture {
                            infoIndex = InfoIndex(id: index)
                        }
                }
            }
        }
    }

    var locations: some MapContent {
        ForEach(manager.places.indices, id: \.self) { index in
            let place = manager.places[index]
            if place.selected == true && place.favorited == false {
                Annotation(place.name, coordinate: place.coordinate) {
                    Image(systemName: "mappin")
                        .foregroundStyle(Color.red)
                        .onTapGesture {
                            infoIndex = InfoIndex(id: index)
                        }
                }
            }
        }
    }
    
    var routeLocations: some MapContent {
        ForEach(manager.routes.indices, id: \.self) { index in
            let route = manager.routes[index]
            if let startCoordinate = route.steps.first?.polyline.coordinate {
                Annotation("Start", coordinate: startCoordinate) {
                    Image(systemName: "pin.circle.fill")
                        .foregroundColor(.green)
                }
            }
            if let endCoordinate = route.steps.last?.polyline.coordinate {
                Annotation("End", coordinate: endCoordinate) {
                    Image(systemName: "pin.circle.fill")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct InfoIndex: Identifiable {
    let id: Int
}

#Preview {
    @Previewable @State var manager = Manager()
    MapView(manager: manager)
}
