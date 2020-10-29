//
//  MeasureInterfaceController.swift
//  RepCounter Extension
//
//  Created by Martin Pietrowski on 11.01.20.
//  Copyright © 2020 Martin Pietrowski. All rights reserved.
//

import WatchKit
import CoreMotion

class MeasureInterfaceController: WKInterfaceController, MeasureInterfaceModelDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var dataLabel: WKInterfaceLabel!
    @IBOutlet weak var expirationTimer: WKInterfaceTimer!
	@IBOutlet weak var repetitionsLabel: WKInterfaceLabel!
	@IBOutlet weak var recognisedLabel: WKInterfaceLabel!
	
    private let interfaceModel = MeasureInterfaceModel()
    
    // MARK: - Initialisation
    
    override init() {
        super.init()
        interfaceModel.delegate = self
    }
    
    // MARK: - View Lifecycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        interfaceModel.startSession()
    }

    override func willDisappear() {
        interfaceModel.finishSession()
    }
    
    @IBAction func addBeginExerciseTag() {
        interfaceModel.tagTimeStamp(for: .exerciseBegin)
    }
    
    @IBAction func addEndExerciseTag() {
        interfaceModel.tagTimeStamp(for: .exerciseEnd)
    }
    
    // MARK: - Protocol Conformance
    // MARK: MeasureInterfaceModelDelegate
    
    func measurePointsUpdated(_ interfaceModel: MeasureInterfaceModel,
                              measurePointDescription: String?,
                              error: Error?) {
        if let error = error {
            dataLabel.setText("Error: \(error)")
            return
        }
        guard let measurePointDescription = measurePointDescription else { return }
        dataLabel.setText(measurePointDescription)
        
    }
    
    func sessionExpirationDateUpdated(_ interfaceModel: MeasureInterfaceModel, expirationDate: Date) {
        expirationTimer.setDate(expirationDate)
        expirationTimer.start()
    }
	
	func didUpdateRecognisedRepetitons(repetitions: Int) {
		repetitionsLabel.setText("Repetitions: \(repetitions)")
	}
	
	func didRecognise(label: String) {
		recognisedLabel.setText("R: \(label)")
	}
	
}
