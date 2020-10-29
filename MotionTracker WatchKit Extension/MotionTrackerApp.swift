//
//  MotionTrackerApp.swift
//  MotionTracker WatchKit Extension
//
//  Created by Martin Pietrowski on 25.10.20.
//

import SwiftUI

@main
struct MotionTrackerApp: App {
	let contentViewModel = ContentViewModel()
	
	@Environment(\.scenePhase) var scenePhase
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
				ContentView(viewModel: contentViewModel)
            }
		}.onChange(of: scenePhase) { newScenePhase in
			switch newScenePhase {
			case .background:
				print("Background")
			case .inactive:
				print("Inactive")
			case .active:
				
				print("Active")
			@unknown default:
				print("Unknown scene phase: \(newScenePhase)")
			}
		}
    }
}
