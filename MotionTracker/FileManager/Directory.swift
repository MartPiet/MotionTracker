//
//  Directory.swift
//  MotionTracker
//
//  Created by Martin Pietrowski on 30.10.20.
//

import Foundation

class DirectoryObservable: ObservableObject {
	
	@Published var files: [URL] = []
	
	private let directoryURL: URL
	
	private lazy var folderMonitor = FolderMonitor(url: directoryURL)
	
	init(directoryURL: URL) {
		self.directoryURL = directoryURL
		
		if !FileManager.default.fileExists(atPath: directoryURL.path) {
			do {
				try FileManager.default.createDirectory(
					at: directoryURL,
					withIntermediateDirectories: false,
					attributes: nil
				)
			} catch {
				print("Creating empty directory failed.")
			}
		}
		
		folderMonitor.folderDidChange = { [weak self] in
			self?.handleChanges()
		}
		
		folderMonitor.startMonitoring()
		handleChanges()
	}
	
	func handleChanges() {
		let files = try! FileManager.default.contentsOfDirectory(
			at: directoryURL,
			includingPropertiesForKeys: nil,
			options: .producesRelativePathURLs
		)
		DispatchQueue.main.async {
			self.files = files
		}
	}
	
}
