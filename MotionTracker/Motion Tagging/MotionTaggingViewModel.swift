//
//  MotionTaggingViewModel.swift
//  MotionTracker
//
//  Created by Martin Pietrowski on 29.10.20.
//

import SwiftUI

class MotionTaggingViewModel: ObservableObject {
	
	private var currentSessionDate: Date?
	@Published private(set) var currentRepCount = 0
	private let persistentDataPointsService = PersistentDataPointsService()
	private let notificationCenter = NotificationCenter.default
	
	init() {
		setupObserving()
	}
	
	private func setupObserving() {
		notificationCenter.addObserver(
			self,
			selector: #selector(startSession),
			name: Notification.Name("UserEvent.trackingStarted"),
			object: nil
		)
	}
	
	@objc
	func startSession() {
		currentSessionDate = Date()
		currentRepCount = 0
	}
	
	func tagMotionEvent(date: Date, isBeginTag: Bool) {
		if currentSessionDate == nil {
			currentSessionDate = date
		}
		
		if isBeginTag {
			currentRepCount = currentRepCount + 1
		}
		
		let timestamp = TimeStamp(event: isBeginTag ? .beginTag : .endTag, timeOcurred: Date().timeIntervalSince1970)
		persistentDataPointsService.save(timeStamp: timestamp, startDate: currentSessionDate!)
	}
	
}
