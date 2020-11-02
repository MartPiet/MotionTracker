//
//  ContentViewModel.swift
//  MotionTracker WatchKit Extension
//
//  Created by Martin Pietrowski on 25.10.20.
//

import Combine
import WatchKit
import WatchConnectivity

class ContentViewModel: NSObject, ObservableObject {
	
	@Published var motionValuesTextRepresentation: String = "Not started"
	private var isMotionTrackingRunning: Bool = false
	@Published var motionTrackingButtonTitle: String = "Start Tracking"
	private let motionManager = MotionManager()
	private let dataTransferService = DataTransferService()
	
	private let extendedRuntimeSession = WKExtendedRuntimeSession()
	private let persistentDataPointsService = PersistentDataPointsService()
	
	override init() {
		super.init()
		setup()
	}

	private func setup() {
		extendedRuntimeSession.delegate = self
		motionManager.delegate = self
	}
	
	func toggleMotionTracking() {
		if !motionManager.isRunning {
			startMotionTracking()
		} else {
			stopMotionTracking()
		}
	}
	
	private func startMotionTracking() {
		extendedRuntimeSession.start()
		motionManager.startSession()
		motionTrackingButtonTitle = "Stop Tracking"
		dataTransferService.sendEventToParentDevice(event: .trackingStarted)
	}
	
	private func stopMotionTracking() {
		motionManager.stopSession()
		motionValuesTextRepresentation = "Stopped"
		motionTrackingButtonTitle = "Start Tracking"
		sendDataToParentDevice()
		dataTransferService.sendEventToParentDevice(event: .trackingStopped)
	}
	
	private func sendDataToParentDevice() {
		let fileURLs = persistentDataPointsService.retrieveSessionFileURLs()
		
		for fileURL in fileURLs {
			dataTransferService.sendDataToParentDevice(fileURL: fileURL) { [weak self] in
				self?.persistentDataPointsService.delete(fileURL: fileURL)
			}
		}
	}
	
}

extension ContentViewModel: WKExtendedRuntimeSessionDelegate {
	
	func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
		
	}
	
	func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
		stopMotionTracking()
		motionValuesTextRepresentation = "Session expired"
	}
	
	func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
		stopMotionTracking()
		motionValuesTextRepresentation = "Session invalid"
	}
	
}

extension ContentViewModel: MotionManagerDelegate {
	
	func measurePointsUpdated(_ interfaceModel: MotionManager, measurePointDescription: String?, error: Error?) {
		if motionManager.isRunning {
			motionValuesTextRepresentation = measurePointDescription ?? "None"
		}
	}
	
	func sessionExpirationDateUpdated(_ interfaceModel: MotionManager, expirationDate: Date) {
		
	}
	
	func didUpdateRecognisedRepetitons(repetitions: Int) {
		
	}
	
	func didRecognise(label: String) {
		
	}
	
}
