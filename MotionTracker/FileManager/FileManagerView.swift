//
//  FileManagerView.swift
//  MotionTracker
//
//  Created by Martin Pietrowski on 25.10.20.
//

import SwiftUI

struct FileManagerView: View {
	
	@ObservedObject var directory: DirectoryObservable
	
	init(fileDirectoryURL: URL) {
		directory = DirectoryObservable(directoryURL: fileDirectoryURL)
	}
	
	var body: some View {
		NavigationView {
			List() {
				ForEach(directory.files, id: \.self) { file in
					Button(file.lastPathComponent) {
						openShareMenu(path: file)
					}
				}
				.onDelete(perform: { indexSet in
					indexSet.forEach { index in
						try? FileManager.default.removeItem(at: directory.files[index])
					}
				})
			}
			.navigationBarTitle("Files")
		}
	}
	
	func deleteFile() {
		try? FileManager.default.removeItem(at: directory.files.first!)
	}
	
	private func openShareMenu(path: URL) {
		let activityViewController = UIActivityViewController(
			activityItems: [path],
			applicationActivities: nil
		)
		
		activityViewController.excludedActivityTypes = [
			.addToReadingList,
			.assignToContact,
			.openInIBooks,
			.saveToCameraRoll,
		]
		
		UIApplication.shared.windows.first?.rootViewController?.present(
			activityViewController,
			animated: true,
			completion: nil
		)
	}
	
}

struct ContentView_Previews: PreviewProvider {
	
	static var previews: some View {
		let fileDirectoryURL = FileManager.default.urls(
			for: .documentDirectory,
			in: .userDomainMask
		)
		.first!
		FileManagerView(fileDirectoryURL: fileDirectoryURL)
	}
	
}


