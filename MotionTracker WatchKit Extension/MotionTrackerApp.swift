//
//  MotionTrackerApp.swift
//  MotionTracker WatchKit Extension
//
//  Created by Martin Pietrowski on 25.10.20.
//

import SwiftUI

@main
struct MotionTrackerApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
