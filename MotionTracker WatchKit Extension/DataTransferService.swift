//
//  DataTransferService.swift
//  MotionTracker WatchKit Extension
//
//  Created by Martin Pietrowski on 29.10.20.
//

import WatchConnectivity

class DataTransferService: NSObject {
	
	private let session = WCSession.default
	private var progressObservings = [URL: NSKeyValueObservation]()
	
	override init() {
		super.init()
		
		if WCSession.isSupported() {
		   session.delegate = self
		   session.activate()
		} else {
			print("Watch connectivity Session not supported!")
		}
	}
	
	func sendDataToParentDevice(fileURL: URL, completion: (() -> Void)? = nil) {
		print("Sending data")
		let fileTransfer = WCSession.default.transferFile(fileURL, metadata: nil)
		progressObservings[fileURL] = fileTransfer.progress.observe(\.isFinished) { [weak self] progress, _ in
			print("Progress...\(progress.fractionCompleted)")
			if fileTransfer.progress.isFinished {
				guard let strongSelf = self else {
					return
				}
				completion?()
				strongSelf.progressObservings[fileURL]?.invalidate()
				strongSelf.progressObservings.removeValue(forKey: fileURL)
				print("Sending completed!")
			}
		}
	}
	
}


extension DataTransferService: WCSessionDelegate {
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		print("Watch connectivity activated")
	}
	
}
