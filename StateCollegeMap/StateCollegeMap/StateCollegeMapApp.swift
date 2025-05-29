//
//  StateCollegeMapApp.swift
//  StateCollegeMap
//
//  Created by Jace Anderson on 10/3/24.
//

import SwiftUI

@main
struct StateCollegeMapApp: App {
    @Environment(\.scenePhase) var scenePhase
    @State var manager = Manager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(manager)
                .onChange(of: scenePhase) { oldValue, newValue in
                    switch newValue {
                    case .background, .active:
                        manager.save()
                    default:
                        break
                    }
                }
        }
    }
}
