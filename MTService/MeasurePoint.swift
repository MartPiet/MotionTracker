//
//  MeasurePoint.swift
//  RepCounter Extension
//
//  Created by Martin Pietrowski on 18.01.20.
//  Copyright © 2020 Martin Pietrowski. All rights reserved.
//

import Foundation

struct MotionMeasurePoint: Codable {
	
    let timestamp: TimeInterval
    let attitude: [Double]
    let acceleration: [Double]
    let gravity: [Double]
    let rotation: [Double]
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "t"
        case attitude = "at"
        case acceleration = "ac"
        case gravity = "g"
        case rotation = "r"
    }
	
}
