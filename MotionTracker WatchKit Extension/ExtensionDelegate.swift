//
//  ExtensionDelegate.swift
//  MotionTracker WatchKit Extension
//
//  Created by Martin Pietrowski on 27.10.20.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
	
	
	
	func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
		for task in backgroundTasks {
			switch task {
			case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
				// Be sure to complete the connectivity task once you’re done.
				connectivityTask.setTaskCompletedWithSnapshot(false)
			
			default:
				// make sure to complete unhandled task types
				task.setTaskCompletedWithSnapshot(false)
				
			}
		}
	}
	
}
