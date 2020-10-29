//
//  MeasureInterfaceModel.swift
//  RepCounter Extension
//
//  Created by Martin Pietrowski on 18.01.20.
//  Copyright © 2020 Martin Pietrowski. All rights reserved.
//

import WatchKit
import CoreMotion

protocol MotionManagerDelegate: AnyObject {

	func measurePointsUpdated(_ interfaceModel: MotionManager, measurePointDescription: String?, error: Error?)
	func sessionExpirationDateUpdated(_ interfaceModel: MotionManager, expirationDate: Date)
	func didUpdateRecognisedRepetitons(repetitions: Int)
	func didRecognise(label: String)

}

class MotionManager: NSObject {
	
	// MARK: - Properties
	
	private let motionManager: CMMotionManager = {
		let motionManager = CMMotionManager()
		motionManager.deviceMotionUpdateInterval = 1.0 / 20
		return motionManager
	}()
	
	var isRunning: Bool {
		motionManager.isDeviceMotionActive
	}
	
	private var recognisedRepetitions = 0 {
		didSet {
			delegate?.didUpdateRecognisedRepetitons(repetitions: recognisedRepetitions)
		}
	}
	private var measurePoints = [MotionMeasurePoint]()
	private var scheduledAutoSavingAction: Timer?
	
	private let persistentMeasurePointsService = PersistentDataPointsService()
	
	private var dateStarted: Date? = nil
	
	weak var delegate: MotionManagerDelegate?

	
	// MARK: - API
	
	func startSession() {
		autosaveMeasurePoints()
		
		motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
			self?.handleMotionUpdate(motion: motion, error: error)
		}
		
		dateStarted = Date()
	}
	
	func stopSession() {
		motionManager.stopDeviceMotionUpdates()
		scheduledAutoSavingAction?.invalidate()
	}
	
	func finishSession() {
		measurePoints.removeAll()
		motionManager.stopDeviceMotionUpdates()
		scheduledAutoSavingAction?.invalidate()
	}
	
	// MARK: - Helper
	
	private func autosaveMeasurePoints(everySeconds seconds: Double = 1.0) {
		scheduledAutoSavingAction = Timer
			.scheduledTimer(withTimeInterval: seconds, repeats: true) { [weak self] _ in
				DispatchQueue.global(qos: .utility).sync {
					guard let strongSelf = self else {
						return
					}
					let measurePointsToSave = strongSelf.measurePoints
					strongSelf.measurePoints.removeAll()
					strongSelf.persistentMeasurePointsService.save(measurePoints: measurePointsToSave, startDate: strongSelf.dateStarted!)
				}
			}
	}
	
	private func handleMotionUpdate(motion: CMDeviceMotion?, error: Error?) {
		guard let motion = motion else { return }
		
		if let error = error {
			delegate?.measurePointsUpdated(self, measurePointDescription: nil, error: error)
		}
				
		let attitude = (pitch: motion.attitude.pitch,
						roll: motion.attitude.roll,
						yaw: motion.attitude.yaw)
		let userAcceleration = (x: motion.userAcceleration.x,
								y: motion.userAcceleration.y,
								z: motion.userAcceleration.z)
		let gravity = (x: motion.gravity.x,
					   y: motion.gravity.y,
					   z: motion.gravity.z)
		let rotationRate = (x: motion.rotationRate.x,
							y: motion.rotationRate.y,
							z: motion.rotationRate.z)
		
		let measurePointDescription = """
        \(retrieveDescription(for: attitude, measurePointEntryType: .att))
        \(retrieveDescription(for: userAcceleration, measurePointEntryType: .acc))
        \(retrieveDescription(for: gravity, measurePointEntryType: .gra))
        \(retrieveDescription(for: rotationRate, measurePointEntryType: .rot))
        """
		
		let measurePoint = MotionMeasurePoint(
			timestamp: Date().timeIntervalSince1970,
			attitude:
				[attitude.pitch, attitude.roll, attitude.yaw],
			acceleration:
				[userAcceleration.x, userAcceleration.y, userAcceleration.z],
			gravity:
				[gravity.x, gravity.y, gravity.z],
			rotation:
				[rotationRate.x, rotationRate.y, rotationRate.z ]
		)
		
		measurePoints.append(measurePoint)
		
		delegate?.measurePointsUpdated(self, measurePointDescription: measurePointDescription, error: nil)
	}
	
	private func retrieveDescription(
		for measurePoint: (Double, Double, Double),
		measurePointEntryType: MeasurePointEntryDescriptionIdentifier
	) -> String {
		let typeIdentifier = measurePointEntryType.rawValue
		let pointA = measurePoint.0.shortString
		let pointB = measurePoint.1.shortString
		let pointC = measurePoint.2.shortString
		
		return "\(typeIdentifier): \(pointA), \(pointB), \(pointC)"
	}
}
