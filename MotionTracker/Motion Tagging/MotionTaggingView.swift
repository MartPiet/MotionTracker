//
//  MotionTaggingView.swift
//  MotionTracker
//
//  Created by Martin Pietrowski on 29.10.20.
//

import SwiftUI

struct MotionTaggingView: View {
	
	private let viewModel = MotionTaggingViewModel()
	
	var body: some View {
		
		HStack {
			Spacer()
			VStack {
				HStack() {
					Button("New Session") {
						viewModel.startSession()
					}
					Spacer()
				}
				Spacer()
				Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
					Ellipse()
						.foregroundColor(.blue)
				})
				.frame(width: 200, height: 200)
				Spacer()
			}
			Spacer()
		}
		.onLongPressGesture(minimumDuration: 0.2, maximumDistance: 50, pressing: { isPressing in
			self.viewModel.tagMotionEvent(date: Date(), isBeginTag: isPressing)
		}, perform: {})

	}
	
}

struct MotionTaggingView_Previews: PreviewProvider {
	
	static var previews: some View {
		MotionTaggingView()
	}
	
}
