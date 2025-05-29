//
//  ChooseDirections.swift
//  StateCollegeMap
//
//  Created by Jace Anderson on 10/10/24.
//

import SwiftUI
import MapKit

struct ChooseDirections: View {
    @Binding var manager : Manager
    
    @Environment(\.dismiss) var dismiss
    
    @State var location1Ind : Int = 0
    @State var location2Ind : Int = 0
    
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Picker("From:", selection: $location1Ind) {
                            Text("User's Current Location").tag(0)
                            ForEach(manager.places.indices, id: \.self) { item in
                                Text("\(manager.places[item].name)").tag(item + 1)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        .padding()
                    }
                    Section {
                        Picker("To:", selection: $location2Ind) {
                            Text("Select a Location").tag(0)
                            ForEach(manager.places.indices, id: \.self) { item in
                                Text("\(manager.places[item].name)").tag(
                                    item + 1)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        .padding()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Dismiss") {
                            dismiss()
                        }
                    }
                }
                Button(action: {
                        var location1: CLLocationCoordinate2D
                        var location2: CLLocationCoordinate2D

                        if location1Ind == 0 {
                            location1 = manager.userLocation.center
                        } else {
                            location1 = manager.places[location1Ind - 1].coordinate
                        }

                        location2 = manager.places[location2Ind - 1].coordinate
                        manager.provideDirections(place1: location1, place2: location2)
                        dismiss()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerSize: CGSize(width: 12, height: 12))
                                .foregroundColor(location2Ind != 0 ? .green : .white)
                                .frame(height: 50)
                            Text("Go")
                                .bold()
                                .foregroundStyle(Color.black)
                        }
                    }
                    .disabled(location2Ind == 0)
                    .padding()
            }
        }
    }
}

#Preview {
    @Previewable @State var manager = Manager()
    ChooseDirections(manager: $manager)
}
