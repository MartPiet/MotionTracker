//
//  MainView.swift
//  MotionTracker
//
//  Created by Martin Pietrowski on 29.10.20.
//

import SwiftUI

struct MenuView: View {
	
	var body: some View {
		TabView {
			MotionTaggingView().tabItem { Text("MotionTagging") }.tag(1)
			FileManagerView().tabItem { Text("Files") }.tag(2)
		}
	}
	
}

struct MenuView_Previews: PreviewProvider {
	
	static var previews: some View {
		MenuView()
	}
	
}
