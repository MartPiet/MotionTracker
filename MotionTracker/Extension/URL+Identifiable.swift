//
//  URL+Identifiable.swift
//  MotionTracker
//
//  Created by Martin Pietrowski on 30.10.20.
//

import Foundation

extension URL: Identifiable {
	
	public var id: String {
		return lastPathComponent
	}
	
}
