//
//  PersistentDataPointsService.swift
//  RepCounter Extension
//
//  Created by Martin Pietrowski on 18.01.20.
//  Copyright © 2020 Martin Pietrowski. All rights reserved.
//

import Foundation

class PersistentDataPointsService {
    
    // MARK: - Inner Types

    enum ContentType {
        case timeStamp
        case measurePoint
        
        var headerString: String {
            switch self {
            case .timeStamp:
                return "timestamp,event"
            case .measurePoint:
                let headerElements = [
                    "timestamp",
                    ",acceleration_x",
                    ",acceleration_y",
                    ",acceleration_z",
                    ",attitude_pitch",
                    ",attitude_roll",
                    ",attitude_yaw",
                    ",gravity_x",
                    ",gravity_y",
                    ",gravity_z",
                    ",rotation_x",
                    ",rotation_y",
                    ",rotation_z"
                ]
                return headerElements.joined()
            }
        }
    }
    
    private struct Constants {
        static let directoryName = "motionTracking"
        static let fileExtension = "csv"
    }
    
    // MARK: - Properties
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-dd-MM_HH-mm-ss"
        return dateFormatter
    }()
        
    private lazy var directoryFilePath: URL! = {
        createDirectoryIfNotExisting()
        
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(Constants.directoryName, isDirectory: true)
    }()
    
	private func measurePointFilePath(startDate date: Date) -> URL? {
        let fileTitle = "\(dateFormatter.string(from: date))_measurePoints"
		return retrieveFilePath(fromFileTitle: fileTitle)
    }
	
	private func timeStampFilePath(startDate date: Date) -> URL? {
		let fileTitle = "\(dateFormatter.string(from: date))_timeStamps"
		return retrieveFilePath(fromFileTitle: fileTitle)
	}
	
	private func retrieveFilePath(fromFileTitle fileTitle: String) -> URL? {
		return directoryFilePath?
			.appendingPathComponent(fileTitle)
			.appendingPathExtension(Constants.fileExtension)
	}
    
    // MARK: - API
	
	func save(timeStamp: TimeStamp, startDate date: Date) {
		if let path = timeStampFilePath(startDate: date),
			let encoded = "\(timeStamp.timeOcurred),\(timeStamp.event)\n".data(using: .utf8) {
			save(data: encoded, path: path, contentType: .timeStamp)
		}
	}
    
	func save(measurePoints: [MotionMeasurePoint], startDate date: Date) {
		guard let path = measurePointFilePath(startDate: date),
            let data = parseMeasureDate(measurePoints: measurePoints).data(using: .utf8) else { return }
        
        save(data: data, path: path, contentType: .measurePoint)
    }
    
    private func parseMeasureDate(measurePoints: [MotionMeasurePoint]) -> String {
        var measurePointsStrings = ""
        
        measurePoints.forEach {
            let dataAtTimeStamp = [
                $0.acceleration[0],
                $0.acceleration[1],
                $0.acceleration[2],
                $0.attitude[0],
                $0.attitude[1],
                $0.attitude[2],
                $0.gravity[0],
                $0.gravity[1],
                $0.gravity[2],
                $0.rotation[0],
                $0.rotation[1],
                $0.rotation[2]
            ]
            let dataString = dataAtTimeStamp
                .map { "\($0)" }
                .joined(separator: ",")
            
            measurePointsStrings.append("\($0.timestamp),\(dataString)\n")
        }
        return measurePointsStrings
    }
    
    private func save(data: Data, path: URL, contentType: ContentType) {
        if FileManager.default.fileExists(atPath: path.path) {
            do {
                let fileHandle = try FileHandle(forWritingTo: path)
                try fileHandle.seek(toOffset: fileHandle.seekToEndOfFile())
                fileHandle.write(data)
                fileHandle.closeFile()
            } catch {
                print("Saving session file failed: \(error)")
            }
        } else {
            do {
                var header = contentType.headerString
                header.append("\n")
                guard var headerData = header.data(using: .utf8) else {
                    print("Creating header data failed.")
                    return
                }
                headerData.append(data)
                try headerData.write(to: path)
            } catch {
                print("Saving session file failed: \(error)")
            }
        }
    }
	
	func delete(fileURL: URL) {
		if FileManager.default.fileExists(atPath: fileURL.path) {
			do {
				try FileManager.default.removeItem(atPath: fileURL.path)
			} catch {
				print("Deleting file failed.")
			}
		}
	}
    
    func retrieveSessionFileURLs() -> [URL] {
        let fileManager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let documentsURL = URL(fileURLWithPath: documentsPath + "/\(Constants.directoryName)/")
        var fileURLs = [URL]()
        
        do {
            fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        
        return fileURLs
    }
    
    // MARK: - Helpers
    
    private func createDirectoryIfNotExisting() {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(Constants.directoryName, isDirectory: true),
            !FileManager.default.fileExists(atPath: path.path) else { return }
        
        do {
            try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Creating directory failed: \(error)")
        }
    }
	
}
