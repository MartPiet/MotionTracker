//
//  FolderMonitor.swift
//  MotionTracker
//
//  Created by Martin Pietrowski on 30.10.20.
//

import Foundation

class FolderMonitor {
	
	// MARK: Properties
	
	private var monitoredFolderFileDescriptor: CInt = -1
	private let folderMonitorQueue = DispatchQueue(label: "FilesMonitorQueue", attributes: .concurrent)
	private var folderMonitorSource: DispatchSourceFileSystemObject?
	let url: URL
	
	var folderDidChange: (() -> Void)?

	init(url: Foundation.URL) {
		self.url = url
	}

	func startMonitoring() {
		guard folderMonitorSource == nil && monitoredFolderFileDescriptor == -1 else {
			return
		}
		
		monitoredFolderFileDescriptor = open(url.path, O_EVTONLY)
		
		folderMonitorSource = DispatchSource.makeFileSystemObjectSource(
			fileDescriptor: monitoredFolderFileDescriptor,
			eventMask: .write,
			queue: folderMonitorQueue
		)
		
		folderMonitorSource?.setEventHandler { [weak self] in
			self?.folderDidChange?()
		}
		
		folderMonitorSource?.setCancelHandler { [weak self] in
			guard let strongSelf = self else {
				return
			}
			close(strongSelf.monitoredFolderFileDescriptor)
			strongSelf.monitoredFolderFileDescriptor = -1
			strongSelf.folderMonitorSource = nil
		}

		folderMonitorSource?.resume()
	}

}
