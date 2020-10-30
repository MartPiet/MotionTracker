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
					Text(file.lastPathComponent)
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


