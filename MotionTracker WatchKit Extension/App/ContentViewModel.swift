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
	@Published var isFinished: Bool = true
	
	private var extendedRuntimeSession: WKExtendedRuntimeSession?
	private let persistentDataPointsService = PersistentDataPointsService()
	
	override init() {
		super.init()
		setup()
	}

	private func setup() {
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
		extendedRuntimeSession?.invalidate()
		extendedRuntimeSession = WKExtendedRuntimeSession()
		extendedRuntimeSession?.delegate = self
		extendedRuntimeSession?.start()
		motionManager.startSession()
		motionTrackingButtonTitle = "Stop Tracking"
		dataTransferService.sendEventToParentDevice(event: .trackingStarted)
	}
	
	private func stopMotionTracking() {
		motionManager.stopSession()
		motionValuesTextRepresentation = "Stopped"
		motionTrackingButtonTitle = "Finishing..."
		isFinished = false
		DispatchQueue.main.async { [weak self] in
			self?.sendDataToParentDevice() { [weak self] isFinished in
				guard let strongSelf = self else {
					return
				}
				strongSelf.isFinished = isFinished
				strongSelf.motionTrackingButtonTitle = "Start Tracking"
			}
		}
		dataTransferService.sendEventToParentDevice(event: .trackingStopped)
	}
	
	private func sendDataToParentDevice(completion: @escaping (Bool) -> Void) {
		let fileURLs = persistentDataPointsService.retrieveSessionFileURLs()
		
		if fileURLs.isEmpty {
			completion(true)
		}
		
		
		for fileURL in fileURLs {
			dataTransferService.sendDataToParentDevice(fileURL: fileURL, completion:  { [weak self] in
				guard let strongSelf = self else {
					return
				}
				strongSelf.persistentDataPointsService.delete(fileURL: fileURL)
				if fileURL == fileURLs.last {
					completion(true)
				}
			})
		}
	}
	
}

extension ContentViewModel: WKExtendedRuntimeSessionDelegate {
	
	func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
		print("extendedRuntimeSessionDidStart")
	}
	
	func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
		print("extendedRuntimeSessionWillExpire")
		stopMotionTracking()
		motionValuesTextRepresentation = "Session expired"
	}
	
	func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
		print("extendedRuntimeSessionDidInvalidateWith: \(error?.localizedDescription ?? "no error")")
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
