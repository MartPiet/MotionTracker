//
//  TimeStamp.swift
//  RepCounter Extension
//
//  Created by Martin Pietrowski on 18.01.20.
//  Copyright © 2020 Martin Pietrowski. All rights reserved.
//

import Foundation

struct TimeStamp: Codable {
	
    let event: MeasureEvent
    let timeOcurred: TimeInterval
	
}
