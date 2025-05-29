//
//  Options.swift
//  StateCollegeMap
//
//  Created by Jace Anderson on 10/8/24.
//

import SwiftUI

struct Options: View {
    @Binding var manager : Manager
    @Environment(\.dismiss) var dismiss
    @Binding var showFavs : Bool
    @Binding var mapType : MapType
    
    @State var deleteInd : Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Show Favorites?") {
                        Picker("Show Favorites?", selection: $showFavs) {
                            Text("Yes").tag(true)
                            Text("No").tag(false)
                        }
                        .pickerStyle(.segmented)
                    }
                    Section("Select Map Type") {
                        Picker("Map Types", selection: $mapType) {
                            Text("Standard").tag(MapType.standard)
                            Text("Hybrid").tag(MapType.hybrid)
                            Text("Imagery").tag(MapType.imagery)
                        }
                        .pickerStyle(.segmented)
                    }
                    Section {
                        Picker("Pick a Marker to Delete:", selection: $deleteInd) {
                            Text("Marker to Delete").tag(0)
                            ForEach(manager.tapMarkers.indices, id: \.self) { item in
                                Text("Marker \(item + 1)").tag(item + 1)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        .padding()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing)  {
                        Button("Dismiss") {
                            dismiss()
                        }
                    }
                }
                Button(action: {
                    manager.removeTapMarker(index: deleteInd - 1)
                    dismiss()
                }) {
                    ZStack {
                        RoundedRectangle(cornerSize: CGSize(width: 12, height: 12))
                            .foregroundColor(deleteInd != 0 ? .red : .white)
                            .frame(height: 50)
                        Text("Delete")
                            .bold()
                            .foregroundStyle(Color.black)
                    }
                }
                .disabled(deleteInd == 0)
                .padding()
            }
        }
    }
}

#Preview {
    @Previewable @State var manager = Manager()
    @Previewable @State var favs = true
    @Previewable @State var mapType : MapType = .standard
    Options(manager: $manager, showFavs: $favs, mapType: $mapType)
}
