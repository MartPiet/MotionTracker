//
//  MainView.swift
//  MotionTracker
//
//  Created by Martin Pietrowski on 29.10.20.
//

import SwiftUI

struct MenuView: View {
	
	private let fileDirectory = FileManager.default.urls(
		for: .documentDirectory,
		in: .userDomainMask
	)
	.first!
	.appendingPathComponent("motionTracking", isDirectory: true)
	
	var body: some View {
		TabView {
			MotionTaggingView().tabItem {
				Text("MotionTagging")
				
			}
			FileManagerView(fileDirectoryURL: fileDirectory).tabItem {
				Text("Files")
			}
		}
	}
	
}

struct MenuView_Previews: PreviewProvider {
	
	static var previews: some View {
		MenuView()
	}
	
}
