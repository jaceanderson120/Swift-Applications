//
//  AnnotationView.swift
//  StateCollegeMap
//
//  Created by Jace Anderson on 10/4/24.
//

import SwiftUI

struct AnnotationView: View {
    @Binding var manager : Manager
    var index : Int
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    Text(manager.places[index].name)
                }
                Section(header: Text("Year Construction")) {
                    if (manager.places[index].year_constructed != nil) {
                        Text(String(manager.places[index].year_constructed!))
                    } else {
                        Text("N/A")
                    }
                }
                Section(header: Text("Image")) {
                    if (manager.places[index].photo != nil) {
                        Image("\(manager.places[index].photo!)")
                    } else {
                        Text("N/A")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        manager.places[index].favorited?.toggle()
                        if (manager.places[index].favorited == true) {
                            manager.favorite()
                        } else {
                            manager.unfavorite()
                        }
                    }) {
                        if (manager.places[index].favorited == true) {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(Color.pink)
                        } else {
                            Image(systemName: "heart")
                                .foregroundStyle(Color.pink)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var manager = Manager()
    AnnotationView(manager: $manager, index: 0)
}
