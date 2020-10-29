//
//  MotionTrackerApp.swift
//  MotionTracker
//
//  Created by Martin Pietrowski on 25.10.20.
//

import SwiftUI

@main
struct MotionTrackerApp: App {
	
	private let watchConnectivitySessionService = WatchConnectivitySessionService()
	
    var body: some Scene {
        WindowGroup {
            MenuView()
        }
    }
	
}
