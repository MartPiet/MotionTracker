//
//  WatchConnectivityService.swift
//  MotionTracker
//
//  Created by Martin Pietrowski on 28.10.20.
//

import Foundation
import WatchConnectivity

class WatchConnectivitySessionService: NSObject, WCSessionDelegate {
	
	// MARK: - Properties
	
	private var session: WCSession?
	
	override init() {
		super.init()
		setup()
	}
	
	private func setup() {
		if WCSession.isSupported() {
			let session = WCSession.default
			session.delegate = self
			session.activate()
		}
	}
	
	// MARK: - Protocol Conformance
	// MARK: WCSessionDelegate
	
	func sessionDidBecomeInactive(_ session: WCSession) {
		print("\(#function): activationState = \(session.activationState.rawValue)")
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		// Activate the new session after having switched to a new watch.
		session.activate()
	}
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		if let error = error {
			print("Error while completing activation: \(error)")
		} else {
			print("activationDidCompleteWith: \(activationState.rawValue)")
		}
	}
	
	func session(_ session: WCSession, didReceive file: WCSessionFile) {
		saveSession(currentFilePathOfReceivedFile: file.fileURL)
	}
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
		for messageType in message.keys {
			if (message[messageType] as? String) == UserEvent.trackingStarted.rawValue {
				NotificationCenter.default.post(name: Notification.Name("UserEvent.trackingStarted"), object: nil)
			}
		}
	}
	
	
	// Called when a file transfer is done.
	//
	func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
		if let error = error {
			print("Finished transfer with error: \(error)")
		}
	}
	
	// MARK: - Helper
	
	private func saveSession(currentFilePathOfReceivedFile: URL) {
		createDirectoryIfNotExisting()
		let fileTitle = currentFilePathOfReceivedFile.lastPathComponent
		
		guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
			.first?
			.appendingPathComponent("motionTracking", isDirectory: true)
			.appendingPathComponent(fileTitle) else {
				print("Error creating file path.")
				return
		}
		
		
		do {
			print("Move to: \(path), from: \(currentFilePathOfReceivedFile)")
			
			try FileManager.default.moveItem(at: currentFilePathOfReceivedFile, to: path)
		} catch {
			print("Moving session file failed: \(error)")
		}
	}
	
	private func createDirectoryIfNotExisting() {
		guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
			.first?
			.appendingPathComponent("motionTracking", isDirectory: true),
			!FileManager.default.fileExists(atPath: path.path) else { return }
		
		do {
			try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
		} catch {
			print("Creating directory failed: \(error)")
		}
	}
	
}
