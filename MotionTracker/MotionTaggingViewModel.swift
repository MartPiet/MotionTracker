//
//  MotionTaggingViewModel.swift
//  MotionTracker
//
//  Created by Martin Pietrowski on 29.10.20.
//

import Foundation

class MotionTaggingViewModel {
	
	private var currentSessionDate: Date?
	private let persistentDataPointsService = PersistentDataPointsService()
	
	func startSession() {
		currentSessionDate = Date()
	}
	
	func tagMotionEvent(date: Date, isBeginTag: Bool) {
		if currentSessionDate == nil {
			currentSessionDate = date
		}
		
		let timestamp = TimeStamp(event: isBeginTag ? .beginTag : .endTag, timeOcurred: Date().timeIntervalSince1970)
		persistentDataPointsService.save(timeStamp: timestamp, startDate: currentSessionDate!)
	}
	
}
