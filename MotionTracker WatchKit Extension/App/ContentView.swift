//
//  ContentView.swift
//  MotionTracker WatchKit Extension
//
//  Created by Martin Pietrowski on 25.10.20.
//

import SwiftUI

struct ContentView: View {
	
	// Wenn ich viewmodel hier initialisiere, wird das view model deallocated wenn
	// die App inaktiv wird. Wieso?
	@ObservedObject private var viewModel: ContentViewModel
	
	init(viewModel: ContentViewModel = ContentViewModel()) {
		self.viewModel = viewModel
	}
	
	var body: some View {
		VStack {
			VStack {
				VStack {
					Text(viewModel.motionValuesTextRepresentation)
						.padding()
				}
				Spacer()
				HStack {
					Button(action: viewModel.toggleMotionTracking) {
						Text(viewModel.motionTrackingButtonTitle)
					}.disabled(!viewModel.isFinished)
				}
			}
		}
	}
	
}

struct ContentView_Previews: PreviewProvider {
	
    static var previews: some View {
		ContentView()
    }
	
}
