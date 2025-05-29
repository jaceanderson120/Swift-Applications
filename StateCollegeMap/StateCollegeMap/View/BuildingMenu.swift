//
//  BuildingMenu.swift
//  StateCollegeMap
//
//  Created by Jace Anderson on 10/3/24.
//

import SwiftUI
import MapKit

enum Filter: String, CaseIterable {
    case all = "All"
    case favorite = "Favorite"
    case selected = "Selected"
    case nearby = "Nearby"
}


struct BuildingMenu: View {
    @Binding var manager: Manager
    @Environment(\.dismiss) var dismiss
    @State var filter : Filter = .all
    
    func nearbyBuilding(building: Places) -> Bool {
        let userLocation = manager.locationManager.location
        let buildingLocation = CLLocation(latitude: building.latitude, longitude: building.longitude)
        let userToBuilding = userLocation?.distance(from: buildingLocation)
        if userToBuilding! < 500 {
            return true
        }
        return false
    }
    
    var buildingsAfterFilter: [(index: Int, place: Places)] {
        manager.places.enumerated().compactMap { (index, place) in
            switch filter {
            case .all:
                return (index, place)
            case .favorite:
                return place.favorited == true ? (index, place) : nil
            case .selected:
                return place.selected == true ? (index, place) : nil
            case .nearby:
                return nearbyBuilding(building: place) ? (index, place) : nil
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter", selection: $filter) {
                    ForEach(Filter.allCases, id: \.self) { item in
                        Text("\(item.rawValue)").tag(item)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                List {
                    ForEach(buildingsAfterFilter, id: \.index) { building in
                        HStack {
                            Button(action: {
                                manager.places[building.index].selected?.toggle()
                                if (manager.places[building.index].selected == true) {
                                    manager.select()
                                }
                                else {
                                    manager.deselect()
                                }
                                manager.forceUpdate()
                            }) {
                                HStack {
                                    if ((manager.places[building.index].selected) != nil && manager.places[building.index].selected == true) {
                                        Image(systemName: "checkmark")
                                    }
                                    Text(manager.places[building.index].name)
                                }
                            }
                            Spacer()
                            Button(action: {
                                manager.places[building.index].favorited?.toggle()
                                if (manager.places[building.index].favorited == true) {
                                    manager.favorite()
                                }
                                else {
                                    manager.unfavorite()
                                }
                                manager.forceUpdate()
                            }) {
                                if ((manager.places[building.index].favorited) != nil && manager.places[building.index].favorited == true) {
                                    Image(systemName: "heart.fill")
                                }
                                else {
                                    Image(systemName: "heart")
                                }
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
                .navigationTitle("Select Buildings")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Dismiss") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            if (manager.numFavs == manager.places.count) {
                                Button(action: {
                                    manager.unfavAll()
                                    manager.forceUpdate()
                                }) {
                                    Image(systemName: "heart.fill")
                                        .foregroundStyle(Color.pink)
                                }
                            }
                            else {
                                Button(action: {
                                    manager.favAll()
                                    manager.forceUpdate()
                                }) {
                                    Image(systemName: "heart")
                                        .foregroundStyle(Color.pink)
                                }
                            }
                            if (manager.numSelected == manager.places.count) {
                                Button(action: {
                                    manager.deselectAll()
                                    manager.forceUpdate()
                                }) {
                                    Image(systemName: "checkmark.square.fill")
                                        .foregroundStyle(Color.green)
                                }
                            }
                            else {
                                Button(action: {
                                    manager.selectAll()
                                    manager.forceUpdate()
                                }) {
                                    Image(systemName: "checkmark.square")
                                        .foregroundStyle(Color.red)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var manager = Manager()
    BuildingMenu(manager: $manager)
}
